import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../../app/localization/app_localizations_ext.dart';
import '../../../discussion_board/presentation/providers/discussion_board_providers.dart';
import '../../../discussion_board/presentation/state/discussion_send_queue_state.dart';
import '../providers/main_shell_providers.dart';

class MainShellPage extends ConsumerStatefulWidget {
  const MainShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends ConsumerState<MainShellPage>
    with SingleTickerProviderStateMixin {
  static const double _chromeRevealScrollDistance = 96;
  static const double _chromeRevealActivationDistance = 18;
  static const double _defaultGoldRingRotation = math.pi / 2;

  late final AnimationController _chromeSnapController;
  Animation<double>? _chromeSnapAnimation;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  double _pendingChromeRevealDistance = 0;
  double _goldRingRotation = _defaultGoldRingRotation;

  @override
  void initState() {
    super.initState();
    _chromeSnapController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 160),
        )..addListener(() {
          final animation = _chromeSnapAnimation;
          if (animation == null) {
            return;
          }
          _setChromeReveal(animation.value);
        });
    _startGoldRingMotionTracking();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _chromeSnapController.dispose();
    super.dispose();
  }

  void _startGoldRingMotionTracking() {
    if (kIsWeb) {
      return;
    }
    _accelerometerSubscription =
        accelerometerEventStream(
          samplingPeriod: SensorInterval.uiInterval,
        ).listen(
          _handleAccelerometerEvent,
          onError: (_) {
            _accelerometerSubscription?.cancel();
            _accelerometerSubscription = null;
          },
          cancelOnError: true,
        );
  }

  void _handleAccelerometerEvent(AccelerometerEvent event) {
    final verticalMagnitude = math.sqrt(event.y * event.y + event.z * event.z);
    if (verticalMagnitude < 0.8) {
      return;
    }
    final xAxisPitch = math.atan2(event.z, event.y.abs());
    final targetRotation = _defaultGoldRingRotation + xAxisPitch;
    final nextRotation = _lerpAngle(_goldRingRotation, targetRotation, 0.14);
    if ((nextRotation - _goldRingRotation).abs() < 0.01) {
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _goldRingRotation = nextRotation;
    });
  }

  double _lerpAngle(double current, double target, double factor) {
    final delta = (target - current + math.pi) % (math.pi * 2) - math.pi;
    return current + delta * factor;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    //_showChrome();
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _setChromeReveal(double reveal) {
    final nextReveal = reveal.clamp(0, 1).toDouble();
    final currentReveal = ref.read(mainShellChromeRevealProvider);
    if ((currentReveal - nextReveal).abs() < 0.001) {
      return;
    }
    ref.read(mainShellChromeRevealProvider.notifier).state = nextReveal;
    ref.read(mainShellChromeVisibleProvider.notifier).state = nextReveal > 0.01;
  }

  void _showChrome() {
    _chromeSnapController.stop();
    _pendingChromeRevealDistance = 0;
    _setChromeReveal(1);
  }

  void _snapChromeReveal(ScrollMetrics metrics) {
    _pendingChromeRevealDistance = 0;
    final currentReveal = ref.read(mainShellChromeRevealProvider);
    final isAtBottom = metrics.extentAfter <= 1;
    if (isAtBottom && currentReveal > 0.01) {
      return;
    }
    final targetReveal = currentReveal >= 0.5 ? 1.0 : 0.0;
    if ((currentReveal - targetReveal).abs() < 0.001) {
      _setChromeReveal(targetReveal);
      return;
    }
    _chromeSnapAnimation =
        Tween<double>(begin: currentReveal, end: targetReveal).animate(
          CurvedAnimation(
            parent: _chromeSnapController,
            curve: Curves.easeOutCubic,
          ),
        );
    _chromeSnapController.forward(from: 0);
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }
    if (notification.metrics.pixels <= notification.metrics.minScrollExtent) {
      _showChrome();
      return false;
    }
    if (notification.metrics.outOfRange) {
      return false;
    }
    if (notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle) {
      _snapChromeReveal(notification.metrics);
      return false;
    }
    if (notification is! ScrollUpdateNotification) {
      return false;
    }

    final delta = notification.scrollDelta ?? 0;
    if (delta == 0) {
      return false;
    }
    _chromeSnapController.stop();
    final currentReveal = ref.read(mainShellChromeRevealProvider);
    if (delta > 0 &&
        currentReveal > 0.01 &&
        notification.metrics.extentAfter <= 1) {
      return false;
    }
    var effectiveDelta = delta;
    if (delta < 0 && currentReveal <= 0.01) {
      _pendingChromeRevealDistance += -delta;
      if (_pendingChromeRevealDistance < _chromeRevealActivationDistance) {
        return false;
      }
      effectiveDelta =
          -(_pendingChromeRevealDistance - _chromeRevealActivationDistance);
      _pendingChromeRevealDistance = _chromeRevealActivationDistance;
    } else if (delta > 0 || currentReveal > 0.01) {
      _pendingChromeRevealDistance = 0;
    }
    final nextReveal =
        currentReveal - (effectiveDelta / _chromeRevealScrollDistance);
    _setChromeReveal(nextReveal);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final colorScheme = theme.colorScheme;
    final shellNavigationTheme = theme.extension<AppShellNavigationTheme>()!;
    final sendQueueState = ref.watch(discussionSendQueueProvider);
    final inactiveTabBackgroundColor = Color.alphaBlend(
      colors.highlightGold.withValues(alpha: 0.18),
      colors.surface,
    );
    final currentTabIndex = ref.watch(mainShellCurrentTabIndexProvider);
    final chromeReveal = ref
        .watch(mainShellChromeRevealProvider)
        .clamp(0, 1)
        .toDouble();
    final primaryScrollController = ref
        .watch(mainShellScrollControllerRegistryProvider)
        .controllerFor(currentTabIndex);
    if (currentTabIndex != widget.navigationShell.currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        if (ref.read(mainShellCurrentTabIndexProvider) !=
            widget.navigationShell.currentIndex) {
          ref.read(mainShellCurrentTabIndexProvider.notifier).state =
              widget.navigationShell.currentIndex;
          _showChrome();
        }
      });
    }

    return PrimaryScrollController(
      controller: primaryScrollController,
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Scaffold(
          key: const Key('home_page'),
          body: SafeArea(
            top: false,
            bottom: false,
            child: widget.navigationShell,
          ),
          bottomNavigationBar: DecoratedBox(
            decoration: BoxDecoration(color: colors.surfaceAlt,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colors.highlightGold.withValues(alpha: 0.8),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _DiscussionSendQueueBar(
                  state: sendQueueState,
                  title: l10n.kizunarkSendingQueueTitle(
                    sendQueueState.pendingCount,
                  ),
                  cancelLabel: l10n.commonCancel,
                  onCancel: () => ref
                      .read(discussionSendQueueProvider.notifier)
                      .cancelAll(),
                ),
                ClipRect(
                  clipBehavior: Clip.none,
                  child: Opacity(
                    opacity: chromeReveal,
                    child: Align(
                      heightFactor: chromeReveal,
                      alignment: Alignment.bottomCenter,
                      child: FractionalTranslation(
                        translation: Offset(0, 1 - chromeReveal),
                        child: IgnorePointer(
                          ignoring: chromeReveal <= 0.01,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // Container(
                              //   height: 1,
                              //   width: double.infinity,
                              //   color: colors.border,
                              // ),
                              SafeArea(
                                top: false,
                                child: SizedBox(
                                  key: const Key('main_tab_bar'),
                                  height: 78,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: _MainTabItem(
                                              label: l10n.mainTabHome,
                                              isSelected:
                                                  currentTabIndex ==
                                                  MainShellTab.home.index,
                                              labelColor:
                                                  currentTabIndex ==
                                                      MainShellTab.home.index
                                                  ? colorScheme.primary
                                                  : shellNavigationTheme
                                                        .bottomTabInactiveColor,
                                              onTap: () =>
                                                  _onDestinationSelected(
                                                    context,
                                                    MainShellTab.home.index,
                                                  ),
                                              badge: _MainTabBadge(
                                                backgroundColor:
                                                    currentTabIndex ==
                                                        MainShellTab.home.index
                                                    ? colorScheme.primary
                                                    : inactiveTabBackgroundColor,
                                                child: Icon(
                                                  Icons.home_rounded,
                                                  size: 24,
                                                  color:
                                                      currentTabIndex ==
                                                          MainShellTab
                                                              .home
                                                              .index
                                                      ? colors.onDark
                                                      : shellNavigationTheme
                                                            .bottomTabInactiveColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: _MainTabItem(
                                              label: l10n.mainTabHotel,
                                              isSelected:
                                                  currentTabIndex ==
                                                  MainShellTab.hotel.index,
                                              labelColor:
                                                  currentTabIndex ==
                                                      MainShellTab.hotel.index
                                                  ? colorScheme.primary
                                                  : shellNavigationTheme
                                                        .bottomTabInactiveColor,
                                              onTap: () =>
                                                  _onDestinationSelected(
                                                    context,
                                                    MainShellTab.hotel.index,
                                                  ),
                                              badge: _MainTabBadge(
                                                backgroundColor:
                                                    currentTabIndex ==
                                                        MainShellTab.hotel.index
                                                    ? colorScheme.primary
                                                    : inactiveTabBackgroundColor,
                                                child: Icon(
                                                  Icons.hotel_rounded,
                                                  size: 24,
                                                  color:
                                                      currentTabIndex ==
                                                          MainShellTab
                                                              .hotel
                                                              .index
                                                      ? colors.onDark
                                                      : shellNavigationTheme
                                                            .bottomTabInactiveColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: _MainTabItem(
                                              center: true,
                                              label: l10n.mainTabInvestment,
                                              isSelected:
                                                  currentTabIndex ==
                                                  MainShellTab.investment.index,
                                              labelColor:
                                                  currentTabIndex ==
                                                      MainShellTab
                                                          .investment
                                                          .index
                                                  ? colorScheme.primary
                                                  : colors.highlightGold,
                                              onTap: () =>
                                                  _onDestinationSelected(
                                                    context,
                                                    MainShellTab
                                                        .investment
                                                        .index,
                                                  ),
                                              badge: _MainTabBadge(
                                                isSelected:
                                                    currentTabIndex ==
                                                    MainShellTab
                                                        .investment
                                                        .index,
                                                center: true,
                                                goldRingRotation:
                                                    _goldRingRotation,
                                                backgroundColor:
                                                    currentTabIndex ==
                                                        MainShellTab
                                                            .investment
                                                            .index
                                                    ? colorScheme.primary
                                                    : inactiveTabBackgroundColor,
                                                child: Icon(
                                                  Symbols.finance_mode,
                                                  size: 24,
                                                  color:
                                                      currentTabIndex ==
                                                          MainShellTab
                                                              .investment
                                                              .index
                                                      ? colors.onDark
                                                      : colors.highlightGold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: _MainTabItem(
                                              label: l10n.mainTabKizunark,
                                              isSelected:
                                                  currentTabIndex ==
                                                  MainShellTab.kizunark.index,
                                              labelColor:
                                                  currentTabIndex ==
                                                      MainShellTab
                                                          .kizunark
                                                          .index
                                                  ? colorScheme.primary
                                                  : shellNavigationTheme
                                                        .bottomTabInactiveColor,
                                              onTap: () =>
                                                  _onDestinationSelected(
                                                    context,
                                                    MainShellTab.kizunark.index,
                                                  ),
                                              badge: _MainTabBadge(
                                                backgroundColor:
                                                    currentTabIndex ==
                                                        MainShellTab
                                                            .kizunark
                                                            .index
                                                    ? colorScheme.primary
                                                    : inactiveTabBackgroundColor,
                                                child: Image.asset(
                                                  'assets/images/kizunark.tab.normal.png',
                                                  width: 24,
                                                  height: 24,
                                                  fit: BoxFit.contain,
                                                  color:
                                                      currentTabIndex ==
                                                          MainShellTab
                                                              .kizunark
                                                              .index
                                                      ? colors.onDark
                                                      : shellNavigationTheme
                                                            .bottomTabInactiveColor,
                                                  colorBlendMode:
                                                      BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            child: _MainTabItem(
                                              label: l10n.mainTabProfile,
                                              isSelected:
                                                  currentTabIndex ==
                                                  MainShellTab.profile.index,
                                              labelColor:
                                                  currentTabIndex ==
                                                      MainShellTab.profile.index
                                                  ? colorScheme.primary
                                                  : shellNavigationTheme
                                                        .bottomTabInactiveColor,
                                              onTap: () =>
                                                  _onDestinationSelected(
                                                    context,
                                                    MainShellTab.profile.index,
                                                  ),
                                              badge: _MainTabBadge(
                                                backgroundColor:
                                                    currentTabIndex ==
                                                        MainShellTab
                                                            .profile
                                                            .index
                                                    ? colorScheme.primary
                                                    : inactiveTabBackgroundColor,
                                                child: Icon(
                                                  Icons.person_rounded,
                                                  size: 24,
                                                  color:
                                                      currentTabIndex ==
                                                          MainShellTab
                                                              .profile
                                                              .index
                                                      ? colors.onDark
                                                      : shellNavigationTheme
                                                            .bottomTabInactiveColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DiscussionSendQueueBar extends StatelessWidget {
  const _DiscussionSendQueueBar({
    required this.state,
    required this.title,
    required this.cancelLabel,
    required this.onCancel,
  });

  final DiscussionSendQueueState state;
  final String title;
  final String cancelLabel;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: state.isActive
          ? ColoredBox(
              key: const ValueKey<String>('discussion-send-queue-bar'),
              color: colors.surface,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 2, 12, 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: appText.bodyStrong.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: onCancel,
                          style: TextButton.styleFrom(
                            minimumSize: const Size(48, 24),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            foregroundColor: colors.primary,
                            textStyle: appText.bodyStrong,
                          ),
                          child: Text(cancelLabel),
                        ),
                      ],
                    ),
                  ),
                  LinearProgressIndicator(
                    value: state.progress.clamp(0, 1).toDouble(),
                    minHeight: 3,
                    backgroundColor: colors.borderSoft,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _MainTabItem extends StatelessWidget {
  const _MainTabItem({
    required this.label,
    required this.isSelected,
    required this.labelColor,
    required this.onTap,
    required this.badge,
    this.center = false,
  });

  final String label;
  final bool isSelected;
  final Color labelColor;
  final VoidCallback onTap;
  final Widget badge;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelMedium;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //const SizedBox(height: 4),
          Transform.translate(
            offset: Offset(0, center ? -4 : 0),
            child: Column(
              children: [
                const SizedBox(height: 4),
                badge,
                SizedBox(height: center ? 4 : 4),
                Text(
                  label,
                  style: labelStyle?.copyWith(
                    color: labelColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MainTabBadge extends StatelessWidget {
  const _MainTabBadge({
    required this.backgroundColor,
    required this.child,
    this.center = false,
    this.isSelected = false,
    this.goldRingRotation = _MainShellPageState._defaultGoldRingRotation,
  });

  final Color backgroundColor;
  final Widget child;
  final bool center;
  final bool isSelected;
  final double goldRingRotation;

  static const double _layoutSize = 40;
  static const double _centerVisualSize = 60;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    //final showGoldRing = center;
    final badge = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.32),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SizedBox(
        width: _layoutSize,
        height: _layoutSize,
        child: Center(child: child),
      ),
    );
    final paintedBadge = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.surfaceAlt,
          width: 4,
        ),
      ),
      child: CustomPaint(
        foregroundPainter: _MainTabGoldRingPainter(
          baseGold: colors.highlightGold,
          lightGold: colors.warningBorder,
          glowColor: colors.highlightGold.withValues(alpha: 0.45),
          rotation: goldRingRotation,
        ),
        child: badge,
      ),
    );

    if (!center) {
      return badge;
    }
    return Transform.scale(
      scale: _centerVisualSize / _layoutSize,
      alignment: Alignment.bottomCenter,
      child: paintedBadge,
    );
  }
}

class _MainTabGoldRingPainter extends CustomPainter {
  const _MainTabGoldRingPainter({
    required this.baseGold,
    required this.lightGold,
    required this.glowColor,
    required this.rotation,
  });

  final Color baseGold;
  final Color lightGold;
  final Color glowColor;
  final double rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final shortestSide = math.min(size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = shortestSide * 0.07;
    final radius = shortestSide / 2 - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 1.35
      ..color = glowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, strokeWidth * 0.7);
    canvas.drawCircle(center, radius, glowPaint);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        transform: GradientRotation(rotation),
        colors: <Color>[
          lightGold,
          baseGold,
          baseGold,
          baseGold,
          lightGold,
          baseGold,
          baseGold,
          baseGold,
          lightGold,
        ],
        stops: const <double>[0, 0.06, 0.18, 0.44, 0.50, 0.56, 0.82, 0.94, 1],
      ).createShader(rect);
    canvas.drawCircle(center, radius, ringPaint);
  }

  @override
  bool shouldRepaint(covariant _MainTabGoldRingPainter oldDelegate) {
    return oldDelegate.baseGold != baseGold ||
        oldDelegate.lightGold != lightGold ||
        oldDelegate.glowColor != glowColor ||
        oldDelegate.rotation != rotation;
  }
}
