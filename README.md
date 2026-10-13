# Fix Home Solution — Website Starter

Bilingual (English / Urdu) home-services booking website starter for Pakistan.

## What's included
- Responsive landing page and service categories
- English/Urdu toggle (Urdu uses RTL)
- Booking form with service, date, time, address, phone and notes
- Supabase email/password customer sign-up/sign-in
- Booking records saved to Supabase when configured
- Customer bookings list
- Admin dashboard for reviewing/updating bookings
- Supabase SQL schema and row-level security policies
- Local demo mode if Supabase environment variables are not set

## Important
This ZIP is a deployable starter project, not a live website. To make it public, create a Supabase project and deploy the site to a hosting provider such as Vercel. You must configure the admin account/role before using the admin dashboard with real customers. Do not collect real customer data in demo mode.

## 1. Requirements
- Node.js 20+
- A Supabase account: https://supabase.com/
- A Vercel account (or another Next.js host): https://vercel.com/

## 2. Install
```bash
npm install
cp .env.example .env.local
npm run dev
```
Open http://localhost:3000

If Supabase variables are blank, the site uses browser localStorage demo mode. Demo records stay in that browser only.

## 3. Configure Supabase
1. Create a Supabase project.
2. Open SQL Editor and run `supabase/schema.sql`.
3. In Project Settings → API, copy the Project URL and anon/public key.
4. Add them to `.env.local`:
   - `NEXT_PUBLIC_SUPABASE_URL=...`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY=...`
5. Restart `npm run dev`.

## 4. Admin setup
For a real production launch, create a customer account first. In Supabase SQL Editor, promote the intended admin user by replacing `ADMIN-USER-UUID`:
```sql
update public.profiles set role = 'admin' where id = 'ADMIN-USER-UUID';
```
Use the UUID from Authentication → Users. Never expose the Supabase service-role key in the browser.

## 5. Deploy to Vercel
1. Upload this project to a private GitHub repository.
2. Import the repository in Vercel.
3. Add `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` as environment variables.
4. Deploy and test signup, booking and admin access.

## Before launch
- Add privacy policy and terms
- Verify phone numbers / OTP using a trusted provider if required
- Configure email templates and SMTP in Supabase
- Set real service coverage, prices, provider assignment, payment reconciliation and customer support number
- Test database policies and admin permissions
- Do not advertise live tracking or online payments until implemented and tested
