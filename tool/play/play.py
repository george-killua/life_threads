"""Google Play through the Android Publisher API (no fastlane needed).

    # Key: secrets/google-play-service-account.json (gitignored), or
    # GOOGLE_PLAY_JSON_KEY_PATH to use another file.
    python3 tool/play/play.py tracks
    python3 tool/play/play.py upload build/app/outputs/bundle/release/app-release.aab alpha completed "Release notes"
    python3 tool/play/play.py listing listing.json store_listing_assets/store_screenshots

`listing` sets the store texts (JSON: {"en-US": {"title", "shortDescription",
"fullDescription"}, ...}) and replaces the phone and tablet screenshots, after
saving the current listing to listing-backup.json. The commit sends the
changes to Google's review; they go live once approved (this app has no
managed publishing, so the API cannot hold them back).

Tracks: internal, alpha (closed testing), beta (open testing), production.
Status: completed (rolls out to the track's testers) or draft.
"""
import glob
import json
import os
import socket
import re
import sys
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

# Bundles are over 100 MB: give each request time, and retry on a dropped
# connection (the upload is resumable).
socket.setdefaulttimeout(600)
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..')
KEY = os.environ.get('GOOGLE_PLAY_JSON_KEY_PATH') or os.path.join(
    ROOT, 'secrets', 'google-play-service-account.json')
PKG = 'dev.gkcoding.lifethreads'
creds = service_account.Credentials.from_service_account_file(
    KEY, scopes=['https://www.googleapis.com/auth/androidpublisher'])
api = build('androidpublisher', 'v3', credentials=creds, cache_discovery=False)
edits = api.edits()
edit = edits.insert(packageName=PKG, body={}).execute()
eid = edit['id']
if sys.argv[1] == 'tracks':
    for t in edits.tracks().list(packageName=PKG, editId=eid).execute().get('tracks', []):
        rel = [(r.get('name'), r.get('status'), r.get('versionCodes')) for r in t.get('releases', [])]
        print(t['track'], rel)
    edits.delete(packageName=PKG, editId=eid).execute()
elif sys.argv[1] == 'upload':
    aab, track, status = sys.argv[2], sys.argv[3], sys.argv[4]
    notes = sys.argv[5] if len(sys.argv) > 5 else None
    bundle = edits.bundles().upload(packageName=PKG, editId=eid,
        media_body=MediaFileUpload(aab, mimetype='application/octet-stream', resumable=True,
            chunksize=16 * 1024 * 1024)).execute(num_retries=5)
    vc = bundle['versionCode']
    print('uploaded versionCode', vc)
    version = re.search(r'^version: ([0-9.]+)', open('pubspec.yaml').read(), re.M).group(1)
    release = {'versionCodes': [str(vc)], 'status': status, 'name': f'{version} ({vc})'}
    if notes:
        release['releaseNotes'] = [{'language': 'en-US', 'text': notes}]
    edits.tracks().update(packageName=PKG, editId=eid, track=track,
        body={'track': track, 'releases': [release]}).execute()
    res = edits.commit(packageName=PKG, editId=eid).execute()
    print('committed edit', res.get('id'), 'track', track, 'status', status)
elif sys.argv[1] == 'listing':
    texts = json.load(open(sys.argv[2]))
    shots = sys.argv[3]
    # Play's language codes -> the screenshot folders' languages.
    folder = {'en-US': 'en', 'en-GB': 'en', 'de-DE': 'de', 'ar': 'ar',
              'es-ES': 'es', 'es-419': 'es', 'fr-FR': 'fr', 'it-IT': 'it',
              'pt-BR': 'pt', 'tr-TR': 'tr', 'pl-PL': 'pl', 'ru-RU': 'ru',
              'hi-IN': 'hi', 'ja-JP': 'ja', 'ko-KR': 'ko', 'zh-CN': 'zh'}
    assets = os.path.join(os.path.dirname(os.path.abspath(shots)))
    icon = os.path.join(assets, 'lifethreads_app_icon_512.png')
    slots = {'phoneScreenshots': 'play-phone',
             'sevenInchScreenshots': 'play-tablet-7',
             'tenInchScreenshots': 'play-tablet-10'}
    backup = {}
    for lang in texts:
        try:
            backup[lang] = edits.listings().get(
                packageName=PKG, editId=eid, language=lang).execute()
        except Exception as error:  # a language without a listing yet
            backup[lang] = {'error': str(error)}
    json.dump(backup, open('listing-backup.json', 'w'), ensure_ascii=False, indent=2)
    print('saved the current listing to listing-backup.json')
    for lang, body in texts.items():
        edits.listings().update(packageName=PKG, editId=eid, language=lang,
            body={'language': lang, **body}).execute()
        print('texts', lang)
        # Every language gets the icon and its feature graphic, so none falls
        # back to a missing image.
        graphics = {'icon': icon, 'featureGraphic': os.path.join(
            assets, 'google_play', f'feature_graphic_{folder[lang]}.png')}
        for slot, path in graphics.items():
            if not os.path.exists(path):
                continue
            edits.images().deleteall(packageName=PKG, editId=eid,
                language=lang, imageType=slot).execute()
            edits.images().upload(packageName=PKG, editId=eid, language=lang,
                imageType=slot, media_body=MediaFileUpload(path, mimetype='image/png')).execute()
            print('  ', slot)
        for slot, size in slots.items():
            files = sorted(glob.glob(os.path.join(shots, size, folder[lang], '*.png')))
            if not files:
                continue
            edits.images().deleteall(packageName=PKG, editId=eid,
                language=lang, imageType=slot).execute()
            for path in files[:8]:  # Play takes at most 8 per slot
                edits.images().upload(packageName=PKG, editId=eid, language=lang,
                    imageType=slot, media_body=MediaFileUpload(path, mimetype='image/png')).execute()
            print('  ', slot, len(files[:8]))
    res = edits.commit(packageName=PKG, editId=eid).execute()
    print('committed edit', res.get('id'), '(sent to Google for review)')
