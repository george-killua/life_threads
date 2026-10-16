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
   - German: `LifeThreads Premium` / `Unbegrenzte Erinnerungen, mehrere Wände, Storys, Faden des Jahres und Familienwände – jährlich abgerechnet.`
   - Arabic: `LifeThreads Premium` / `ذكريات بلا حدود، عدة جدران، قصص، خيط السنة وجدران العائلة – بفوترة سنوية.`
6. Review information: reuse the monthly plan's screenshot (the Premium
   page) and note: "Same benefits as the monthly plan, billed yearly."
7. In the group, put **Yearly above Monthly** (level 1 = yearly, level 2 =
   monthly) so switching from monthly to yearly counts as an upgrade.
8. Submit it with the next app version (build 20 or later).

Status 15 October 2026: created with €34.99, EN/DE/AR localizations,
review screenshot and notes. It goes to review with the next app version
(1.0 is waiting for review).

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
   Play's "Set prices" dialog takes the price **before VAT** and adds the
   country's VAT on top: typing 34.99 gives €41.99 in Austria. So Austria
   was set with 29.16 (+20 % = €34.99) and Germany with 29.40 (+19 % =
   €34.99). Other euro countries keep Play's converted prices (about
   €41.99–43.99) – decided 15 October 2026, leave them as they are.
6. **Activate** the base plan.

Status 15 October 2026: done – subscription `lifethreads_premium_yearly`,
base plan `yearly` active, 14-day grace period. Benefits (max. 40
characters each) and names saved in three languages:

| | English (default) | German | Arabic |
|---|---|---|---|
| Name | LifeThreads Premium (yearly) | LifeThreads Premium (jährlich) | LifeThreads Premium (سنوي) |
| 1 | Unlimited memories | Unbegrenzte Erinnerungen | ذكريات بلا حدود |
| 2 | Several walls and hidden memories | Mehrere Wände, Erinnerungen ausblenden | عدة جدران وذكريات مخفية |
| 3 | Stories, films and Thread of the Year | Stories, Filme und Faden des Jahres | قصص وأفلام وخيط السنة |
| 4 | Family walls, end-to-end encrypted | Familienwände, durchgehend verschlüsselt | جدران العائلة بتشفير تام بين الطرفين |

The monthly subscription still has its older four English benefits only
(no "several walls", no translations); worth aligning later.

## 3. Server (VPS) – family walls must accept the yearly plan

The API only accepts the products listed in its environment. Before this
step both lists contained only the monthly product. Log in with `ssh gkcoding-vps` (the
host alias in `~/.ssh/config` picks the `gkcoding_vps_deploy` key; plain
`deploy@217.160.247.224` fails with "Permission denied (publickey)"). On the
VPS:

```bash
sudo sed -i 's/^LIFETHREADS_APPSTORE_PRODUCT_IDS=.*/LIFETHREADS_APPSTORE_PRODUCT_IDS=lifethreads_premium_monthly,lifethreads_premium_yearly/' /opt/gkcoding/api/.env
sudo sed -i 's/^LIFETHREADS_GOOGLE_PLAY_PRODUCT_IDS=.*/LIFETHREADS_GOOGLE_PLAY_PRODUCT_IDS=lifethreads_premium_monthly,lifethreads_premium_yearly/' /opt/gkcoding/api/.env
sudo systemctl restart gkcoding-api
grep PRODUCT_IDS /opt/gkcoding/api/.env
```

Check first that the API reads a comma-separated list (look for
`PRODUCT_IDS` in the API source on the VPS). `build/configure_subscriptions.sh`
should list both products too, for the next time it runs.

Status 15 October 2026: done by George – both lists contain monthly and
yearly, `gkcoding-api` restarted.

## 4. Website

The Premium, privacy and terms pages (website repo commit `ababd26`) are
ready. Upload only the LifeThreads pages (not the whole site):

```bash
rsync -az ~/Desktop/development/Projects/gk_coding_website/web/lifethreads/ gkcoding-vps:/var/www/subdomains/root/lifethreads/
```

Then check: <https://gkcoding.dev/lifethreads/premium/> shows €34.99 /
year, and <https://gkcoding.dev/lifethreads/privacy/> says "Effective date:
October 15, 2026".
