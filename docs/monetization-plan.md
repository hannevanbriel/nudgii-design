# nudgii Monetization Plan

> Final monetization strategy for nudgii. Covers philosophy, tier structure, conversion mechanics, revenue forecasting, and growth levers. This document is the single reference for all monetization decisions.

*Last updated: March 2026*
*Author: Hanne Van Briel, ELF Consult*

---

## 1. Philosophy

**Helpful first. Commercial second. Always honest.**

nudgii is built on the belief that a genuinely useful free product converts better than a crippled one. The free tier must be good enough that users recommend it to friends. The Pro tier must be compelling enough that power users and families upgrade willingly.

**Core principles:**

- No trial. No tricks. No silent limits.
- Free tier is genuinely useful. Pro is for power users and families.
- Conversion comes from wanting MORE, not from losing what you built.
- The user's data is never held hostage. Items, tasks, and history are never deleted or hidden.
- Monetization never interrupts the core experience: add items, get reminders, mark tasks done.

---

## 2. Tier Structure

### Free

| Feature | Limit |
|---|---|
| Items | 10 |
| Tasks per item | Unlimited |
| Time reminders | Unlimited (basic) |
| AI scans | 3/month |
| Voice sessions | 3/month |
| Completion history | Last 3 per task |
| Weekly digest | Basic |
| Users | Single user |
| Categories | Default 4 (Home, Vehicle, Garden, Subscriptions) |

Recurring tasks keep running forever on active items. The free tier never degrades over time.

### Pro (monthly: 4.99/month, annual: 44.99/year)

| Feature | Details |
|---|---|
| Items | Unlimited |
| AI scans | Unlimited |
| Voice sessions | Unlimited |
| Smart nudges | Seasonal, weather-based, location-based |
| AI task suggestions | Proactive recommendations based on owned items |
| Completion history | Full history + CSV export |
| Weekly digest | Rich: tips, seasonal advice, personalized insights |
| Household sharing | Up to 3 users |
| Custom categories | User-defined beyond the default 4 |
| Priority support | Faster response times |

Annual plan saves 25% vs monthly (44.99/year vs 59.88/year).

### Future: Ultimate Tier (post-launch, not priced)

Planned features for a higher tier, to be validated with Pro user feedback:

- Calendar sync (iCal, Google Calendar, 2-way)
- Budget tracker (cost of maintenance, annual savings report)
- Household up to 5 users
- Advanced insights ("You saved 340 this year by maintaining on time")

Pricing and launch timing to be determined after Pro adoption data is available.

---

## 3. The Item Limit Experience

### When the user hits 11 items

Wherever it happens (during onboarding or on the dashboard), nudgii responds with a single inline message:

> "That's 11 items, nice collection. Free plan covers 10, but don't stop now. Add everything, you'll choose your favourites later. Or keep them all with Pro."

Small "Pro" link inline. Not a button. Not blocking. The user can keep adding.

### Paused items

Items beyond the active 10 are not deleted or hidden. They enter a "paused" state:

| Behaviour | Detail |
|---|---|
| Visibility | Visible on dashboard, slightly muted (opacity 0.7), purple "Pro" pill |
| Tasks | Visible but not generating reminders |
| Push notifications | None for paused items |
| Overdue display | Tasks show in terra red when user opens the app (passive, not pushed) |
| Swapping | User can deactivate an active item and activate a paused one. Always 10 active. |
| Data retention | Items and tasks are never auto-deleted |

### What never happens

- No popups, modals, or full-screen paywalls
- No countdown timers or urgency language
- No "you're missing out" guilt copy
- No blocking the app or any core functionality
- No hiding items or deleting data
- No nagging more than once per week per channel
- No mentioning Pro during onboarding (S-01 through S-06)
- No degrading the free experience after any time period

---

## 4. Conversion Triggers

All triggers are passive. The user encounters them naturally during app usage. Never more than 1 conversion prompt per week per channel.

| Trigger | When it fires | Message |
|---|---|---|
| Item limit hit | User adds item 11 | "Free plan covers 10 items. Choose which ones matter most, or upgrade to keep them all." |
| AI scan limit | 4th scan in a month | "You've used your 3 free scans this month. Resets in X days, or upgrade for unlimited." |
| Voice limit | 4th voice session in a month | Similar gentle inline message |
| History limit | User scrolls past 3rd completion | "Full history available with Pro" |
| Sharing request | User looks for invite/share | "Household sharing is a Pro feature. Invite up to 3 people." |
| Weekly digest | Bottom of email, every week | "What nudgii Pro would have told you" section (2-3 muted smart nudges) |
| Paused item overdue | User opens app, sees overdue on paused item | No notification. Task visible in terra red. Banner on item: "This item isn't sending reminders." |
| Monthly summary | End of month | "You completed X tasks. Y smart nudges were available for your items." |

### Frequency cap

Maximum 1 conversion-related message per week per channel (in-app, email, push). Multiple triggers in the same week are queued, not stacked.

---

## 5. Upgrade Flow

When the user taps any "Pro" badge, "See Pro" link in profile, or any conversion trigger link:

1. **Bottom sheet slides up** (not a new screen, not a modal)
2. **ii mark + headline:** "Unlock everything"
3. **Personalized context:** "You have X paused items and Y locked scans. Pro activates them all."
4. **Pricing:** 4.99/month or 44.99/year (save 25%)
5. **Payment:** Apple/Google native payment via RevenueCat
6. **Dismiss:** "Not now" closes the sheet cleanly, no guilt copy
7. **Post-upgrade:** All items activate immediately, Pro pill changes to green check, confetti micro-celebration

The upgrade sheet is the only place pricing is shown. No pricing on the dashboard, no pricing in notifications, no pricing in the digest email.

---

## 6. Referral System

### Mechanics

Each successful referral (invitee must complete onboarding with at least 1 item):

| Recipient | Reward |
|---|---|
| Referrer | +2 extra items on free tier (up to 20 max) |
| Invitee | Start with 12 items instead of 10 |

### Profile integration

The profile page shows an "Invite friends" section:
- Progress bar: "10/20 items. Invite X more for Y extra."
- Share link: `nudgii.app/invite/[username]`
- Pre-written message template: "I use nudgii to remember maintenance for my house, car, and garden. It's free. Use my link and we both get 2 extra items."

### What we don't do

- No "invite 10 friends to unlock Pro"
- No leaderboards or social pressure
- No expiring bonuses
- No contact list imports
- No spammy follow-up to invitees

---

## 7. Affiliate Revenue

Affiliate links appear at the task-due moment only. They are contextual, relevant, and never intrusive.

**Rules:**

- One link per task view
- Always labeled "we may earn a small fee"
- Never more prominent than the task itself
- No follow-up emails, push, or reminders about the affiliate offer

**Examples:**

- "Your boiler service is due. Book a technician near you." (affiliate link to local service platform)
- "Time for winter tyres. Compare prices." (affiliate link to comparison site)
- "Dishwasher salt running low? Order here." (product affiliate link)

**Revenue estimates:**

| Type | Est. per conversion |
|---|---|
| Service lead (technician booking) | 5-15 |
| Product link (consumables, parts) | 0.50-2 |

At scale (3,500 users, 10% click-through, 5% conversion): 200-500/month additional revenue.

---

## 8. Paid Acquisition Strategy

**Rule: don't spend on paid acquisition until organic word-of-mouth generates 30%+ of signups.**

No ads inside the app. Ever.

| Channel | Timing | Purpose | Budget |
|---|---|---|---|
| SEO/content blog | Month 6+ | Seasonal maintenance content driving organic signups | Time investment only |
| Instagram/Facebook | Month 12+ | Target homeowners 28-45, BE/NL | 200-500/month |
| Google App campaigns | Month 12+ | Dutch keywords: "home maintenance app", "onderhoud app" | 100-300/month |
| Partnerships | Month 18+ | Home insurers, energy companies, real estate agents | Revenue share model |
| Germany launch | Month 12-18 | 5x market expansion | Localization + local marketing costs |

### Partnership strategy

The most capital-efficient growth channel. Potential partners:

- **Home insurers:** Offer nudgii to policyholders (maintained homes = fewer claims)
- **Energy companies:** Boiler maintenance reminders reduce emergency callouts
- **Real estate agents:** Gift nudgii Pro to new homeowners as a closing gift
- **DIY retailers:** Co-branded seasonal maintenance guides

---

## 9. Three-Year Forecast

### Assumptions

| Parameter | Value |
|---|---|
| Month 1 organic signups (BE/NL) | 150 |
| Monthly signup growth, year 1 | 8% |
| Monthly signup growth, years 2-3 | 5% |
| Month-1 retention | 75% |
| Ongoing monthly free churn | 4% |
| Monthly free-to-Pro conversion | 1.5% |
| Monthly Pro churn | 4% |
| Word-of-mouth coefficient (free) | 0.02 |
| Word-of-mouth coefficient (Pro) | 0.03 |
| Apple/Google commission | 15% (small business program) |

### Year 1

| Metric | Value |
|---|---|
| Month 12 MRR | ~600 |
| Active users | ~1,030 (910 free + 120 Pro) |
| Cumulative revenue | ~2,900 |
| Status | Not profitable (building user base) |

### Year 2

| Metric | Value |
|---|---|
| Month 24 MRR | ~1,800 |
| Active users | ~1,940 (1,580 free + 360 Pro) |
| Cumulative revenue (years 1+2) | ~18,350 |
| Word-of-mouth signups | ~55/month (23% of total) |

### Year 3

| Metric | Value |
|---|---|
| Month 36 MRR | ~4,000 |
| Active users | ~3,500 (2,700 free + 800 Pro) |
| Cumulative revenue (all 3 years) | ~54,950 |
| Word-of-mouth signups | ~100/month (35%+ of total) |
| ARR | ~48,000 |

### With Germany launch (month 18)

Germany represents a 5x larger market than BE/NL combined.

| Metric | Month 36 estimate |
|---|---|
| MRR | 8,000-12,000 |
| ARR | 96,000-144,000 |
| Active users | 7,000-10,500 |

---

## 10. Cost Structure

| Cost | Monthly estimate | Notes |
|---|---|---|
| Supabase | 25-75 | Scales with active users |
| Claude API (scans + nudges) | 50-200 | ~0.02/scan, ~0.01/smart nudge |
| Voice transcription | 30-100 | ~0.006 per 15s audio segment |
| FCM (push notifications) | Free | Google free tier covers projected volume |
| Resend (email) | 20-50 | Weekly digest + transactional |
| RevenueCat | 1% of revenue | Minimal at early scale |
| Apple/Google commission | 15-30% of revenue | 15% under small business program |
| Plant.id API | 10-30 | Low usage, plant scans only |
| **Total** | **150-500/month** | **Breakeven projected month 10-14** |

---

## 11. Key Metrics

### Leading indicators (tracked weekly)

1. **Weekly digest open rate** (North Star metric)
2. Items per user at Day 7
3. Task completion rate (tasks marked done / tasks due)
4. Item 11 conversion rate (users who hit limit and upgrade)

### Danger signals

| Signal | Threshold | Action |
|---|---|---|
| Digest open rate | Below 30% | Audit email content, send timing, subject lines |
| Items per user at Day 7 | Stuck at 3-4 | Improve onboarding, add guided item suggestions |
| Pro churn | Above 6%/month | Survey churned users, add retention features |
| Word-of-mouth growth | Zero by month 6 | Rethink referral incentives, investigate NPS |

### Growth levers (ranked by expected impact)

1. **Germany launch** (5x market size)
2. **Household sharing** (each Pro user brings 2 free users)
3. **Seasonal content marketing** (organic SEO with maintenance guides)
4. **Partnerships with home insurers and energy companies** (institutional distribution)

---

## 12. Open Decisions (Deferred)

These decisions are intentionally deferred until post-launch data is available:

- Ultimate tier: pricing, feature set, and launch criteria
- Annual vs monthly pricing split optimization (based on actual conversion data)
- Affiliate partner selection per market (BE, NL, DE)
- Germany launch: exact timeline and localization scope
- Budget tracker and calendar sync: scope, complexity, and tier placement

---

## 13. Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Conversion below 1% | Revenue targets missed by ~40% | Test additional Pro features, experiment with 7-item limit |
| High Pro churn (seasonal usage patterns) | Revenue volatility, unreliable MRR | Push annual plan incentives, build year-round value features |
| Competitor enters BE/NL market | User acquisition costs rise | Build brand loyalty early, word-of-mouth moat, first-mover data advantage |
| AI costs spike (API pricing changes) | Margins shrink or disappear | Cache common item/task lookups, reduce redundant API calls, batch processing |
| Belgium/NL market too small | Growth ceiling reached early | Germany launch is the primary mitigation. Plan for FR market as secondary. |
| Low digest open rate | North Star metric fails, retention drops | A/B test content, timing, personalization. Consider in-app digest alternative. |
| RevenueCat or Supabase pricing changes | Infrastructure costs increase | Evaluate alternatives quarterly, maintain vendor-agnostic architecture where possible |

---

## Appendix: Monetization Timeline

| Month | Milestone |
|---|---|
| 0 | Launch with free + Pro tiers, 10-item limit, RevenueCat integrated |
| 1-3 | Monitor conversion rate, digest open rate, items-per-user |
| 3-6 | First referral system iteration, affiliate links live |
| 6 | Evaluate: is word-of-mouth growing? Adjust if not. |
| 6-12 | SEO/content blog, seasonal marketing campaigns |
| 10-14 | Target breakeven on infrastructure costs |
| 12 | Evaluate Germany launch readiness |
| 12-18 | Paid acquisition (if word-of-mouth > 30%), partnership outreach |
| 18+ | Germany launch, Ultimate tier evaluation |
| 24 | Full monetization review: tier pricing, feature gates, growth channels |

---

*This document governs all monetization decisions for nudgii. Any changes must be approved by Hanne and reflected here before implementation.*
