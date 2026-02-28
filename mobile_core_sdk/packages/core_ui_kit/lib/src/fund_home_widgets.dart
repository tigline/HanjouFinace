import 'package:flutter/material.dart';

import 'app_color_tokens.dart';
import 'app_theme_extensions.dart';
import 'ui_tokens.dart';

class FundHomeHeroSummary extends StatelessWidget {
  const FundHomeHeroSummary({
    super.key,
    required this.greeting,
    required this.totalAssetsLabel,
    required this.totalAssetsValue,
    required this.totalAssetsDelta,
    required this.activeInvestmentLabel,
    required this.activeInvestmentValue,
    required this.totalDividendsLabel,
    required this.totalDividendsValue,
    this.onNotificationTap,
    this.showNotificationDot = false,
  });

  final String greeting;
  final String totalAssetsLabel;
  final String totalAssetsValue;
  final String totalAssetsDelta;
  final String activeInvestmentLabel;
  final String activeInvestmentValue;
  final String totalDividendsLabel;
  final String totalDividendsValue;
  final VoidCallback? onNotificationTap;
  final bool showNotificationDot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = Colors.white;

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColorTokens.fundexPrimaryDark,
            AppColorTokens.fundexPrimaryDarkDradient,
          ],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -40,
            right: -40,
            child: IgnorePointer(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      AppColorTokens.fundexAccent.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        greeting,
                        style:
                            (theme.textTheme.titleMedium ?? const TextStyle())
                                .copyWith(
                                  color: foregroundColor,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ),
                    _FundHeroNotificationButton(
                      showDot: showNotificationDot,
                      onTap: onNotificationTap,
                    ),
                  ],
                ),
                const SizedBox(height: UiTokens.spacing16),
                _FundHeroMetricCard(
                  label: totalAssetsLabel,
                  value: totalAssetsValue,
                  subtitle: totalAssetsDelta,
                  isPrimary: true,
                ),
                const SizedBox(height: UiTokens.spacing8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _FundHeroMetricCard(
                        label: activeInvestmentLabel,
                        value: activeInvestmentValue,
                        isPrimary: false,
                      ),
                    ),
                    const SizedBox(width: UiTokens.spacing8),
                    Expanded(
                      child: _FundHeroMetricCard(
                        label: totalDividendsLabel,
                        value: totalDividendsValue,
                        isPrimary: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FundHeroNotificationButton extends StatelessWidget {
  const _FundHeroNotificationButton({
    required this.showDot,
    required this.onTap,
  });

  final bool showDot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(
            child: Material(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(11),
              child: InkWell(
                borderRadius: BorderRadius.circular(11),
                onTap: onTap,
                child: const Icon(
                  Icons.notifications_none_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (showDot)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColorTokens.fundexDanger,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColorTokens.fundexPrimaryDark,
                    width: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FundHeroMetricCard extends StatelessWidget {
  const _FundHeroMetricCard({
    required this.label,
    required this.value,
    required this.isPrimary,
    this.subtitle,
  });

  final String label;
  final String value;
  final String? subtitle;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueStyle =
        (isPrimary
            ? theme.textTheme.headlineSmall
            : theme.textTheme.titleLarge) ??
        const TextStyle();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isPrimary ? 0.15 : 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: (theme.textTheme.labelSmall ?? const TextStyle()).copyWith(
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: valueStyle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: isPrimary ? 26 : 16,
              height: isPrimary ? 1.1 : 1.2,
            ),
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: (theme.textTheme.labelSmall ?? const TextStyle()).copyWith(
                color: AppColorTokens.fundexSuccess,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum FundReminderTone { warning, info }

class FundReminderData {
  const FundReminderData({
    required this.leading,
    required this.title,
    required this.message,
    this.tone = FundReminderTone.warning,
    this.progress,
    this.actionLabel,
    this.onActionTap,
    this.onTap,
  });

  final Widget leading;
  final String title;
  final String message;
  final FundReminderTone tone;
  final double? progress;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final VoidCallback? onTap;
}

class FundReminderFeed extends StatelessWidget {
  const FundReminderFeed({super.key, required this.items, this.spacing = 12});

  final List<FundReminderData> items;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: <Widget>[
        for (var index = 0; index < items.length; index++) ...<Widget>[
          FundReminderCard(data: items[index]),
          if (index < items.length - 1) SizedBox(height: spacing),
        ],
      ],
    );
  }
}

class FundReminderCard extends StatelessWidget {
  const FundReminderCard({super.key, required this.data});

  final FundReminderData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = _paletteFor(data.tone);
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: palette.backgroundGradientColors,
        ),
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        border: Border.all(color: palette.borderColor, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          data.leading,
          const SizedBox(width: UiTokens.spacing8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data.title,
                  style: (theme.textTheme.labelLarge ?? const TextStyle())
                      .copyWith(
                        color: palette.titleColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.message,
                  style: (theme.textTheme.bodySmall ?? const TextStyle())
                      .copyWith(color: palette.messageColor, height: 1.45),
                ),
                if (data.progress != null) ...<Widget>[
                  const SizedBox(height: UiTokens.spacing8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: data.progress!.clamp(0, 1),
                      minHeight: 4,
                      backgroundColor: palette.progressTrackColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        palette.progressFillColor,
                      ),
                    ),
                  ),
                ],
                if (data.actionLabel != null) ...<Widget>[
                  const SizedBox(height: UiTokens.spacing8),
                  OutlinedButton(
                    onPressed: data.onActionTap,
                    style: OutlinedButton.styleFrom(
                      visualDensity: const VisualDensity(
                        horizontal: -2,
                        vertical: -2,
                      ),
                      foregroundColor: palette.actionTextColor,
                      side: BorderSide(
                        color: palette.actionBorderColor,
                        width: 1.5,
                      ),
                      backgroundColor: Colors.white,
                      minimumSize: const Size(0, 30),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      data.actionLabel!,
                      style: (theme.textTheme.labelSmall ?? const TextStyle())
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (data.onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        onTap: data.onTap,
        child: card,
      ),
    );
  }
}

class _FundReminderPalette {
  const _FundReminderPalette({
    required this.backgroundGradientColors,
    required this.borderColor,
    required this.titleColor,
    required this.messageColor,
    required this.progressTrackColor,
    required this.progressFillColor,
    required this.actionTextColor,
    required this.actionBorderColor,
  });

  final List<Color> backgroundGradientColors;
  final Color borderColor;
  final Color titleColor;
  final Color messageColor;
  final Color progressTrackColor;
  final Color progressFillColor;
  final Color actionTextColor;
  final Color actionBorderColor;
}

_FundReminderPalette _paletteFor(FundReminderTone tone) {
  switch (tone) {
    case FundReminderTone.warning:
      return const _FundReminderPalette(
        backgroundGradientColors: <Color>[Color(0xFFFEF3C7), Color(0xFFFFFBEB)],
        borderColor: Color(0xFFFCD34D),
        titleColor: Color(0xFF92400E),
        messageColor: Color(0xFFA16207),
        progressTrackColor: Color(0xFFFDE68A),
        progressFillColor: Color(0xFFF59E0B),
        actionTextColor: Color(0xFFD97706),
        actionBorderColor: Color(0xFFF59E0B),
      );
    case FundReminderTone.info:
      return const _FundReminderPalette(
        backgroundGradientColors: <Color>[Color(0xFFEFF6FF), Color(0xFFF8FBFF)],
        borderColor: Color(0xFFBFDBFE),
        titleColor: Color(0xFF1D4ED8),
        messageColor: Color(0xFF1E3A8A),
        progressTrackColor: Color(0xFFDBEAFE),
        progressFillColor: Color(0xFF2563EB),
        actionTextColor: Color(0xFF1D4ED8),
        actionBorderColor: Color(0xFF3B82F6),
      );
  }
}

class FundSectionHeader extends StatelessWidget {
  const FundSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            ),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class FundFeaturedFundTagData {
  const FundFeaturedFundTagData({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
}

class FundFeaturedFundCardData {
  const FundFeaturedFundCardData({
    required this.title,
    required this.annualYield,
    required this.metadata,
    required this.progress,
    this.progressLabel,
    this.tags = const <FundFeaturedFundTagData>[],
    this.artworkGradientColors = const <Color>[
      Color(0xFF0F172A),
      Color(0xFF1E3A5F),
      Color(0xFF2563EB),
    ],
    this.onTap,
  });

  final String title;
  final String annualYield;
  final String metadata;
  final double progress;
  final String? progressLabel;
  final List<FundFeaturedFundTagData> tags;
  final List<Color> artworkGradientColors;
  final VoidCallback? onTap;
}

class FundFeaturedFundCarousel extends StatelessWidget {
  const FundFeaturedFundCarousel({
    super.key,
    required this.title,
    required this.children,
    this.actionLabel,
    this.onActionTap,
    this.height = 240,
    this.itemSpacing = 12,
    this.headerSpacing = 0,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final List<Widget> children;
  final double height;
  final double itemSpacing;
  final double headerSpacing;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: const EdgeInsets.symmetric(horizontal: UiTokens.spacing16),
          child:
          FundSectionHeader(
            title: title,
            actionLabel: actionLabel,
            onActionTap: onActionTap,
          ),
        ),
        SizedBox(height: headerSpacing),
        SizedBox(
          height: height,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (
                  var index = 0;
                  index < children.length;
                  index++
                ) ...<Widget>[
                  children[index],
                  if (index < children.length - 1) SizedBox(width: itemSpacing),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FundFeaturedFundCard extends StatelessWidget {
  const FundFeaturedFundCard({
    super.key,
    required this.data,
    required this.yieldLabel,
    this.width = 280,
    this.shadowPadding = const EdgeInsets.fromLTRB(2, 2, 2, 8),
  });

  final FundFeaturedFundCardData data;
  final String yieldLabel;
  final double width;
  final EdgeInsetsGeometry shadowPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hotelTheme = theme.extension<AppFTKTheme>();
    final borderColor =
        hotelTheme?.cardBorderColor.withValues(alpha: 0.9) ??
        theme.dividerColor.withValues(alpha: 0.8);
    final shadowColor = hotelTheme?.cardTileShadowColor ?? Colors.black12;
    final cardRadius = BorderRadius.circular(UiTokens.radius16);

    return SizedBox(
      width: width,
      height: double.infinity,
      child: Padding(
        padding: shadowPadding,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: cardRadius,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: cardRadius,
              side: BorderSide(color: borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              borderRadius: cardRadius,
              onTap: data.onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 130,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: data.artworkGradientColors,
                            ),
                          ),
                        ),
                        const _FundCityArtworkLayer(),
                        if (data.tags.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: data.tags
                                  .map(
                                    (FundFeaturedFundTagData tag) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: tag.backgroundColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        tag.label,
                                        style:
                                            (theme.textTheme.labelSmall ??
                                                    const TextStyle())
                                                .copyWith(
                                                  color: tag.foregroundColor,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              data.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  (theme.textTheme.titleSmall ??
                                          const TextStyle())
                                      .copyWith(fontWeight: FontWeight.w900),
                          ),
                          
                          const SizedBox(height: UiTokens.spacing8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      yieldLabel,
                                      style:
                                          (theme.textTheme.labelSmall ??
                                                  const TextStyle())
                                              .copyWith(
                                                color: AppColorTokens
                                                    .fundexTextSecondary,
                                              ),
                                    ),
                                    //const SizedBox(height: 2),
                                    Text(
                                      data.annualYield,
                                      style:
                                          (theme.textTheme.headlineSmall ??
                                                  const TextStyle())
                                              .copyWith(
                                                color:
                                                    AppColorTokens.fundexDanger,
                                                fontWeight: FontWeight.w900,
                                                height: 1.0,
                                              ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: UiTokens.spacing8),
                              Text(
                                data.metadata,
                                textAlign: TextAlign.end,
                                style:
                                    (theme.textTheme.labelSmall ??
                                            const TextStyle())
                                        .copyWith(
                                          color: AppColorTokens
                                              .fundexTextSecondary,
                                        ),
                              ),
                            ],
                          ),
                          const SizedBox(height: UiTokens.spacing4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              minHeight: 5,
                              value: data.progress.clamp(0, 1),
                              backgroundColor: AppColorTokens.fundexBorder,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColorTokens.fundexAccent,
                              ),
                            ),
                          ),
                          if (data.progressLabel != null) ...<Widget>[
                            const SizedBox(height: UiTokens.spacing4),
                            Text(
                              data.progressLabel!,
                              style:
                                  (theme.textTheme.labelSmall ??
                                          const TextStyle())
                                      .copyWith(
                                        color:
                                            AppColorTokens.fundexTextSecondary,
                                      ),
                            ),
                          ],
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
    );
  }
}

class _FundCityArtworkLayer extends StatelessWidget {
  const _FundCityArtworkLayer();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            height: 80,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const <Widget>[
                _CityBlock(height: 60, width: 18),
                _CityBlock(height: 72, width: 22),
                _CityBlock(height: 54, width: 16),
                _CityBlock(height: 66, width: 20),
                _CityBlock(height: 48, width: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CityBlock extends StatelessWidget {
  const _CityBlock({required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class FundLabeledValue {
  const FundLabeledValue({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;
}

class FundActiveFundCardData {
  const FundActiveFundCardData({
    required this.title,
    required this.annualYield,
    required this.rows,
    this.progress,
    this.progressColor,
    this.onTap,
  });

  final String title;
  final String annualYield;
  final List<FundLabeledValue> rows;
  final double? progress;
  final Color? progressColor;
  final VoidCallback? onTap;
}

class FundActiveFundsList extends StatefulWidget {
  const FundActiveFundsList({
    super.key,
    required this.title,
    required this.children,
    this.actionLabel,
    this.onActionTap,
    this.showMoreLabel,
    this.showLessLabel,
    this.initialVisibleCount = 3,
    this.itemSpacing = 4,
    this.headerSpacing = UiTokens.spacing8,
  });

  final String title;
  final List<Widget> children;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final String? showMoreLabel;
  final String? showLessLabel;
  final int initialVisibleCount;
  final double itemSpacing;
  final double headerSpacing;

  @override
  State<FundActiveFundsList> createState() => _FundActiveFundsListState();
}

class _FundActiveFundsListState extends State<FundActiveFundsList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return const SizedBox.shrink();
    }

    final shouldShowMoreAction =
        widget.showMoreLabel != null &&
        widget.showLessLabel != null &&
        widget.children.length > widget.initialVisibleCount;
    final visibleItems = _expanded
        ? widget.children
        : widget.children.take(widget.initialVisibleCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FundSectionHeader(
          title: widget.title,
          actionLabel: widget.actionLabel,
          onActionTap: widget.onActionTap,
        ),
        SizedBox(height: widget.headerSpacing),
        for (var index = 0; index < visibleItems.length; index++) ...<Widget>[
          visibleItems[index],
          if (index < visibleItems.length - 1)
            SizedBox(height: widget.itemSpacing),
        ],
        if (shouldShowMoreAction) ...<Widget>[
          const SizedBox(height: UiTokens.spacing8),
          TextButton(
            onPressed: widget.onActionTap,
            child: Text(
              _expanded ? widget.showLessLabel! : widget.showMoreLabel!,
            ),
          ),
        ],
      ],
    );
  }
}

class FundActiveFundCard extends StatelessWidget {
  const FundActiveFundCard({
    super.key,
    required this.data,
    this.shadowPadding = const EdgeInsets.fromLTRB(2, 2, 2, 8),
  });

  final FundActiveFundCardData data;
  final EdgeInsetsGeometry shadowPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hotelTheme = theme.extension<AppFTKTheme>();
    final cardRadius = BorderRadius.circular(UiTokens.radius16);
    final borderColor =
        hotelTheme?.cardBorderColor.withValues(alpha: 0.9) ??
        theme.dividerColor.withValues(alpha: 0.85);
    final shadowColor = hotelTheme?.cardTileShadowColor ?? Colors.black12;

    return Padding(
      padding: shadowPadding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: cardRadius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: shadowColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: cardRadius,
            side: BorderSide(color: borderColor),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: cardRadius,
            onTap: data.onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          data.title,
                          style:
                              (theme.textTheme.titleSmall ?? const TextStyle())
                                  .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: UiTokens.spacing8),
                      Text(
                        data.annualYield,
                        style: (theme.textTheme.titleLarge ?? const TextStyle())
                            .copyWith(
                              color: AppColorTokens.fundexDanger,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: UiTokens.spacing8),
                  for (final row in data.rows) ...<Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            row.label,
                            style:
                                (theme.textTheme.bodySmall ?? const TextStyle())
                                    .copyWith(
                                      color: AppColorTokens.fundexTextSecondary,
                                    ),
                          ),
                        ),
                        const SizedBox(width: UiTokens.spacing8),
                        Text(
                          row.value,
                          style:
                              (theme.textTheme.bodySmall ?? const TextStyle())
                                  .copyWith(
                                    color:
                                        row.valueColor ??
                                        AppColorTokens.fundexText,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                    ),
                    if (row != data.rows.last) const SizedBox(height: 4),
                  ],
                  if (data.progress != null) ...<Widget>[
                    const SizedBox(height: UiTokens.spacing8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        minHeight: 5,
                        value: data.progress!.clamp(0, 1),
                        backgroundColor: AppColorTokens.fundexBorder,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          data.progressColor ?? AppColorTokens.fundexSuccess,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
