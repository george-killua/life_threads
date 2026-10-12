'use strict';

// Starts the real family wall API (router, store, SQLite, encrypted blobs on
// disk) from the server repo on a random local port, for
// test/family/integration/family_server_integration_test.dart. Sign-in uses
// local test issuer keys and subscriptions a fake Play verifier, like the
// server's own tests (backend/testing/family-harness.js).
//
//   node family_server_launcher.js <path to gk_coding_website/backend>
//
// Prints one JSON line {baseUrl, dataDir}, then answers stdin commands:
//   token <apple|google> <subject> [nonce claim] -> {"idToken": "..."}
//   purchase <token>                 -> marks a Play purchase token active
//   quit

const fs = require('node:fs/promises');
const http = require('node:http');
const os = require('node:os');
const path = require('node:path');
const readline = require('node:readline');

async function main() {
  const backend = path.resolve(process.argv[2] || '.');
  const req = (p) => require(path.join(backend, p));
  const express = req('node_modules/express');
  const { makeIssuerKeys, fakeVerifier, jose, DAY, APPLE_AUD, GOOGLE_AUD } = req('testing/family-harness.js');
  const { createFamilyFeature } = req('src/family');
  const { readFamilyConfig } = req('src/family/config');

  const dataDir = await fs.mkdtemp(path.join(os.tmpdir(), 'lifethreads-family-it-'));
  const keys = { apple: await makeIssuerKeys(), google: await makeIssuerKeys() };
  const config = readFamilyConfig(
    {
      LIFETHREADS_FAMILY_DIR: dataDir,
      LIFETHREADS_APPLE_SIGNIN_AUDIENCES: APPLE_AUD,
      LIFETHREADS_GOOGLE_SIGNIN_CLIENT_IDS: GOOGLE_AUD,
      LIFETHREADS_FAMILY_TERMS_VERSION: '2026-10',
    },
    { lifeThreadsBaseUrl: 'https://lifethreads.gkcoding.dev' },
  );
  const google = fakeVerifier();
  const feature = createFamilyFeature({
    config,
    jwks: { apple: keys.apple.jwks, google: keys.google.jwks },
    verifiers: { google, apple: fakeVerifier() },
    mailer: { sendMail: async () => {} },
    skipRateLimits: true,
    logger: { error() {}, warn() {}, log() {} },
  });
  const app = express();
  app.use('/api/lifethreads/family', feature.router);
  const server = http.createServer(app);
  await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
  const baseUrl = `http://127.0.0.1:${server.address().port}/api/lifethreads/family`;

  const reply = (value) => process.stdout.write(`${JSON.stringify(value)}\n`);
  reply({ baseUrl, dataDir });

  const lines = readline.createInterface({ input: process.stdin });
  for await (const line of lines) {
    const [command, ...args] = line.trim().split(/\s+/);
    try {
      if (command === 'token') {
        const [provider, sub, nonce] = args;
        const { SignJWT } = await jose();
        const idToken = await new SignJWT(nonce ? { nonce } : {})
          .setProtectedHeader({ alg: 'RS256', kid: 'test-key' })
          .setIssuer(provider === 'apple' ? 'https://appleid.apple.com' : 'https://accounts.google.com')
          .setAudience(provider === 'apple' ? APPLE_AUD : GOOGLE_AUD)
          .setSubject(sub)
          .setIssuedAt()
          .setExpirationTime('10m')
          .sign(keys[provider].privateKey);
        reply({ idToken });
      } else if (command === 'purchase') {
        google.results[args[0]] = {
          active: true,
          state: 'SUBSCRIPTION_STATE_ACTIVE',
          productId: 'lifethreads_premium_monthly',
          expiresAt: Date.now() + 30 * DAY,
          purchaseKey: `google:${args[0]}`,
        };
        reply({ ok: true });
      } else if (command === 'quit') {
        break;
      } else {
        reply({ error: `unknown command ${command}` });
      }
    } catch (error) {
      reply({ error: String(error && error.message) });
    }
  }
  await new Promise((resolve) => server.close(resolve));
  feature.close();
  await fs.rm(dataDir, { recursive: true, force: true });
  process.exit(0);
}

main().catch((error) => {
  process.stderr.write(`${error && error.stack}\n`);
  process.exit(1);
});
