"""Google Play through the Android Publisher API (no fastlane needed).

    export GOOGLE_PLAY_JSON_KEY_PATH=/path/to/service-account.json
    python3 tool/play/play.py tracks
    python3 tool/play/play.py upload build/app/outputs/bundle/release/app-release.aab alpha completed "Release notes"

Tracks: internal, alpha (closed testing), beta (open testing), production.
Status: completed (rolls out to the track's testers) or draft.
"""
import os
import sys
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

KEY = os.environ['GOOGLE_PLAY_JSON_KEY_PATH']
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
        media_body=MediaFileUpload(aab, mimetype='application/octet-stream', resumable=True)).execute()
    vc = bundle['versionCode']
    print('uploaded versionCode', vc)
    release = {'versionCodes': [str(vc)], 'status': status, 'name': f'1.0.0 ({vc})'}
    if notes:
        release['releaseNotes'] = [{'language': 'en-US', 'text': notes}]
    edits.tracks().update(packageName=PKG, editId=eid, track=track,
        body={'track': track, 'releases': [release]}).execute()
    res = edits.commit(packageName=PKG, editId=eid).execute()
    print('committed edit', res.get('id'), 'track', track, 'status', status)
