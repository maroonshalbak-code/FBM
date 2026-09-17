# 💰 Home Budget App — Setup Guide

A Hebrew RTL mobile PWA for managing household budget and expenses.
Stack: **GitHub + Vercel + Supabase**

---

## Step 1 — Supabase

1. Go to [supabase.com](https://supabase.com) → **New Project**
2. Open **SQL Editor** → paste the contents of `schema.sql` → **Run**
3. Go to **Project Settings → API** and copy:
   - **Project URL** (looks like `https://xxxx.supabase.co`)
   - **anon public** key (long JWT string)

---

## Step 2 — GitHub

1. Create a new repo on [github.com](https://github.com)
2. Push this folder's contents to the repo:

```bash
git init
git add .
git commit -m "initial"
git remote add origin https://github.com/YOUR_USER/YOUR_REPO.git
git push -u origin main
```

---

## Step 3 — Vercel

1. Go to [vercel.com](https://vercel.com) → **Add New Project**
2. Import your GitHub repo
3. Click **Deploy** (no build settings needed — it's a static site)
4. Vercel gives you a URL like `https://your-app.vercel.app`

---

## Step 4 — First Run

1. Open the Vercel URL on your phone
2. Enter your **Supabase URL** and **anon key** when prompted
3. Sign up with your email → verify the email Supabase sends
4. Done — add the app to your home screen when the install banner appears

---

## File Structure

```
budget-pwa/
├── index.html      — full app (auth + data + UI)
├── manifest.json   — PWA manifest (name, icons, RTL)
├── sw.js           — service worker (offline support)
├── vercel.json     — Vercel routing + cache headers
├── schema.sql      — Supabase DB schema + RLS policies
├── icon.svg        — app icon (₪ symbol)
├── icon-192.png    — home screen icon
└── icon-512.png    — splash screen icon
```

---

## Features

- Track income & expenses with categories
- Payment method: credit card (with installments split across months), cash, bank transfer, loan
- Monthly budget limits with progress bars
- Recurring transactions (auto-added each month)
- Hebrew RTL interface
- Installable as a PWA on iOS and Android
- Data is private per user (Supabase RLS)
- Works offline after first load (service worker)
