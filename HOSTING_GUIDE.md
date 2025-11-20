# Portfolio Hosting Guide

## Option 1: GitHub Pages (Recommended - Free & Easy)

Your code is already on GitHub! Follow these steps:

### Steps:
1. Go to your repository: https://github.com/Ujjal-Techved/nasscom-poc
2. Click on **Settings** (top menu)
3. Scroll down to **Pages** in the left sidebar
4. Under **Source**, select **Deploy from a branch**
5. Choose **master** branch and **/ (root)** folder
6. Click **Save**
7. Wait 1-2 minutes for deployment
8. Your site will be live at: `https://ujjal-techved.github.io/nasscom-poc/`

### Custom Domain (Optional):
- You can add a custom domain in the Pages settings
- Add a `CNAME` file with your domain name

---

## Option 2: Netlify (Free & Very Easy)

### Method A: Drag & Drop
1. Go to https://www.netlify.com/
2. Sign up/login (free)
3. Drag and drop your project folder
4. Your site is live instantly!

### Method B: Connect GitHub
1. Go to https://www.netlify.com/
2. Click "Add new site" → "Import an existing project"
3. Connect your GitHub account
4. Select `nasscom-poc` repository
5. Deploy settings:
   - Build command: (leave empty)
   - Publish directory: `/` (root)
6. Click "Deploy site"
7. Your site will be live at: `https://random-name.netlify.app`

### Custom Domain:
- Go to Site settings → Domain management
- Add your custom domain

---

## Option 3: Vercel (Free & Fast)

1. Go to https://vercel.com/
2. Sign up/login with GitHub
3. Click "Add New Project"
4. Import `nasscom-poc` repository
5. Framework Preset: **Other**
6. Root Directory: `./`
7. Click "Deploy"
8. Your site will be live at: `https://nasscom-poc.vercel.app`

---

## Option 4: Cloudflare Pages (Free)

1. Go to https://pages.cloudflare.com/
2. Sign up/login
3. Connect GitHub account
4. Select `nasscom-poc` repository
5. Build settings:
   - Framework preset: None
   - Build command: (leave empty)
   - Build output directory: `/`
6. Click "Save and Deploy"
7. Your site will be live at: `https://nasscom-poc.pages.dev`

---

## Quick Comparison

| Platform | Free Tier | Custom Domain | CDN | Ease of Use |
|----------|-----------|---------------|-----|-------------|
| GitHub Pages | ✅ | ✅ | ✅ | ⭐⭐⭐⭐⭐ |
| Netlify | ✅ | ✅ | ✅ | ⭐⭐⭐⭐⭐ |
| Vercel | ✅ | ✅ | ✅ | ⭐⭐⭐⭐ |
| Cloudflare Pages | ✅ | ✅ | ✅ | ⭐⭐⭐⭐ |

**Recommendation:** Start with GitHub Pages since your code is already there!

