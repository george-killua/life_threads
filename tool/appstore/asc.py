"""App Store Connect through its API (no fastlane, no extra Python packages).

    # Key: secrets/AuthKey_<KEY ID>.p8 (gitignored), or ASC_KEY_PATH;
    # ASC_ISSUER_ID overrides the team's issuer id below.
    python3 tool/appstore/asc.py status
    python3 tool/appstore/asc.py listing texts.json store_listing_assets/store_screenshots
    python3 tool/appstore/asc.py build 23
    python3 tool/appstore/asc.py urls

`listing` works on the version that can be edited (Prepare for Submission or
Developer Rejected): name and subtitle, description, keywords and promotional
text and What's New per language (JSON {"en-US": {"name", "subtitle",
"description", "keywords", "promotionalText", "whatsNew"}, ...}); languages
the listing doesn't have yet are added (one App Store Connect refuses is
skipped and named). It replaces the screenshots of each display type with
the PNGs from the matching folder, in file-name order.
`build` selects that build for the version. Nothing is submitted for review.

The token is an ES256 JWT signed with openssl, valid for 15 minutes. The key
never leaves the file; nothing here prints or stores it.
"""
import base64
import glob
import hashlib
import json
import os
import re
import subprocess
import sys
import time
import urllib.error
import urllib.request

BUNDLE_ID = 'dev.gkcoding.lifeThreads'
# The team's issuer id (Users and Access → Integrations); not a secret.
ISSUER_ID = '54abbaa3-564f-4789-a6ee-f63202185418'
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..')


def _key_path():
    if os.environ.get('ASC_KEY_PATH'):
        return os.path.expanduser(os.environ['ASC_KEY_PATH'])
    keys = sorted(glob.glob(os.path.join(ROOT, 'secrets', 'AuthKey_*.p8')))
    if not keys:
        sys.exit('No App Store Connect key in secrets/ (AuthKey_<KEY ID>.p8).')
    return keys[0]
API = 'https://api.appstoreconnect.apple.com'


def _b64(data):
    return base64.urlsafe_b64encode(data).rstrip(b'=')


def _der_to_raw(der):
    """openssl gives an ASN.1 (r, s) signature; JWT wants r || s, 32 bytes each."""
    def read_int(buf, i):
        assert buf[i] == 0x02
        n = buf[i + 1]
        value = buf[i + 2:i + 2 + n]
        return value.lstrip(b'\0').rjust(32, b'\0'), i + 2 + n
    assert der[0] == 0x30
    i = 2 if der[1] < 0x80 else 3
    r, i = read_int(der, i)
    s, _ = read_int(der, i)
    return r + s


def token():
    key = _key_path()
    kid = re.search(r'AuthKey_([A-Z0-9]+)\.p8$', key).group(1)
    now = int(time.time())
    header = _b64(json.dumps({'alg': 'ES256', 'kid': kid, 'typ': 'JWT'}).encode())
    claims = _b64(json.dumps({
        'iss': os.environ.get('ASC_ISSUER_ID', ISSUER_ID), 'iat': now, 'exp': now + 900,
        'aud': 'appstoreconnect-v1'}).encode())
    signing_input = header + b'.' + claims
    der = subprocess.run(['openssl', 'dgst', '-sha256', '-sign', key],
                         input=signing_input, capture_output=True, check=True).stdout
    return (signing_input + b'.' + _b64(_der_to_raw(der))).decode()


class ApiError(Exception):
    pass


def call(method, path, body=None, fatal=True):
    # Apple's API sometimes answers 500 or 503 for a moment: try again.
    for attempt in range(4):
        try:
            return _call(method, path, body)
        except _Retry:
            time.sleep(5 * (attempt + 1))
        except ApiError as error:
            if fatal:
                sys.exit(str(error))
            raise
    message = f'{method} {path} -> server error after retries'
    if fatal:
        sys.exit(message)
    raise ApiError(message)


class _Retry(Exception):
    pass


def _call(method, path, body=None):
    request = urllib.request.Request(
        API + path, method=method,
        data=None if body is None else json.dumps(body).encode(),
        headers={'Authorization': 'Bearer ' + token(),
                 'Content-Type': 'application/json'})
    try:
        with urllib.request.urlopen(request) as response:
            raw = response.read()
            return json.loads(raw) if raw else {}
    except urllib.error.HTTPError as error:
        if error.code >= 500:
            raise _Retry()
        raise ApiError(f'{method} {path} -> {error.code}: {error.read().decode()[:1200]}')


def app_id():
    apps = call('GET', f'/v1/apps?filter[bundleId]={BUNDLE_ID}')['data']
    return apps[0]['id']


# Display type -> screenshot folder (store_listing_assets/store_screenshots/).
SCREENSHOT_FOLDERS = {
    'APP_IPHONE_67': 'ios-6.9',
    'APP_IPHONE_61': 'ios-6.3',
    'APP_IPAD_PRO_3GEN_129': 'ios-ipad-13',
}
LANG_FOLDER = {
    'en-US': 'en', 'de-DE': 'de', 'ar-SA': 'ar', 'es-ES': 'es', 'es-MX': 'es',
    'fr-FR': 'fr', 'it': 'it', 'pt-BR': 'pt', 'tr': 'tr', 'pl': 'pl', 'ru': 'ru',
    'hi': 'hi', 'ja': 'ja', 'ko': 'ko', 'zh-Hans': 'zh',
}
PRIVACY_URL = 'https://gkcoding.dev/lifethreads/privacy/'

EDITABLE = {'PREPARE_FOR_SUBMISSION', 'DEVELOPER_REJECTED', 'REJECTED',
            'METADATA_REJECTED', 'INVALID_BINARY'}


def editable_version(aid):
    for v in call('GET', f'/v1/apps/{aid}/appStoreVersions?limit=10')['data']:
        if (v['attributes'].get('appStoreState') or '') in EDITABLE:
            return v
    sys.exit('No version that can be edited.')


def upload_screenshot(set_id, path):
    data = open(path, 'rb').read()
    reserved = call('POST', '/v1/appScreenshots', {'data': {
        'type': 'appScreenshots',
        'attributes': {'fileName': os.path.basename(path), 'fileSize': len(data)},
        'relationships': {'appScreenshotSet': {'data': {
            'type': 'appScreenshotSets', 'id': set_id}}}}})['data']
    for op in reserved['attributes']['uploadOperations']:
        part = data[op['offset']:op['offset'] + op['length']]
        request = urllib.request.Request(op['url'], data=part, method=op['method'],
            headers={h['name']: h['value'] for h in op.get('requestHeaders', [])})
        urllib.request.urlopen(request).read()
    call('PATCH', f"/v1/appScreenshots/{reserved['id']}", {'data': {
        'type': 'appScreenshots', 'id': reserved['id'],
        'attributes': {'uploaded': True,
                       'sourceFileChecksum': hashlib.md5(data).hexdigest()}}})
    return reserved['id']


def replace_screenshots(loc_id, lang, root):
    sets = {s['attributes']['screenshotDisplayType']: s['id'] for s in
            call('GET', f'/v1/appStoreVersionLocalizations/{loc_id}/appScreenshotSets')['data']}
    for display, folder in SCREENSHOT_FOLDERS.items():
        files = sorted(glob.glob(os.path.join(root, folder, LANG_FOLDER[lang], '*.png')))[:10]
        if not files:
            continue
        set_id = sets.get(display) or call('POST', '/v1/appScreenshotSets', {'data': {
            'type': 'appScreenshotSets',
            'attributes': {'screenshotDisplayType': display},
            'relationships': {'appStoreVersionLocalization': {'data': {
                'type': 'appStoreVersionLocalizations', 'id': loc_id}}}}})['data']['id']
        for old in call('GET', f'/v1/appScreenshotSets/{set_id}/appScreenshots')['data']:
            call('DELETE', f"/v1/appScreenshots/{old['id']}")
        ids = [upload_screenshot(set_id, f) for f in files]
        call('PATCH', f'/v1/appScreenshotSets/{set_id}/relationships/appScreenshots',
             {'data': [{'type': 'appScreenshots', 'id': i} for i in ids]})
        print('  ', lang, display, len(ids))


def copy_urls(version_id):
    """Every language gets the English support and marketing URL: App Store
    Connect leaves them empty on a language added through the API, and won't
    start a review without a support URL."""
    locs = call('GET', f'/v1/appStoreVersions/{version_id}/appStoreVersionLocalizations')['data']
    english = next(l['attributes'] for l in locs if l['attributes']['locale'] == 'en-US')
    urls = {k: english[k] for k in ('supportUrl', 'marketingUrl') if english.get(k)}
    for loc in locs:
        missing = {k: v for k, v in urls.items() if not loc['attributes'].get(k)}
        if missing:
            call('PATCH', f"/v1/appStoreVersionLocalizations/{loc['id']}", {'data': {
                'type': 'appStoreVersionLocalizations', 'id': loc['id'],
                'attributes': missing}})
            print('urls', loc['attributes']['locale'], ', '.join(missing))
    return urls


if __name__ == '__main__':
    if sys.argv[1:] == ['status']:
        aid = app_id()
        print('app', aid)
        versions = call('GET', f'/v1/apps/{aid}/appStoreVersions?limit=5')['data']
        for v in versions:
            a = v['attributes']
            print('version', a['versionString'], a.get('appStoreState') or a.get('appVersionState'), v['id'])
        builds = call('GET', f'/v1/builds?filter[app]={aid}&sort=-uploadedDate&limit=4')['data']
        for b in builds:
            a = b['attributes']
            print('build', a['version'], a['processingState'], a['uploadedDate'][:16])
    elif sys.argv[1:] == ['urls']:
        print(copy_urls(editable_version(app_id())['id']))
    elif sys.argv[1] == 'listing':
        texts = json.load(open(sys.argv[2]))
        root = sys.argv[3]
        aid = app_id()
        version = editable_version(aid)
        print('version', version['attributes']['versionString'],
              version['attributes']['appStoreState'])
        info = next(i for i in call('GET', f'/v1/apps/{aid}/appInfos')['data']
                    if (i['attributes'].get('appStoreState') or '') in EDITABLE)
        info_locs = {l['attributes']['locale']: l['id'] for l in
                     call('GET', f"/v1/appInfos/{info['id']}/appInfoLocalizations")['data']}
        version_locs = {l['attributes']['locale']: l['id'] for l in call(
            'GET', f"/v1/appStoreVersions/{version['id']}/appStoreVersionLocalizations")['data']}
        skipped = []
        for lang, t in texts.items():
            version_texts = {'description': t['description'], 'keywords': t['keywords'],
                             'promotionalText': t['promotionalText']}
            if t.get('whatsNew'):
                version_texts['whatsNew'] = t['whatsNew']
            try:
                # A language the listing doesn't have yet is added.
                if lang not in info_locs:
                    info_locs[lang] = call('POST', '/v1/appInfoLocalizations', {'data': {
                        'type': 'appInfoLocalizations',
                        'attributes': {'locale': lang, 'name': t['name'],
                                       'subtitle': t['subtitle'],
                                       'privacyPolicyUrl': PRIVACY_URL},
                        'relationships': {'appInfo': {'data': {
                            'type': 'appInfos', 'id': info['id']}}}}},
                        fatal=False)['data']['id']
                    # App Store Connect adds the language to the version by
                    # itself: look again before adding it there.
                    version_locs = {l['attributes']['locale']: l['id'] for l in call(
                        'GET', f"/v1/appStoreVersions/{version['id']}/appStoreVersionLocalizations")['data']}
                else:
                    call('PATCH', f'/v1/appInfoLocalizations/{info_locs[lang]}', {'data': {
                        'type': 'appInfoLocalizations', 'id': info_locs[lang],
                        'attributes': {'name': t['name'], 'subtitle': t['subtitle']}}},
                        fatal=False)
                if lang not in version_locs:
                    version_locs[lang] = call('POST', '/v1/appStoreVersionLocalizations', {'data': {
                        'type': 'appStoreVersionLocalizations',
                        'attributes': {'locale': lang, **version_texts},
                        'relationships': {'appStoreVersion': {'data': {
                            'type': 'appStoreVersions', 'id': version['id']}}}}},
                        fatal=False)['data']['id']
                else:
                    call('PATCH', f'/v1/appStoreVersionLocalizations/{version_locs[lang]}', {'data': {
                        'type': 'appStoreVersionLocalizations', 'id': version_locs[lang],
                        'attributes': version_texts}}, fatal=False)
            except ApiError as error:
                print('skipped', lang, '-', error)
                skipped.append(lang)
                continue
            print('texts', lang)
            replace_screenshots(version_locs[lang], lang, root)
        copy_urls(version['id'])
        if skipped:
            print('not uploaded:', ', '.join(skipped))
    elif sys.argv[1] == 'build':
        aid = app_id()
        version = editable_version(aid)
        builds = call('GET', f'/v1/builds?filter[app]={aid}&filter[version]={sys.argv[2]}')['data']
        call('PATCH', f"/v1/appStoreVersions/{version['id']}/relationships/build",
             {'data': {'type': 'builds', 'id': builds[0]['id']}})
        print('build', sys.argv[2], 'selected for', version['attributes']['versionString'])
    else:
        sys.exit(__doc__)
