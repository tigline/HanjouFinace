import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../controllers/benefit_lottery_draw_controller.dart';
import '../models/benefit_lottery_models.dart';

class BenefitLotteryWheelSegmentStyle {
  const BenefitLotteryWheelSegmentStyle({
    required this.startColor,
    required this.middleColor,
    required this.endColor,
  });

  final Color startColor;
  final Color middleColor;
  final Color endColor;

  Color get swatchColor => middleColor;
}

class BenefitLotteryWheelPalette {
  const BenefitLotteryWheelPalette({
    required this.prizeStyles,
    required this.noWinStyle,
    required this.outerRingColor,
    required this.darkRingColor,
    required this.middleRingColor,
    required this.innerRingColor,
    required this.dividerColor,
    required this.sheenColor,
    required this.lightTextColor,
    required this.darkTextColor,
    required this.hubHighlightColor,
    required this.hubColor,
  });

  factory BenefitLotteryWheelPalette.stellaViaMock() {
    return const BenefitLotteryWheelPalette(
      prizeStyles: <BenefitLotteryWheelSegmentStyle>[
        _mockLightGoldSegment,
        _mockDeepGoldSegment,
      ],
      noWinStyle: _mockNoWinGoldSegment,
      outerRingColor: _mockOuterRingColor,
      darkRingColor: _mockDarkRingColor,
      middleRingColor: _mockMiddleRingColor,
      innerRingColor: _mockInnerRingColor,
      dividerColor: _mockDividerColor,
      sheenColor: _mockSheenColor,
      lightTextColor: _mockLightTextColor,
      darkTextColor: _mockTextColor,
      hubHighlightColor: _mockHubHighlightColor,
      hubColor: _mockHubColor,
    );
  }

  // Scoped design-token exception: these exact colors come from
  // docs/StellaVia_抽選UI_モック.html wheelSvgBlock(), where the roulette is a
  // fixed SVG. Keeping them local here gives the Flutter wheel the same visual
  // weight without spreading page-level hardcoded colors.
  static const Color _mockLightGoldStart = Color(0xFFF8E8C4);
  static const Color _mockLightGoldMiddle = Color(0xFFE3C890);
  static const Color _mockLightGoldEnd = Color(0xFFCDA35F);
  static const Color _mockDeepGoldStart = Color(0xFFC9A565);
  static const Color _mockDeepGoldMiddle = Color(0xFFA8813F);
  static const Color _mockDeepGoldEnd = Color(0xFF8A6530);
  static const Color _mockOuterRingColor = Color(0xFFB8954F);
  static const Color _mockDarkRingColor = Color(0xFF7A5A28);
  static const Color _mockMiddleRingColor = Color(0xFFD4B978);
  static const Color _mockInnerRingColor = Color(0xFFE8D2A0);
  static const Color _mockDividerColor = Color(0xB3FFFFFF);
  static const Color _mockSheenColor = Color(0x52FFFFFF);
  static const Color _mockLightTextColor = Color(0xFFFFFFFF);
  static const Color _mockTextColor = Color(0xFF0C1C50);
  static const Color _mockHubHighlightColor = Color(0xFF102A5E);
  static const Color _mockHubColor = Color(0xFF050C28);

  static const BenefitLotteryWheelSegmentStyle _mockLightGoldSegment =
      BenefitLotteryWheelSegmentStyle(
        startColor: _mockLightGoldStart,
        middleColor: _mockLightGoldMiddle,
        endColor: _mockLightGoldEnd,
      );

  static const BenefitLotteryWheelSegmentStyle _mockDeepGoldSegment =
      BenefitLotteryWheelSegmentStyle(
        startColor: _mockDeepGoldStart,
        middleColor: _mockDeepGoldMiddle,
        endColor: _mockDeepGoldEnd,
      );

  static const BenefitLotteryWheelSegmentStyle _mockNoWinGoldSegment =
      BenefitLotteryWheelSegmentStyle(
        startColor: _mockLightGoldStart,
        middleColor: _mockInnerRingColor,
        endColor: _mockLightGoldMiddle,
      );

  final List<BenefitLotteryWheelSegmentStyle> prizeStyles;
  final BenefitLotteryWheelSegmentStyle noWinStyle;
  final Color outerRingColor;
  final Color darkRingColor;
  final Color middleRingColor;
  final Color innerRingColor;
  final Color dividerColor;
  final Color sheenColor;
  final Color lightTextColor;
  final Color darkTextColor;
  final Color hubHighlightColor;
  final Color hubColor;

  BenefitLotteryWheelSegmentStyle styleForPrizeIndex(int prizeIndex) {
    return prizeStyles[prizeIndex % prizeStyles.length];
  }
}

class BenefitLotteryWheel extends StatefulWidget {
  const BenefitLotteryWheel({
    super.key,
    required this.controller,
    required this.centerLabel,
    this.size = 280,
    this.spinDuration = const Duration(milliseconds: 3600),
    this.minimumTurns = 5,
    this.onSpinCompleted,
  }) : assert(size >= 160),
       assert(minimumTurns > 0);

  final BenefitLotteryDrawController controller;
  final String centerLabel;
  final double size;
  final Duration spinDuration;
  final int minimumTurns;
  final ValueChanged<BenefitLotteryPrize>? onSpinCompleted;

  @override
  State<BenefitLotteryWheel> createState() => _BenefitLotteryWheelState();
}

class _BenefitLotteryWheelState extends State<BenefitLotteryWheel>
    with SingleTickerProviderStateMixin {
  static const Duration _noWinToastVisibleDuration = Duration(
    milliseconds: 1800,
  );

  late final AnimationController _animationController;
  Animation<double>? _rotationAnimation;
  double _rotationRadians = 0;
  int _handledSpinSequence = 0;
  int? _visibleNoWinToastSequence;
  Timer? _noWinToastTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.spinDuration,
    )..addListener(_handleAnimationTick);
    widget.controller.addListener(_handleDrawStateChanged);
    _handleDrawStateChanged();
  }

  @override
  void didUpdateWidget(covariant BenefitLotteryWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleDrawStateChanged);
      widget.controller.addListener(_handleDrawStateChanged);
      _handledSpinSequence = 0;
      _clearNoWinToast();
      _handleDrawStateChanged();
    }
    if (oldWidget.spinDuration != widget.spinDuration) {
      _animationController.duration = widget.spinDuration;
    }
  }

  @override
  void dispose() {
    _noWinToastTimer?.cancel();
    widget.controller.removeListener(_handleDrawStateChanged);
    if (widget.controller.phase == BenefitLotteryDrawPhase.spinning &&
        widget.controller.spinSequence == _handledSpinSequence) {
      widget.controller.completeSpinAnimation(_handledSpinSequence);
    }
    _animationController.dispose();
    super.dispose();
  }

  void _handleAnimationTick() {
    final animation = _rotationAnimation;
    if (animation == null || !mounted) {
      return;
    }
    setState(() => _rotationRadians = animation.value);
  }

  void _handleDrawStateChanged() {
    final controller = widget.controller;
    _syncNoWinToast(controller);
    if (controller.phase == BenefitLotteryDrawPhase.spinning &&
        controller.spinSequence != _handledSpinSequence &&
        controller.selectedPrize != null) {
      _handledSpinSequence = controller.spinSequence;
      unawaited(_animateToSelectedPrize(controller.selectedPrize!.id));
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _syncNoWinToast(BenefitLotteryDrawController controller) {
    final shouldShow =
        controller.phase == BenefitLotteryDrawPhase.completed &&
        controller.selectedPrize?.isNoWin == true;
    if (!shouldShow) {
      _clearNoWinToast();
      return;
    }
    if (_visibleNoWinToastSequence == controller.spinSequence) {
      return;
    }

    _noWinToastTimer?.cancel();
    _visibleNoWinToastSequence = controller.spinSequence;
    _noWinToastTimer = Timer(_noWinToastVisibleDuration, () {
      if (!mounted || _visibleNoWinToastSequence != controller.spinSequence) {
        return;
      }
      setState(() => _visibleNoWinToastSequence = null);
    });
  }

  void _clearNoWinToast() {
    _noWinToastTimer?.cancel();
    _noWinToastTimer = null;
    _visibleNoWinToastSequence = null;
  }

  Future<void> _animateToSelectedPrize(String prizeId) async {
    final model = widget.controller.model;
    final prizeIndex = model.indexOfPrize(prizeId);
    const fullTurn = math.pi * 2;
    final sweep = fullTurn / model.prizes.length;
    final currentModulo = _rotationRadians % fullTurn;
    final desiredModulo = (fullTurn - (prizeIndex * sweep)) % fullTurn;
    final correction = (desiredModulo - currentModulo + fullTurn) % fullTurn;
    final targetRotation =
        _rotationRadians + (widget.minimumTurns * fullTurn) + correction;

    _rotationAnimation =
        Tween<double>(begin: _rotationRadians, end: targetRotation).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    try {
      await _animationController.forward(from: 0);
    } on TickerCanceled {
      return;
    }
    if (!mounted) {
      return;
    }
    _rotationRadians = targetRotation;
    widget.controller.completeSpinAnimation(_handledSpinSequence);
    widget.onSpinCompleted?.call(widget.controller.model.prizeById(prizeId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    final locale = Localizations.localeOf(context);
    final priceFormatter = intl.NumberFormat.currency(
      locale: locale.toLanguageTag(),
      symbol: '¥',
      decimalDigits: 0,
    );
    final model = widget.controller.model;
    final wheelPalette = BenefitLotteryWheelPalette.stellaViaMock();
    final selectedPrize = widget.controller.selectedPrize;
    final showNoWinToast =
        selectedPrize?.isNoWin == true &&
        _visibleNoWinToastSequence == widget.controller.spinSequence;
    final semanticLabel = model.prizes
        .map((prize) {
          if (prize.isNoWin) {
            return prize.title;
          }
          return '${prize.title} ${priceFormatter.format(prize.price)}';
        })
        .join(', ');

    return Semantics(
      container: true,
      image: true,
      label: semanticLabel,
      child: SizedBox.square(
        dimension: widget.size,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(widget.size * 0.045),
                child: Transform.rotate(
                  angle: _rotationRadians,
                  child: CustomPaint(
                    key: const Key('benefit_lottery_wheel_canvas'),
                    painter: _BenefitLotteryWheelPainter(
                      model: model,
                      wheelPalette: wheelPalette,
                      titleStyle: appText.chip,
                      priceStyle: appText.micro,
                      priceFormatter: priceFormatter,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: CustomPaint(
                size: Size(widget.size * 0.10, widget.size * 0.085),
                painter: _BenefitLotteryPointerPainter(
                  color: wheelPalette.middleRingColor,
                ),
              ),
            ),
            Container(
              width: widget.size * 0.25,
              height: widget.size * 0.25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.35, -0.40),
                  radius: 0.75,
                  colors: <Color>[
                    wheelPalette.hubHighlightColor,
                    wheelPalette.hubColor,
                  ],
                ),
                border: Border.all(
                  color: wheelPalette.middleRingColor,
                  width: widget.size * 0.012,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colors.scrim.withValues(alpha: 0.24),
                    blurRadius: widget.size * 0.04,
                    offset: Offset(0, widget.size * 0.018),
                  ),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(UiTokens.spacing8),
                  child: Text(
                    widget.centerLabel,
                    style: appText.bodyStrong.copyWith(
                      color: wheelPalette.middleRingColor,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 460),
                    reverseDuration: const Duration(milliseconds: 180),
                    switchInCurve: Curves.easeOutBack,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          final slide = Tween<Offset>(
                            begin: const Offset(0, 0.18),
                            end: Offset.zero,
                          ).animate(animation);
                          final scale = Tween<double>(
                            begin: 0.72,
                            end: 1,
                          ).animate(animation);
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: slide,
                              child: ScaleTransition(
                                scale: scale,
                                child: child,
                              ),
                            ),
                          );
                        },
                    child: showNoWinToast
                        ? _BenefitLotteryNoWinToast(
                            key: ValueKey<int>(widget.controller.spinSequence),
                            label: selectedPrize!.title,
                            wheelPalette: wheelPalette,
                          )
                        : const SizedBox.shrink(
                            key: ValueKey<String>('no-win-hidden'),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitLotteryNoWinToast extends StatelessWidget {
  const _BenefitLotteryNoWinToast({
    required this.label,
    required this.wheelPalette,
    super.key,
  });

  final String label;
  final BenefitLotteryWheelPalette wheelPalette;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Semantics(
      liveRegion: true,
      label: label,
      child: Container(
        key: const Key('benefit_lottery_no_win_toast'),
        constraints: const BoxConstraints(minWidth: 112),
        padding: const EdgeInsets.symmetric(
          horizontal: UiTokens.spacing20,
          vertical: UiTokens.spacing12,
        ),
        decoration: BoxDecoration(
          color: colors.scrim.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(UiTokens.radius20),
          border: Border.all(color: wheelPalette.middleRingColor, width: 1.5),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.scrim.withValues(alpha: 0.32),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: appText.bodyStrong.copyWith(
            color: colors.onDark,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

class _BenefitLotteryWheelPainter extends CustomPainter {
  const _BenefitLotteryWheelPainter({
    required this.model,
    required this.wheelPalette,
    required this.titleStyle,
    required this.priceStyle,
    required this.priceFormatter,
  });

  final BenefitLotteryWheelModel model;
  final BenefitLotteryWheelPalette wheelPalette;
  final TextStyle titleStyle;
  final TextStyle priceStyle;
  final intl.NumberFormat priceFormatter;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outerRadius = math.min(size.width, size.height) / 2;
    final wheelRadius = outerRadius * 0.915;
    final wheelRect = Rect.fromCircle(center: center, radius: wheelRadius);
    final sweep = (math.pi * 2) / model.prizes.length;
    final startOffset = -math.pi / 2 - sweep / 2;

    canvas
      ..drawCircle(
        center,
        outerRadius,
        Paint()..color = wheelPalette.outerRingColor,
      )
      ..drawCircle(
        center,
        outerRadius * 0.97,
        Paint()..color = wheelPalette.darkRingColor,
      )
      ..drawCircle(
        center,
        outerRadius * 0.95,
        Paint()..color = wheelPalette.middleRingColor,
      )
      ..drawCircle(
        center,
        outerRadius * 0.915,
        Paint()..color = wheelPalette.innerRingColor,
      );

    var prizeStyleIndex = 0;
    for (var index = 0; index < model.prizes.length; index++) {
      final prize = model.prizes[index];
      final startAngle = startOffset + index * sweep;
      final segmentStyle = prize.isNoWin
          ? wheelPalette.noWinStyle
          : wheelPalette.styleForPrizeIndex(prizeStyleIndex++);
      final segmentCenterAngle = startAngle + sweep / 2;
      final gradientEnd = Offset(
        center.dx + math.cos(segmentCenterAngle) * wheelRadius,
        center.dy + math.sin(segmentCenterAngle) * wheelRadius,
      );
      final segmentPath = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(wheelRect, startAngle, sweep, false)
        ..close();
      canvas.drawPath(
        segmentPath,
        Paint()
          ..shader = ui.Gradient.linear(
            center,
            gradientEnd,
            <Color>[
              segmentStyle.startColor,
              segmentStyle.middleColor,
              segmentStyle.endColor,
            ],
            const <double>[0, 0.6, 1],
          ),
      );
      _paintPrizeLabel(
        canvas: canvas,
        center: center,
        radius: wheelRadius,
        segmentCenterAngle: segmentCenterAngle,
        prize: prize,
        segmentColor: segmentStyle.swatchColor,
      );
    }

    final dividerPaint = Paint()
      ..color = wheelPalette.dividerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = outerRadius * 0.008;
    for (var index = 0; index < model.prizes.length; index++) {
      final angle = startOffset + index * sweep;
      canvas.drawLine(
        center,
        Offset(
          center.dx + math.cos(angle) * wheelRadius,
          center.dy + math.sin(angle) * wheelRadius,
        ),
        dividerPaint,
      );
    }

    canvas.drawCircle(
      center,
      wheelRadius,
      Paint()
        ..shader = RadialGradient(
          center: Alignment.topCenter,
          radius: 0.70,
          colors: <Color>[
            wheelPalette.sheenColor,
            wheelPalette.sheenColor.withValues(alpha: 0),
          ],
        ).createShader(wheelRect),
    );
  }

  void _paintPrizeLabel({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double segmentCenterAngle,
    required BenefitLotteryPrize prize,
    required Color segmentColor,
  }) {
    final labelRadius = radius * 0.66;
    final labelCenter = Offset(
      center.dx + math.cos(segmentCenterAngle) * labelRadius,
      center.dy + math.sin(segmentCenterAngle) * labelRadius,
    );
    final isDense = model.prizes.length >= 7;
    final textColor =
        ThemeData.estimateBrightnessForColor(segmentColor) == Brightness.dark
        ? wheelPalette.lightTextColor
        : wheelPalette.darkTextColor;
    final titleScale = isDense ? 0.72 : 0.86;
    final priceScale = isDense ? 0.72 : 0.84;
    final titlePainter = TextPainter(
      text: TextSpan(
        text: prize.title,
        style: titleStyle.copyWith(
          color: textColor,
          fontSize: titleStyle.fontSize! * titleScale,
          fontWeight: FontWeight.w800,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 2,
      ellipsis: '…',
    )..layout(maxWidth: radius * (isDense ? 0.48 : 0.58));
    final pricePainter = prize.isNoWin
        ? null
        : (TextPainter(
            text: TextSpan(
              text: priceFormatter.format(prize.price),
              style: priceStyle.copyWith(
                color: textColor,
                fontSize: priceStyle.fontSize! * priceScale,
                fontWeight: FontWeight.w700,
              ),
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            maxLines: 1,
          )..layout(maxWidth: radius * (isDense ? 0.48 : 0.58)));
    final contentHeight =
        titlePainter.height + (pricePainter == null ? 0 : pricePainter.height);

    canvas.save();
    canvas.translate(labelCenter.dx, labelCenter.dy);
    canvas.rotate(segmentCenterAngle + math.pi / 2);
    titlePainter.paint(
      canvas,
      Offset(-titlePainter.width / 2, -contentHeight / 2),
    );
    if (pricePainter != null) {
      pricePainter.paint(
        canvas,
        Offset(
          -pricePainter.width / 2,
          -contentHeight / 2 + titlePainter.height,
        ),
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BenefitLotteryWheelPainter oldDelegate) {
    return oldDelegate.model != model ||
        oldDelegate.wheelPalette != wheelPalette ||
        oldDelegate.titleStyle != titleStyle ||
        oldDelegate.priceStyle != priceStyle;
  }
}

class _BenefitLotteryPointerPainter extends CustomPainter {
  const _BenefitLotteryPointerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _BenefitLotteryPointerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
