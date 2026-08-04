import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../support/mypage_section_support.dart';
import 'my_page_apply_investor_type_panel.dart';

class MyPageApplyCardDetail extends StatelessWidget {
  const MyPageApplyCardDetail({
    super.key,
    required this.investorTypeLabel,
    required this.investorCode,
    required this.returnText,
    required this.resultDetails,
  });

  final String investorTypeLabel;
  final String investorCode;
  final String returnText;
  final MyPageApplyResultDetailsData resultDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final appText = theme.appTextTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        MyPageApplyInvestorTypePanel(
          label: investorTypeLabel,
          investorCode: investorCode,
          returnText: returnText,
        ),
        if (resultDetails.isNotEmpty) ...<Widget>[
          const SizedBox(height: 12),
          Divider(height: 1, color: colors.borderSoft),
          const SizedBox(height: 12),
          for (var index = 0; index < resultDetails.lines.length; index++) ...[
            Text(
              resultDetails.lines[index],
              style: appText.bodyStrong.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
            if (index != resultDetails.lines.length - 1)
              const SizedBox(height: 4),
          ],
        ],
      ],
    );
  }
}
