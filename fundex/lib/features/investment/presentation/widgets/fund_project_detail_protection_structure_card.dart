import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

class FundProjectDetailProtectionStructureData {
  const FundProjectDetailProtectionStructureData({
    required this.primaryLabel,
    required this.primaryRatio,
    required this.secondaryLabel,
    required this.secondaryRatio,
  });

  final String primaryLabel;
  final double primaryRatio;
  final String secondaryLabel;
  final double secondaryRatio;
}

class FundProjectDetailProtectionStructureCard extends StatelessWidget {
  const FundProjectDetailProtectionStructureCard({
    super.key,
    required this.data,
  });

  final FundProjectDetailProtectionStructureData data;

  @override
  Widget build(BuildContext context) {
    return FundDetailContentCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 24,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: (data.primaryRatio * 1000).round().clamp(1, 999),
                    child: Container(
                      color: AppColorTokens.fundexAccent,
                      alignment: Alignment.center,
                      child: Text(
                        '${data.primaryLabel} ${(data.primaryRatio * 100).round()}%',
                        style:
                            (Theme.of(context).textTheme.labelSmall ??
                                    const TextStyle())
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: (data.secondaryRatio * 1000).round().clamp(1, 999),
                    child: Container(
                      color: AppColorTokens.fundexWarning,
                      alignment: Alignment.center,
                      child: Text(
                        '${data.secondaryLabel} ${(data.secondaryRatio * 100).round()}%',
                        style:
                            (Theme.of(context).textTheme.labelSmall ??
                                    const TextStyle())
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  data.primaryLabel,
                  style:
                      (Theme.of(context).textTheme.labelSmall ??
                              const TextStyle())
                          .copyWith(color: AppColorTokens.fundexTextSecondary),
                ),
              ),
              Text(
                data.secondaryLabel,
                style:
                    (Theme.of(context).textTheme.labelSmall ??
                            const TextStyle())
                        .copyWith(color: AppColorTokens.fundexTextSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
