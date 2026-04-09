import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

// ─── nudgii design tokens ───
const Color colorCream = Color(0xFFF5F0E8);
const Color colorInk = Color(0xFF1A1612);
const Color colorCta = Color(0xFF9B7FD4);
const Color colorCtaFg = Color(0xFFFAF8FF);
const Color colorCtaPressed = Color(0xFF7D62B3);
const Color colorApricot = Color(0xFFE8A87C);
const Color colorApricotDk = Color(0xFFC8784A);
const Color colorTerra = Color(0xFFC4503A);
const Color colorPlum = Color(0xFF231833);
const Color colorMid = Color(0xFF8A8070);
const Color colorMidAccessible = Color(0xFF6B6358);
const Color colorSurface = Color(0xFFFFFFFF);
const Color catHome = Color(0xFFC87850);

/// S-05 AHA Screen: schedule reveal state
/// Progress: 80% (step 4 of 5)
///
/// Shell pattern: SafeArea + Column + Expanded (scrollable content) + fixed bottom
/// One serif moment: headline "You said what."
class S05AhaScreen extends StatefulWidget {
  final int itemCount;
  final int taskCount;
  final int monthCount;
  final NudgeCardData firstNudge;
  final List<MonthData> yearGrid;
  final VoidCallback onContinue;

  const S05AhaScreen({
    super.key,
    this.itemCount = 3,
    this.taskCount = 14,
    this.monthCount = 12,
    required this.firstNudge,
    required this.yearGrid,
    required this.onContinue,
  });

  @override
  State<S05AhaScreen> createState() => _S05AhaScreenState();
}

class _S05AhaScreenState extends State<S05AhaScreen>
    with TickerProviderStateMixin {
  // Stagger controllers
  late final AnimationController _iiMarkController;
  late final AnimationController _kickerController;
  late final AnimationController _headlineController;
  late final AnimationController _sublineController;
  late final AnimationController _pillsController;
  late final AnimationController _nudgeCardController;
  late final AnimationController _yearGridController;
  late final AnimationController _ctaController;

  // Pill pop animations (spring curve)
  late final List<AnimationController> _pillControllers;
  late final List<Animation<double>> _pillScales;

  // Month pop animations
  late final List<AnimationController> _monthControllers;
  late final List<Animation<double>> _monthScales;

  // Fade+slide animations
  late final Animation<Offset> _iiMarkSlide;
  late final Animation<double> _iiMarkFade;
  late final Animation<Offset> _kickerSlide;
  late final Animation<double> _kickerFade;
  late final Animation<Offset> _headlineSlide;
  late final Animation<double> _headlineFade;
  late final Animation<Offset> _sublineSlide;
  late final Animation<double> _sublineFade;
  late final Animation<Offset> _nudgeCardSlide;
  late final Animation<double> _nudgeCardFade;
  late final Animation<Offset> _ctaSlide;
  late final Animation<double> _ctaFade;

  static const _springCurve = Cubic(0.34, 1.56, 0.64, 1);

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _playEntrance();
  }

  void _initAnimations() {
    // ii mark: fadeUp 500ms
    _iiMarkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _iiMarkSlide = Tween<Offset>(
      begin: const Offset(0, 14),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _iiMarkController,
      curve: Curves.easeOut,
    ));
    _iiMarkFade = CurvedAnimation(
      parent: _iiMarkController,
      curve: Curves.easeOut,
    );

    // kicker: fadeUp 500ms, delay 120ms
    _kickerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _kickerSlide = Tween<Offset>(
      begin: const Offset(0, 14),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _kickerController,
      curve: Curves.easeOut,
    ));
    _kickerFade = CurvedAnimation(
      parent: _kickerController,
      curve: Curves.easeOut,
    );

    // headline: fadeUp 500ms, delay 220ms
    _headlineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _headlineSlide = Tween<Offset>(
      begin: const Offset(0, 14),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headlineController,
      curve: Curves.easeOut,
    ));
    _headlineFade = CurvedAnimation(
      parent: _headlineController,
      curve: Curves.easeOut,
    );

    // subline: fadeUp 400ms, delay 320ms
    _sublineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _sublineSlide = Tween<Offset>(
      begin: const Offset(0, 14),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _sublineController,
      curve: Curves.easeOut,
    ));
    _sublineFade = CurvedAnimation(
      parent: _sublineController,
      curve: Curves.easeOut,
    );

    // pills: popIn 450ms each, spring curve, staggered 120ms apart from 450ms
    _pillsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _pillControllers = List.generate(3, (i) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 450),
      );
    });
    _pillScales = _pillControllers.map((c) {
      return Tween<double>(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(parent: c, curve: _springCurve),
      );
    }).toList();

    // nudge card: fadeUp 500ms, delay 800ms
    _nudgeCardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _nudgeCardSlide = Tween<Offset>(
      begin: const Offset(0, 14),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _nudgeCardController,
      curve: Curves.easeOut,
    ));
    _nudgeCardFade = CurvedAnimation(
      parent: _nudgeCardController,
      curve: Curves.easeOut,
    );

    // month columns: popIn 300ms each, spring curve, staggered 50ms apart from 1050ms
    _yearGridController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    final monthCount = widget.yearGrid.length.clamp(0, 12);
    _monthControllers = List.generate(monthCount, (i) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
    });
    _monthScales = _monthControllers.map((c) {
      return Tween<double>(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(parent: c, curve: _springCurve),
      );
    }).toList();

    // CTA: fadeUp 400ms, delay 1500ms
    _ctaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _ctaSlide = Tween<Offset>(
      begin: const Offset(0, 14),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _ctaController,
      curve: Curves.easeOut,
    ));
    _ctaFade = CurvedAnimation(
      parent: _ctaController,
      curve: Curves.easeOut,
    );
  }

  Future<void> _playEntrance() async {
    // 0ms: ii mark
    _iiMarkController.forward();

    // 120ms: kicker
    await Future.delayed(const Duration(milliseconds: 120));
    _kickerController.forward();

    // 220ms: headline
    await Future.delayed(const Duration(milliseconds: 100));
    _headlineController.forward();

    // 320ms: subline
    await Future.delayed(const Duration(milliseconds: 100));
    _sublineController.forward();

    // 450ms, 570ms, 690ms: pills staggered
    await Future.delayed(const Duration(milliseconds: 130));
    for (int i = 0; i < _pillControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 120), () {
        if (mounted) _pillControllers[i].forward();
      });
    }

    // 800ms: nudge card
    await Future.delayed(const Duration(milliseconds: 350));
    _nudgeCardController.forward();

    // 1050ms+: month columns staggered 50ms
    await Future.delayed(const Duration(milliseconds: 250));
    for (int i = 0; i < _monthControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted) _monthControllers[i].forward();
      });
    }

    // 1500ms: CTA
    await Future.delayed(const Duration(milliseconds: 450));
    _ctaController.forward();
  }

  @override
  void dispose() {
    _iiMarkController.dispose();
    _kickerController.dispose();
    _headlineController.dispose();
    _sublineController.dispose();
    _pillsController.dispose();
    for (final c in _pillControllers) {
      c.dispose();
    }
    _nudgeCardController.dispose();
    _yearGridController.dispose();
    for (final c in _monthControllers) {
      c.dispose();
    }
    _ctaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCream,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Progress bar: full-width, outside SafeArea top
            _buildProgressBar(),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    _buildIiMark(),
                    const SizedBox(height: 14),
                    _buildKicker(),
                    const SizedBox(height: 8),
                    _buildHeadline(),
                    const SizedBox(height: 4),
                    _buildSubline(),
                    const SizedBox(height: 20),
                    _buildStatPills(),
                    const SizedBox(height: 22),
                    _buildSectionLabel('your first nudge'),
                    const SizedBox(height: 8),
                    _buildNudgeCard(),
                    const SizedBox(height: 20),
                    _buildSectionLabel('your year at a glance'),
                    const SizedBox(height: 8),
                    _buildYearGrid(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Fixed bottom zone
            _buildBottomZone(),
          ],
        ),
      ),
    );
  }

  // ─── Progress bar: 80% ───
  Widget _buildProgressBar() {
    return Container(
      width: double.infinity,
      height: 3,
      color: colorInk.withValues(alpha: 0.08),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.80,
        child: Container(
          decoration: const BoxDecoration(
            color: colorCta,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(100),
              bottomRight: Radius.circular(100),
            ),
          ),
        ),
      ),
    );
  }

  // ─── ii mark ───
  Widget _buildIiMark() {
    return AnimatedBuilder(
      animation: _iiMarkController,
      builder: (context, child) {
        return Transform.translate(
          offset: _iiMarkSlide.value,
          child: Opacity(
            opacity: _iiMarkFade.value,
            child: child,
          ),
        );
      },
      child: const IiMark(size: 32, variant: IiMarkVariant.darkOnLight),
    );
  }

  // ─── Kicker ───
  Widget _buildKicker() {
    return AnimatedBuilder(
      animation: _kickerController,
      builder: (context, child) {
        return Transform.translate(
          offset: _kickerSlide.value,
          child: Opacity(
            opacity: _kickerFade.value,
            child: child,
          ),
        );
      },
      child: Text(
        'YOUR SCHEDULE IS READY',
        textAlign: TextAlign.center,
        style: GoogleFonts.dmSans(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.8,
          color: colorApricot,
        ),
      ),
    );
  }

  // ─── Headline: one serif moment ───
  Widget _buildHeadline() {
    return AnimatedBuilder(
      animation: _headlineController,
      builder: (context, child) {
        return Transform.translate(
          offset: _headlineSlide.value,
          child: Opacity(
            opacity: _headlineFade.value,
            child: child,
          ),
        );
      },
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'You said ',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 28,
                color: colorInk,
                height: 1.1,
                letterSpacing: -0.4,
              ),
            ),
            TextSpan(
              text: 'what.',
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 28,
                color: colorCta,
                height: 1.1,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ─── Subline ───
  Widget _buildSubline() {
    return AnimatedBuilder(
      animation: _sublineController,
      builder: (context, child) {
        return Transform.translate(
          offset: _sublineSlide.value,
          child: Opacity(
            opacity: _sublineFade.value,
            child: child,
          ),
        );
      },
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'We figured out ',
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: colorMidAccessible,
                height: 1.4,
              ),
            ),
            TextSpan(
              text: 'when',
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: colorCta,
                height: 1.4,
              ),
            ),
            TextSpan(
              text: ' and ',
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: colorMidAccessible,
                height: 1.4,
              ),
            ),
            TextSpan(
              text: 'why.',
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: colorCta,
                height: 1.4,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ─── Stat pills ───
  Widget _buildStatPills() {
    final pills = [
      _StatPillData('${widget.itemCount}', 'items', false),
      _StatPillData('${widget.taskCount}', 'tasks', true),
      _StatPillData('${widget.monthCount}', 'months', false),
    ];

    return Row(
      children: List.generate(pills.length, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: i > 0 ? 3 : 0,
              right: i < pills.length - 1 ? 3 : 0,
            ),
            child: AnimatedBuilder(
              animation: _pillControllers[i],
              builder: (context, child) {
                final scale = _pillScales[i].value;
                final opacity = _pillControllers[i].value;
                return Transform.scale(
                  scale: scale,
                  child: Opacity(opacity: opacity, child: child),
                );
              },
              child: _buildPill(pills[i]),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPill(_StatPillData data) {
    final isHero = data.isHero;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: isHero
            ? colorCta.withValues(alpha: 0.16)
            : colorCta.withValues(alpha: 0.08),
        border: Border.all(
          color: isHero
              ? colorCta.withValues(alpha: 0.35)
              : colorCta.withValues(alpha: 0.18),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            data.value,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: isHero ? 26 : 22,
              color: isHero ? const Color(0xFF6B4DB0) : colorCta,
              height: 1,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            data.label,
            style: GoogleFonts.dmSans(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
              color: colorMidAccessible,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section label: only uppercase in the app ───
  Widget _buildSectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.dmSans(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.8,
          color: colorMidAccessible,
        ),
      ),
    );
  }

  // ─── Nudge card ───
  Widget _buildNudgeCard() {
    final nudge = widget.firstNudge;
    return AnimatedBuilder(
      animation: _nudgeCardController,
      builder: (context, child) {
        return Transform.translate(
          offset: _nudgeCardSlide.value,
          child: Opacity(
            opacity: _nudgeCardFade.value,
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colorInk.withValues(alpha: 0.08),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: colorInk.withValues(alpha: 0.04),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header: icon chip + item name + date
            Row(
              children: [
                // Category icon chip
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: nudge.categoryColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    nudge.icon,
                    size: 14,
                    color: nudge.categoryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  nudge.itemLabel,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: colorMidAccessible,
                  ),
                ),
                const Spacer(),
                Text(
                  nudge.dateLabel,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colorTerra,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Task title
            Text(
              nudge.title,
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: colorInk,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),

            // Why box: category-tinted background
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: nudge.categoryColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WHY IT MATTERS',
                    style: GoogleFonts.dmSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.8,
                      color: nudge.categoryColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    nudge.whyText,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: colorInk,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // How to do it
            Text(
              'HOW TO DO IT',
              style: GoogleFonts.dmSans(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.8,
                color: colorMidAccessible,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              nudge.howText,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: colorMidAccessible,
                height: 1.5,
              ),
            ),

            // More tasks
            if (nudge.moreTasksCount > 0) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: colorInk.withValues(alpha: 0.06),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Text(
                  '+ ${nudge.moreTasksCount} more tasks for your ${nudge.itemName}',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: colorMidAccessible,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─── Year grid ───
  Widget _buildYearGrid() {
    return Row(
      children: List.generate(widget.yearGrid.length, (i) {
        final month = widget.yearGrid[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: i == 0 || i == widget.yearGrid.length - 1 ? 0 : 2.5),
            child: AnimatedBuilder(
              animation: i < _monthControllers.length
                  ? _monthControllers[i]
                  : _monthControllers.last,
              builder: (context, child) {
                final controller = i < _monthControllers.length
                    ? _monthControllers[i]
                    : _monthControllers.last;
                final scale = i < _monthScales.length
                    ? _monthScales[i].value
                    : 1.0;
                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: controller.value,
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1 / 1.1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorCta.withValues(alpha: month.intensity),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${month.taskCount}',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _monthTextColor(month.intensity),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    month.label,
                    style: GoogleFonts.dmSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                      color: colorMidAccessible,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Color _monthTextColor(double intensity) {
    if (intensity >= 0.35) return const Color(0xFF3C2880);
    if (intensity >= 0.18) return const Color(0xFF6B4DB0);
    return colorCta;
  }

  // ─── Bottom zone: sticky CTA ───
  Widget _buildBottomZone() {
    return AnimatedBuilder(
      animation: _ctaController,
      builder: (context, child) {
        return Transform.translate(
          offset: _ctaSlide.value,
          child: Opacity(
            opacity: _ctaFade.value,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
        child: SafeArea(
          top: false,
          child: _CtaButton(
            label: "That's it. I'm done.",
            onPressed: widget.onContinue,
          ),
        ),
      ),
    );
  }
}

// ─── CTA Button ───
class _CtaButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _CtaButton({required this.label, required this.onPressed});

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: _pressed ? colorCtaPressed : colorCta,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: colorCta.withValues(alpha: 0.28),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
              color: colorCtaFg,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── ii mark component ───
enum IiMarkVariant { darkOnLight, lightOnDark }

class IiMark extends StatelessWidget {
  final double size;
  final IiMarkVariant variant;

  const IiMark({
    super.key,
    this.size = 32,
    this.variant = IiMarkVariant.darkOnLight,
  });

  @override
  Widget build(BuildContext context) {
    final leftColor = variant == IiMarkVariant.darkOnLight
        ? colorCta
        : colorCream;
    final rightColor = variant == IiMarkVariant.darkOnLight
        ? colorPlum
        : colorCta;

    return CustomPaint(
      size: Size(size * (626 / 700), size),
      painter: _IiMarkPainter(
        leftColor: leftColor,
        rightColor: rightColor,
        dotColor: colorApricot,
      ),
    );
  }
}

class _IiMarkPainter extends CustomPainter {
  final Color leftColor;
  final Color rightColor;
  final Color dotColor;

  _IiMarkPainter({
    required this.leftColor,
    required this.rightColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 626;
    final sy = size.height / 700;

    // Left pillar
    final leftPaint = Paint()..color = leftColor;
    final leftRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, 250.36 * sx, 700 * sy),
      Radius.circular(128.87 * sy),
    );
    canvas.drawRRect(leftRect, leftPaint);

    // Right pillar
    final rightPaint = Paint()..color = rightColor;
    final rightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(325.78 * sx, 0, 250.36 * sx, 700 * sy),
      Radius.circular(128.87 * sy),
    );
    canvas.drawRRect(rightRect, rightPaint);

    // Dot
    final dotPaint = Paint()..color = dotColor;
    canvas.drawCircle(
      Offset(535.96 * sx, 119.29 * sy),
      90 * sx,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Data models ───
class NudgeCardData {
  final IconData icon;
  final Color categoryColor;
  final String itemLabel;
  final String dateLabel;
  final String title;
  final String whyText;
  final String howText;
  final String itemName;
  final int moreTasksCount;

  const NudgeCardData({
    required this.icon,
    required this.categoryColor,
    required this.itemLabel,
    required this.dateLabel,
    required this.title,
    required this.whyText,
    required this.howText,
    required this.itemName,
    this.moreTasksCount = 0,
  });
}

class MonthData {
  final String label;
  final int taskCount;
  final double intensity; // 0.0 to 1.0, maps to purple opacity

  const MonthData({
    required this.label,
    required this.taskCount,
    required this.intensity,
  });
}

class _StatPillData {
  final String value;
  final String label;
  final bool isHero;

  const _StatPillData(this.value, this.label, this.isHero);
}

// ─── Usage example ───
// S05AhaScreen(
//   itemCount: 3,
//   taskCount: 14,
//   monthCount: 12,
//   firstNudge: NudgeCardData(
//     icon: PhosphorIcons.house,
//     categoryColor: catHome,
//     itemLabel: 'Boiler, yearly',
//     dateLabel: 'Oct 28',
//     title: 'Annual boiler service',
//     whyText: 'Skipping the annual check voids most warranty agreements and increases carbon monoxide risk in enclosed spaces.',
//     howText: 'Book a certified technician 2-3 weeks ahead. They inspect gas pressure, flue output, and the safety valve.',
//     itemName: 'boiler',
//     moreTasksCount: 2,
//   ),
//   yearGrid: [
//     MonthData(label: 'Oct', taskCount: 2, intensity: 0.20),
//     MonthData(label: 'Nov', taskCount: 4, intensity: 0.42),
//     MonthData(label: 'Dec', taskCount: 1, intensity: 0.12),
//     MonthData(label: 'Jan', taskCount: 2, intensity: 0.20),
//     MonthData(label: 'Feb', taskCount: 1, intensity: 0.12),
//     MonthData(label: 'Mar', taskCount: 1, intensity: 0.12),
//   ],
//   onContinue: () => Navigator.pushNamed(context, '/celebration'),
// )
