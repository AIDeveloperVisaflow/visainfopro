# VisaFlowPro v1.1.0 — Live Data Setup Guide

The new build (v1.1.0) of the app can fetch its data **live** instead of only
using the copy bundled inside the APK. There are two independent layers:

| Layer | What it does | Setup needed |
|---|---|---|
| **Live data feed** | App checks for newer visa/country data at every launch + pull-to-refresh | **Upload 2 JSON files to GitHub** (5 min) |
| **Cloud sync** (optional) | Real accounts: favorites & checklists sync across devices | Connect a free Supabase project in **Settings → Cloud sync** |

The app works fully offline in every case: no connection → bundled/cached data.

---

## Part 1 — Go live with GitHub (recommended, no new accounts)

The app looks for two files at (default source):

```
https://raw.githubusercontent.com/AIDeveloperVisaflow/visainfopro/main/
```

### Steps

1. Open your repo: **https://github.com/AIDeveloperVisaflow/visainfopro**
2. Click **Add file → Upload files**.
3. Drag in **both files** from the `github-upload` folder you received:
   - `visaflow-data.json` (the full dataset, ~240 KB)
   - `version.json` (tiny manifest the app checks first)
4. Commit message: anything, e.g. `Add live data feed`.
5. Click **Commit changes**.

Done. On the next app launch: open the app → pull down on the Home screen →
the status under the logo shows `· live v1`. Settings → **Live data** shows the
version, source and last-checked time.

### Updating data later

1. Get updated JSON files (ask me to regenerate them, or edit
   `visaflow-data.json` directly on GitHub with the pencil button).
2. **Important:** bump `"version"` in **both** files (1 → 2) and update
   `"updatedAt"` in `version.json`. The app downloads the big file only when
   the version is newer, so this is what triggers the update.
3. Commit. Users get the new data on next launch or pull-to-refresh — **no new
   APK needed**.

### Different branch or repo?

If your default branch is not `main`, or you want to use another repo:
open the app → **Settings → Live data → Advanced: data source URL** and paste
e.g. `https://raw.githubusercontent.com/AIDeveloperVisaflow/visainfopro/master`.

---

## Part 2 — Optional: cloud sync (accounts across devices)

Without this, accounts are created and stored on-device only (hashed
password). To make login/register real and sync favorites/checklists:

1. Create a free project at **https://supabase.com** (New project).
2. Open **SQL Editor → New query**, paste the whole content of
   `supabase-sync-setup.sql`, click **Run**. (Creates the `user_content`
   table + row-level security.)
3. Recommended: **Authentication → Providers → Email → turn OFF
   "Confirm email"** so sign-up goes straight through.
4. Copy two values from **Project Settings → API**:
   - **Project URL** — looks like `https://xxxxxxxx.supabase.co`
   - **anon public key** — long `eyJhbGciOi...` string
5. In the app: **Settings → Cloud sync (optional) → Connect Supabase**,
   paste both, **Verify & connect**.
6. Now **Profile → Create account / Sign in** uses the real backend, and
   favorites + checklists sync per account (last-write-wins).

Disconnect anytime in Settings — data stays on the device.

---

## What changed in the app (v1.1.0)

- **Live data feed**: `version.json` check → `visaflow-data.json` download →
  cached on device (AsyncStorage) → applied instantly; bundled data is the
  offline fallback.
- **Auto refresh at launch + pull-to-refresh on Home**.
- **Settings → Live data**: version/source/status, manual check, custom feed URL.
- **Accounts**: register/login are real (local hashed accounts by default,
  Supabase auth when connected); guest favorites carry over to the account.
- **Favorites & checklists are per-account** and cloud-synced when connected.
- Home/statistics counts now come from the live dataset (no hardcoded 548).

## Test checklist

- [ ] Install APK over v1.0.0 (same signature, keeps your data)
- [ ] Upload the 2 JSON files to GitHub, then pull-to-refresh on Home →
      header shows `· live v1`
- [ ] Airplane mode → app opens normally with saved data
- [ ] Register an account → favorites persist after sign-out/sign-in
- [ ] (Optional) Connect Supabase → sign in on a second device with the same
      account → favorites/checklists appear
