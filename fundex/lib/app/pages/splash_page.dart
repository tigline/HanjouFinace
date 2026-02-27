import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../localization/app_localizations_ext.dart';

const Duration _minimumSplashDuration = Duration(milliseconds: 2500);
const Duration _progressFillDuration = Duration(milliseconds: 2000);
const Duration _logoPulseDuration = Duration(milliseconds: 2000);

String? resolveSplashNavigationTarget(AsyncValue<bool> authState) {
  if (authState.isLoading) {
    return null;
  }

  final isAuthenticated = authState.asData?.value ?? false;
  return isAuthenticated ? '/home' : '/login';
}

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late final DateTime _enteredAt;
  late final AnimationController _logoPulseController;
  late final Animation<double> _logoScaleAnimation;
  late final AnimationController _progressController;
  Timer? _deferredNavigationTimer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _enteredAt = DateTime.now();

    _logoPulseController = AnimationController(
      vsync: this,
      duration: _logoPulseDuration,
    )..repeat(reverse: true);

    _logoScaleAnimation = Tween<double>(begin: 1, end: 1.05).animate(
      CurvedAnimation(parent: _logoPulseController, curve: Curves.easeInOut),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: _progressFillDuration,
    )..forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleNavigation(ref.read(isAuthenticatedProvider));
    });
  }

  @override
  void dispose() {
    _deferredNavigationTimer?.cancel();
    _logoPulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _scheduleNavigation(AsyncValue<bool> authState) {
    if (!mounted || _hasNavigated) {
      return;
    }

    final targetRoute = resolveSplashNavigationTarget(authState);
    if (targetRoute == null) {
      _deferredNavigationTimer?.cancel();
      return;
    }

    final elapsed = DateTime.now().difference(_enteredAt);
    final remaining = _minimumSplashDuration - elapsed;

    _deferredNavigationTimer?.cancel();
    if (remaining <= Duration.zero) {
      _navigate(targetRoute);
      return;
    }

    _deferredNavigationTimer = Timer(remaining, () {
      _navigate(targetRoute);
    });
  }

  void _navigate(String targetRoute) {
    if (!mounted || _hasNavigated) {
      return;
    }
    _hasNavigated = true;
    context.go(targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(isAuthenticatedProvider, (previous, next) {
      _scheduleNavigation(next);
    });

    _scheduleNavigation(ref.watch(isAuthenticatedProvider));

    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      key: const Key('splash_page'),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.65, -1),
            end: Alignment(0.85, 1),
            colors: <Color>[
              Color(0xFF0A1628),
              Color(0xFF1E3A5F),
              Color(0xFF0A1628),
            ],
            stops: <double>[0, 0.5, 1],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[Color(0xFF2563EB), Color(0xFF60A5FA)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x662563EB),
                          blurRadius: 32,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      size: 44,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.splashBrandName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.splashTagline,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 120,
                  height: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: AnimatedBuilder(
                      animation: _progressController,
                      builder: (BuildContext context, Widget? child) {
                        return Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Container(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            FractionallySizedBox(
                              widthFactor: _progressController.value,
                              alignment: Alignment.centerLeft,
                              child: const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: <Color>[
                                      Color(0xFF2563EB),
                                      Color(0xFF60A5FA),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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
