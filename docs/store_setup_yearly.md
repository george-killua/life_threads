# Yearly Premium plan – store and server setup

The app (from build 1.0.0 (20)) shows a yearly plan when the stores offer
`lifethreads_premium_yearly`. Until then it offers monthly alone, so the
order of these steps doesn't break anything. Status lives in
[roadmap.md](roadmap.md), step 2.

## 1. App Store Connect

1. App Store Connect → Apps → **LifeThreads** → Monetization →
   **Subscriptions** → group **LifeThreads Premium**.
2. **Create** (+) a subscription:
   - Reference name: `LifeThreads Premium Yearly`
   - Product ID: `lifethreads_premium_yearly`
3. Subscription duration: **1 year**.
4. Subscription prices → Add → base country **Austria**, price **€34.99**;
   accept the converted prices for other countries.
5. App Store localization (display name / description):
   - English: `LifeThreads Premium` / `Unlimited memories, several walls, stories, Thread of the Year and family walls – billed yearly.`
   - German: `LifeThreads Premium` / `Unbegrenzte Erinnerungen, mehrere Wände, Stories, Faden des Jahres und Familienwände – jährlich abgerechnet.`
   - Arabic: `LifeThreads Premium` / `ذكريات بلا حدود، عدة جدران، قصص، خيط العام وجدران العائلة – بفوترة سنوية.`
6. Review information: reuse the monthly plan's screenshot (the Premium
   page) and note: "Same benefits as the monthly plan, billed yearly."
7. In the group, put **Yearly above Monthly** (level 1 = yearly, level 2 =
   monthly) so switching from monthly to yearly counts as an upgrade.
8. Submit it with the next app version (build 20 or later).

## 2. Google Play Console

1. Play Console → **LifeThreads** → Monetize → Products → **Subscriptions**
   → **Create subscription**.
2. Product ID: `lifethreads_premium_yearly`, name `LifeThreads Premium
   (yearly)`.
3. Benefits (EN/DE/AR, same as the monthly plan).
4. **Add base plan**: ID `yearly`, auto-renewing, billing period **1 year**,
   grace period as for monthly.
5. Price: **€34.99** (Austria/Germany), "Update exchange rates" for the
   other countries.
6. **Activate** the base plan.

## 3. Server (VPS) – family walls must accept the yearly plan

The API only accepts the products listed in its environment. Today both
lists contain only the monthly product. On the VPS:

```bash
sudo sed -i 's/^LIFETHREADS_APPSTORE_PRODUCT_IDS=.*/LIFETHREADS_APPSTORE_PRODUCT_IDS=lifethreads_premium_monthly,lifethreads_premium_yearly/' /opt/gkcoding/api/.env
sudo sed -i 's/^LIFETHREADS_GOOGLE_PLAY_PRODUCT_IDS=.*/LIFETHREADS_GOOGLE_PLAY_PRODUCT_IDS=lifethreads_premium_monthly,lifethreads_premium_yearly/' /opt/gkcoding/api/.env
sudo systemctl restart gkcoding-api
grep PRODUCT_IDS /opt/gkcoding/api/.env
```

Check first that the API reads a comma-separated list (look for
`PRODUCT_IDS` in the API source on the VPS). `build/configure_subscriptions.sh`
should list both products too, for the next time it runs.

## 4. Website

The Premium, privacy and terms pages (website repo commit `ababd26`) are
ready. Upload only the LifeThreads pages (not the whole site):

```bash
rsync -az ~/Desktop/development/Projects/gk_coding_website/web/lifethreads/ deploy@217.160.247.224:/var/www/subdomains/root/lifethreads/
```

Then check: <https://gkcoding.dev/lifethreads/premium/> shows €34.99 /
year, and <https://gkcoding.dev/lifethreads/privacy/> says "Effective date:
October 15, 2026".
