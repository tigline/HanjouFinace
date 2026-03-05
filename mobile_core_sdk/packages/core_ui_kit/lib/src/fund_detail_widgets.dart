import 'package:flutter/material.dart';

import 'app_color_tokens.dart';
import 'ui_tokens.dart';

class FundDetailBadgeData {
  const FundDetailBadgeData({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
}

class FundDetailInfoItemData {
  const FundDetailInfoItemData({required this.label, required this.value});

  final String label;
  final String value;
}

class FundDetailDisclosureItemData {
  const FundDetailDisclosureItemData({required this.title, required this.body});

  final String title;
  final String body;
}

class FundDetailKeyValueRowData {
  const FundDetailKeyValueRowData({required this.label, required this.value});

  final String label;
  final String value;
}

class FundDetailDocumentItemData {
  const FundDetailDocumentItemData({
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;
}

class FundDetailHeroHeader extends StatefulWidget {
  const FundDetailHeroHeader({
    super.key,
    required this.gradientColors,
    required this.badges,
    this.imageUrls = const <String>[],
    this.onBackTap,
    this.onFavoriteTap,
    this.isFavorite = false,
    this.height = 260,
  });

  final List<Color> gradientColors;
  final List<FundDetailBadgeData> badges;
  final List<String> imageUrls;
  final VoidCallback? onBackTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;
  final double height;

  @override
  State<FundDetailHeroHeader> createState() => _FundDetailHeroHeaderState();
}

class _FundDetailHeroHeaderState extends State<FundDetailHeroHeader> {
  late final PageController _pageController;
  int _currentIndex = 0;

  List<String> get _normalizedImageUrls => widget.imageUrls
      .map((String url) => url.trim())
      .where((String url) => url.isNotEmpty)
      .toList(growable: false);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didUpdateWidget(covariant FundDetailHeroHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    final imageCount = _normalizedImageUrls.length;
    if (imageCount == 0 && _currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return;
    }
    if (imageCount > 0 && _currentIndex >= imageCount) {
      setState(() {
        _currentIndex = 0;
      });
      _pageController.jumpToPage(0);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildBackground(List<String> images) {
    if (images.isEmpty) {
      return _FundDetailHeroFallbackBackground(
        gradientColors: widget.gradientColors,
      );
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: images.length,
      onPageChanged: (int index) {
        if (_currentIndex == index) {
          return;
        }
        setState(() {
          _currentIndex = index;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _FundDetailHeroFallbackBackground(
              gradientColors: widget.gradientColors,
            ),
            Image.network(
              images[index],
              fit: BoxFit.cover,
              loadingBuilder:
                  (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress,
                  ) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const SizedBox.shrink();
                  },
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPageIndicator(BuildContext context, int imageCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(imageCount, (int index) {
          final selected = index == _currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: EdgeInsets.only(right: index == imageCount - 1 ? 0 : 5),
            width: selected ? 16 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: selected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(999),
            ),
          );
        }, growable: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top + 12;
    final images = _normalizedImageUrls;
    final hasIndicator = images.length > 1;

    return SizedBox(
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildBackground(images),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withValues(alpha: 0.12),
                  Colors.black.withValues(alpha: 0.42),
                ],
              ),
            ),
          ),
          Positioned(
            top: topInset,
            left: 12,
            child: _DetailGlassIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: widget.onBackTap,
            ),
          ),
          Positioned(
            top: topInset,
            right: 12,
            child: _DetailGlassIconButton(
              icon: widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              onTap: widget.onFavoriteTap,
            ),
          ),
          if (widget.badges.isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.badges
                    .map(
                      (FundDetailBadgeData badge) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: badge.backgroundColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge.label,
                          style:
                              (Theme.of(context).textTheme.labelSmall ??
                                      const TextStyle())
                                  .copyWith(
                                    color: badge.foregroundColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          if (hasIndicator)
            Positioned(
              left: 0,
              right: 0,
              bottom: widget.badges.isEmpty ? 14 : 48,
              child: Center(child: _buildPageIndicator(context, images.length)),
            ),
        ],
      ),
    );
  }
}

class FundDetailSection extends StatelessWidget {
  const FundDetailSection({
    super.key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: UiTokens.spacing16),
  });

  final String title;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: (Theme.of(context).textTheme.titleSmall ?? const TextStyle())
                .copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: UiTokens.spacing8),
          child,
        ],
      ),
    );
  }
}

class FundDetailContentCard extends StatelessWidget {
  const FundDetailContentCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.backgroundColor = AppColorTokens.fundexBackground,
    this.borderColor = const Color(0xFFE8EEF5),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(UiTokens.radius16),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

class FundDetailMediaPreview extends StatelessWidget {
  const FundDetailMediaPreview({
    super.key,
    this.imageUrl,
    this.height = 164,
    this.overlayLabel,
    this.placeholder,
  });

  final String? imageUrl;
  final double height;
  final String? overlayLabel;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UiTokens.radius16),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFFEAF1FF), Color(0xFFD9E7FF)],
                ),
              ),
            ),
            if (imageUrl != null && imageUrl!.trim().isNotEmpty)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    placeholder ?? const _DefaultMediaPlaceholder(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return placeholder ?? const _DefaultMediaPlaceholder();
                },
              )
            else
              placeholder ?? const _DefaultMediaPlaceholder(),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.16),
                  ],
                ),
              ),
            ),
            if (overlayLabel != null && overlayLabel!.trim().isNotEmpty)
              Positioned(
                left: 12,
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    overlayLabel!,
                    style:
                        (Theme.of(context).textTheme.labelSmall ??
                                const TextStyle())
                            .copyWith(
                              color: AppColorTokens.fundexText,
                              fontWeight: FontWeight.w700,
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

class FundDetailInfoGrid extends StatelessWidget {
  const FundDetailInfoGrid({super.key, required this.items, this.spacing = 10});

  final List<FundDetailInfoItemData> items;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final itemWidth = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items
              .map(
                (FundDetailInfoItemData item) => SizedBox(
                  width: itemWidth,
                  child: FundDetailContentCard(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.label,
                          style:
                              (Theme.of(context).textTheme.labelSmall ??
                                      const TextStyle())
                                  .copyWith(
                                    color: AppColorTokens.fundexTextSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.value,
                          style:
                              (Theme.of(context).textTheme.bodyMedium ??
                                      const TextStyle())
                                  .copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class FundDetailInfoTable extends StatelessWidget {
  const FundDetailInfoTable({
    super.key,
    required this.items,
    this.borderColor = AppColorTokens.fundexBorder,
    this.columns = 2,
    this.minRowHeight = 0,
  });

  final List<FundDetailInfoItemData> items;
  final Color borderColor;
  final int columns;
  final double minRowHeight;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final safeColumns = columns < 1 ? 1 : columns;
    final placeholdersNeeded =
        (safeColumns - (items.length % safeColumns)) % safeColumns;
    final normalizedItems = <FundDetailInfoItemData?>[
      ...items,
      ...List<FundDetailInfoItemData?>.filled(placeholdersNeeded, null),
    ];
    final rowCount = normalizedItems.length ~/ safeColumns;

    final radius = BorderRadius.circular(UiTokens.radius16);
    return DecoratedBox(
      decoration: BoxDecoration(color: borderColor, borderRadius: radius),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(UiTokens.radius16 - 1),
          child: ColoredBox(
            color: Colors.white,
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: borderColor),
                verticalInside: BorderSide(color: borderColor),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: List<TableRow>.generate(rowCount, (int rowIndex) {
                return TableRow(
                  children: List<Widget>.generate(safeColumns, (int colIndex) {
                    final item =
                        normalizedItems[rowIndex * safeColumns + colIndex];
                    return _FundDetailTableCell(
                      item: item,
                      minHeight: minRowHeight < 0 ? 0 : minRowHeight,
                    );
                  }, growable: false),
                );
              }, growable: false),
            ),
          ),
        ),
      ),
    );
  }
}

class _FundDetailTableCell extends StatelessWidget {
  const _FundDetailTableCell({required this.item, required this.minHeight});

  final FundDetailInfoItemData? item;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return SizedBox(height: minHeight <= 0 ? 0 : minHeight);
    }

    final textTheme = Theme.of(context).textTheme;
    final labelStyle = (textTheme.labelSmall ?? const TextStyle()).copyWith(
      fontSize: 10,
      color: AppColorTokens.fundexTextTertiary,
      fontWeight: FontWeight.w500,
      height: 1.2,
    );
    final valueStyle = (textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontSize: 13,
      color: AppColorTokens.fundexText,
      fontWeight: FontWeight.w700,
      height: 1.35,
    );

    final child = Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(item!.label, style: labelStyle),
          const SizedBox(height: 2),
          Text(item!.value, style: valueStyle),
        ],
      ),
    );

    if (minHeight <= 0) {
      return child;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: child,
    );
  }
}

class FundDetailDisclosureList extends StatelessWidget {
  const FundDetailDisclosureList({super.key, required this.items});

  final List<FundDetailDisclosureItemData> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: <Widget>[
        for (var index = 0; index < items.length; index++) ...<Widget>[
          _DisclosureTile(item: items[index]),
          if (index < items.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class FundDetailTextCard extends StatelessWidget {
  const FundDetailTextCard({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return FundDetailContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: (Theme.of(context).textTheme.labelLarge ?? const TextStyle())
                .copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle())
                .copyWith(
                  color: AppColorTokens.fundexTextSecondary,
                  height: 1.7,
                ),
          ),
        ],
      ),
    );
  }
}

class FundDetailKeyValueCard extends StatelessWidget {
  const FundDetailKeyValueCard({
    super.key,
    required this.title,
    required this.rows,
  });

  final String title;
  final List<FundDetailKeyValueRowData> rows;

  @override
  Widget build(BuildContext context) {
    return FundDetailContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: (Theme.of(context).textTheme.labelLarge ?? const TextStyle())
                .copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          for (var index = 0; index < rows.length; index++) ...<Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    rows[index].label,
                    style:
                        (Theme.of(context).textTheme.bodySmall ??
                                const TextStyle())
                            .copyWith(
                              color: AppColorTokens.fundexTextSecondary,
                            ),
                  ),
                ),
                const SizedBox(width: UiTokens.spacing8),
                Text(
                  rows[index].value,
                  style:
                      (Theme.of(context).textTheme.bodySmall ??
                              const TextStyle())
                          .copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            if (index < rows.length - 1) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class FundDetailDocumentList extends StatelessWidget {
  const FundDetailDocumentList({super.key, required this.items});

  final List<FundDetailDocumentItemData> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: <Widget>[
        for (var index = 0; index < items.length; index++) ...<Widget>[
          FundDetailContentCard(
            padding: EdgeInsets.zero,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: items[index].onTap,
                borderRadius: BorderRadius.circular(UiTokens.radius16),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColorTokens.fundexAccent.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: AppColorTokens.fundexAccent,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: UiTokens.spacing12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              items[index].title,
                              style:
                                  (Theme.of(context).textTheme.bodyMedium ??
                                          const TextStyle())
                                      .copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              items[index].subtitle,
                              style:
                                  (Theme.of(context).textTheme.labelSmall ??
                                          const TextStyle())
                                      .copyWith(
                                        color:
                                            AppColorTokens.fundexTextSecondary,
                                      ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: UiTokens.spacing8),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColorTokens.fundexTextTertiary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (index < items.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class FundDetailStickyActionBar extends StatelessWidget {
  const FundDetailStickyActionBar({
    super.key,
    required this.label,
    this.onTap,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: enabled ? onTap : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColorTokens.fundexAccent,
              disabledBackgroundColor: AppColorTokens.fundexTextSecondary
                  .withValues(alpha: 0.35),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              label,
              style:
                  (Theme.of(context).textTheme.labelLarge ?? const TextStyle())
                      .copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DefaultMediaPlaceholder extends StatelessWidget {
  const _DefaultMediaPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                AppColorTokens.fundexPrimaryDark.withValues(alpha: 0.92),
                AppColorTokens.fundexAccent.withValues(alpha: 0.82),
              ],
            ),
          ),
        ),
        const _FundDetailArtworkLayer(),
      ],
    );
  }
}

class _FundDetailHeroFallbackBackground extends StatelessWidget {
  const _FundDetailHeroFallbackBackground({required this.gradientColors});

  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
          ),
        ),
        const _FundDetailArtworkLayer(),
      ],
    );
  }
}

class _DetailGlassIconButton extends StatelessWidget {
  const _DetailGlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.24),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

class _DisclosureTile extends StatelessWidget {
  const _DisclosureTile({required this.item});

  final FundDetailDisclosureItemData item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(UiTokens.radius16),
      child: Material(
        color: AppColorTokens.fundexSurface,
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: AppColorTokens.fundexAccent.withValues(alpha: 0.08),
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 2,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiTokens.radius16),
              side: const BorderSide(color: AppColorTokens.fundexBorder),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UiTokens.radius16),
              side: const BorderSide(color: AppColorTokens.fundexBorder),
            ),
            title: Text(
              item.title,
              style:
                  (Theme.of(context).textTheme.bodyMedium ?? const TextStyle())
                      .copyWith(fontWeight: FontWeight.w700),
            ),
            children: <Widget>[
              Text(
                item.body,
                style:
                    (Theme.of(context).textTheme.bodySmall ?? const TextStyle())
                        .copyWith(
                          color: AppColorTokens.fundexTextSecondary,
                          height: 1.7,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FundDetailArtworkLayer extends StatelessWidget {
  const _FundDetailArtworkLayer();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 26),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              _HeroBlock(height: 112, width: 30),
              _HeroBlock(height: 142, width: 38),
              _HeroBlock(height: 96, width: 28),
              _HeroBlock(height: 126, width: 34),
              _HeroBlock(height: 84, width: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroBlock extends StatelessWidget {
  const _HeroBlock({required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        children: List<Widget>.generate(
          6,
          (int index) => Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: width * 0.28,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          growable: false,
        ),
      ),
    );
  }
}
