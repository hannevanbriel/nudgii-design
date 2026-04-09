// ═══════════════════════════════════════════════════════════════
// nudgii · generated Flutter tokens
// DO NOT EDIT — generated from system/tokens.json by
// tools/build-tokens.py. Run the script to regenerate.
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

class NudgiiColors {
  NudgiiColors._();

  // ── v10.5 core ──
  /// App background. Never pure white.
  static const cream = Color(0xFFF5F0E8);
  /// Secondary surface, TOC backgrounds
  static const cream2 = Color(0xFFEDE6D4);
  /// All body text. Warm charcoal — softer than pure black, no blue hue.
  static const ink = Color(0xFF2C2824);
  /// Decorative italic subtitles, secondary text. 2.8:1 — NOT for functional text.
  static const mid = Color(0xFF8A8070);
  /// All functional mid-coloured text (hints, labels, descriptions). WCAG AA 4.6:1 on cream.
  static const midAccessible = Color(0xFF6B6358);
  /// Placeholders, hint text, very secondary. Use sparingly.
  static const hint = Color(0xFFA09888);
  /// Primary CTA button, FAB, Export button, active nav tab, active filter pill. The ONLY bright color in the app.
  static const cta = Color(0xFF9B7FD4);
  /// Text and icons on CTA background. Lavender-white.
  static const ctaFg = Color(0xFFFAF8FF);
  /// Done overlay background. SACRED — appears nowhere else.
  static const plum = Color(0xFF2D1F4A);
  /// Done overlay ii mark pill fill.
  static const plumPale = Color(0xFFC4A8E8);
  /// Overdue badge background. Warm brown — NOT red. Cream text on top.
  static const overdueBadge = Color(0xFF6B4A3A);
  /// Bottom sheets, dialogs, inline modals.
  static const surface = Color(0xFFFFFFFF);
  /// Default card borders and dividers
  static const border = Color(0x142C2824);
  /// Stronger borders
  static const borderMd = Color(0x1F2C2824);
  /// Success text
  static const sage = Color(0xFF3B6D11);
  /// Success background
  static const sageLt = Color(0xFFEAF3DE);
  /// Error text
  static const red = Color(0xFFA32D2D);
  /// Error background
  static const redLt = Color(0xFFFCEBEB);
  /// Warning text
  static const amber = Color(0xFF854F0B);
  /// Warning background
  static const amberLt = Color(0xFFFAEEDA);

  // ── v10.5 category (light) ──
  /// Home card background — solid pastel, Anthropic blush
  static const homeBg = Color(0xFFD2BEB6);
  /// Home icon stroke — darkened version of home-bg
  static const homeIcon = Color(0xFF7A5A50);
  /// Garden card background — solid leaf green pastel
  static const gardenBg = Color(0xFFC0CEC9);
  /// Garden icon stroke — darkened version of garden-bg
  static const gardenIcon = Color(0xFF607870);
  /// Vehicle card background — solid steel mist pastel
  static const vehicleBg = Color(0xFFC0CDD8);
  /// Vehicle icon stroke — darkened version of vehicle-bg
  static const vehicleIcon = Color(0xFF4A6A82);
  /// Subscriptions card background — solid lavender pastel
  static const subscriptionsBg = Color(0xFFD0C6DC);
  /// Subscriptions icon stroke — darkened version of subscriptions-bg
  static const subscriptionsIcon = Color(0xFF6A5085);
  /// Health card background — soft olive pastel (v2 category)
  static const healthBg = Color(0xFFD2D0C4);
  /// Health icon stroke — olive tint (was pink in pre-v10.5)
  static const healthIcon = Color(0xFF6A6858);
  /// Pets card background — warm amber pastel
  static const petsBg = Color(0xFFDECDC0);
  /// Pets icon stroke — warm amber dark
  static const petsIcon = Color(0xFF8A6238);

  // ── v10.5 dark ──
  /// Dark mode app background. Warm dark cream — no blue, no green.
  static const bg = Color(0xFF1E1C18);
  /// Dark mode nav bar and FAB options surface
  static const nav = Color(0xFF28261F);
  /// Home card background in dark mode
  static const homeBg = Color(0xFF3A302E);
  /// Garden card background in dark mode
  static const gardenBg = Color(0xFF242E2C);
  /// Vehicle card background in dark mode
  static const vehicleBg = Color(0xFF262E34);
  /// Subscriptions card background in dark mode
  static const subscriptionsBg = Color(0xFF302838);
  /// Health card background in dark mode
  static const healthBg = Color(0xFF2E2E26);
  /// Pets card background in dark mode
  static const petsBg = Color(0xFF342C22);
  /// Primary text on dark background
  static const textPrimary = Color(0xFFE0DDD6);
  /// Secondary text on dark background
  static const textMid = Color(0xFF96908A);
  /// Dark mode card borders — warm hairline
  static const border = Color(0x14E0DDD6);

  // ── Precision Warmth (current) ──
  /// PW top surface — warm off-white, light mode
  static const surface = Color(0xFFFBF9F4);
  /// PW mid surface tier — slightly sunken
  static const surfaceLow = Color(0xFFF5F4ED);
  /// PW raised tier — for elevated cards
  static const surfaceHigh = Color(0xFFE8E9E0);
  /// PW lowest surface — pure white for deepest layer
  static const surfaceLowest = Color(0xFFFFFFFF);
  /// PW primary text — warm near-black
  static const ink = Color(0xFF31332C);
  /// PW secondary text — warm mid grey
  static const mid = Color(0xFF7A756D);
  /// PW tertiary text / placeholders
  static const hint = Color(0xFFA09A90);
  /// PW divider / outline variant
  static const outlineVar = Color(0xFFB1B3A9);
  /// PW primary action (plum). FAB, CTA, Done, active nav.
  static const primary = Color(0xFF9B7FD4);
  /// Foreground on primary
  static const primaryFg = Color(0xFFFAF8FF);
  /// Primary tinted container background
  static const primaryContainer = Color(0x149B7FD4);
  /// PW plum alias of --primary. Existing screens use --plum directly.
  static const plum = Color(0xFF9B7FD4);
  /// Foreground on plum
  static const plumFg = Color(0xFFFAF8FF);
  /// Plum wash for hover / subtle bg
  static const plumWash = Color(0x1A9B7FD4);
  /// Plum tinted container — alias of --primary-container
  static const plumContainer = Color(0x149B7FD4);
  /// PW signature warmth color — greeting name, streak, highlights, 'why it matters' labels
  static const apricot = Color(0xFFE8A87C);
  /// Apricot wash for savings cards etc.
  static const apricotWash = Color(0x1FE8A87C);
  /// Soft yellow for 'did you know' cards
  static const yellow = Color(0xFFE8B86D);
  /// Yellow wash background
  static const yellowWash = Color(0x24E8B86D);
  /// Warm brown overdue badge background
  static const overdueBg = Color(0xFF6B4A3A);
  /// Foreground on overdue badge
  static const overdueFg = Color(0xFFFBF9F4);

  // ── Precision Warmth category (light) ──
  /// Home highlight — dusty rose
  static const chBg = Color(0xFFC09088);
  /// Home card wash background
  static const chWash = Color(0x24C09088);
  /// Garden highlight — sage
  static const cgBg = Color(0xFF8C9B80);
  /// Garden card wash background
  static const cgWash = Color(0x248C9B80);
  /// Vehicle highlight — sage-slate
  static const cvBg = Color(0xFF8E9A94);
  /// Vehicle card wash background
  static const cvWash = Color(0x248E9A94);
  /// Subscriptions highlight — lavender
  static const csBg = Color(0xFFA69BBF);
  /// Subscriptions card wash background
  static const csWash = Color(0x24A69BBF);
  /// Health highlight — muted rose (PW replaces olive)
  static const cxBg = Color(0xFFC29494);
  /// Health card wash background
  static const cxWash = Color(0x24C29494);
  /// Pets highlight — warm amber-beige
  static const cpBg = Color(0xFFC7B7A3);
  /// Pets card wash background
  static const cpWash = Color(0x24C7B7A3);

  // ── Precision Warmth dark ──
  /// PW dark surface base
  static const surface = Color(0xFF1C1B18);
  /// PW dark mid tier
  static const surfaceLow = Color(0xFF24231F);
  /// PW dark raised tier
  static const surfaceHigh = Color(0xFF2E2D28);
  /// PW dark lowest surface
  static const surfaceLowest = Color(0xFF181714);
  /// PW dark primary text
  static const ink = Color(0xFFF0EDE6);
  /// PW dark secondary text
  static const mid = Color(0xFFA8A29A);
  /// PW dark tertiary text
  static const hint = Color(0xFF787068);
  /// PW dark divider
  static const outlineVar = Color(0x26B1B3A9);
  /// PW dark primary — brighter plum
  static const primary = Color(0xFFB8A0E8);
  /// Dark mode plum foreground
  static const primaryFg = Color(0xFF1C1B18);
  /// Dark mode plum tint
  static const primaryContainer = Color(0x1FB8A0E8);
  /// Dark mode plum alias
  static const plum = Color(0xFFB8A0E8);
  /// Dark mode plum foreground
  static const plumFg = Color(0xFF1C1B18);
  /// Dark mode plum container alias
  static const plumContainer = Color(0x1FB8A0E8);
  /// PW dark apricot — brighter warmth
  static const apricot = Color(0xFFF0B890);
  /// Dark mode apricot wash
  static const apricotWash = Color(0x26F0B890);
  /// Dark mode yellow
  static const yellow = Color(0xFFE0C880);
  /// Dark mode yellow wash
  static const yellowWash = Color(0x26E0C880);
  /// Dark mode overdue — brighter
  static const overdueBg = Color(0xFFC88860);
  /// Dark mode overdue foreground
  static const overdueFg = Color(0xFF1C1B18);
  /// Dark home highlight — brighter dusty rose for icons on dark
  static const chBg = Color(0xFFE0A898);
  /// Dark home card wash
  static const chWash = Color(0x26E0A898);
  /// Dark garden highlight — brighter sage
  static const cgBg = Color(0xFFA8B89C);
  /// Dark garden card wash
  static const cgWash = Color(0x26A8B89C);
  /// Dark vehicle highlight — brighter sage-slate
  static const cvBg = Color(0xFFA8B0AA);
  /// Dark vehicle card wash
  static const cvWash = Color(0x26A8B0AA);
  /// Dark subscriptions highlight — brighter lavender
  static const csBg = Color(0xFFC0B4D6);
  /// Dark subscriptions card wash
  static const csWash = Color(0x26C0B4D6);
  /// Dark health highlight — brighter rose
  static const cxBg = Color(0xFFD4AAAA);
  /// Dark health card wash
  static const cxWash = Color(0x26D4AAAA);
  /// Dark pets highlight — brighter amber-beige
  static const cpBg = Color(0xFFD6C8B6);
  /// Dark pets card wash
  static const cpWash = Color(0x26D6C8B6);

}

class NudgiiSpacing {
  NudgiiSpacing._();
  static const s4 = 4;
  static const s8 = 8;
  static const s12 = 12;
  static const s16 = 16;
  static const s20 = 20;
  static const s24 = 24;
  static const s32 = 32;
  static const s48 = 48;
}

class NudgiiRadius {
  NudgiiRadius._();
  static const sm = 4;
  static const md = 8;
  static const card = 16;
  static const cardLg = 18;
  static const sheet = 20;
  static const pill = 100;
}
