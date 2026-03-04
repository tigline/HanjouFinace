import 'package:core_ui_kit/core_ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../../app/localization/app_localizations_ext.dart';

class MemberProfileBankAccountStepPage extends StatelessWidget {
  const MemberProfileBankAccountStepPage({
    super.key,
    required this.bankNameController,
    required this.branchNameController,
    required this.accountType,
    required this.accountTypeItems,
    required this.accountNumberController,
    required this.accountHolderController,
    this.onAccountTypeChanged,
    this.onNext,
  });

  final TextEditingController bankNameController;
  final TextEditingController branchNameController;
  final String? accountType;
  final List<DropdownMenuItem<String>> accountTypeItems;
  final TextEditingController accountNumberController;
  final TextEditingController accountHolderController;
  final ValueChanged<String?>? onAccountTypeChanged;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return MemberProfileEditStepScaffold(
      title: l10n.memberProfileStep5Title,
      description: l10n.memberProfileStep5Description,
      primaryButtonLabel: l10n.memberProfileNextConsent,
      onPrimaryPressed: onNext,
      child: Column(
        children: <Widget>[
          MemberProfileTextField(
            label: l10n.memberProfileBankNameLabel,
            controller: bankNameController,
            hintText: l10n.memberProfileBankNameHint,
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: MemberProfileTextField(
                  label: l10n.memberProfileBranchLabel,
                  controller: branchNameController,
                  hintText: l10n.memberProfileBranchHint,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MemberProfileSelectField<String>(
                  label: l10n.memberProfileAccountTypeLabel,
                  value: accountType,
                  items: accountTypeItems,
                  onChanged: onAccountTypeChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          MemberProfileTextField(
            label: l10n.memberProfileAccountNumberLabel,
            controller: accountNumberController,
            hintText: l10n.memberProfileAccountNumberHint,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
          MemberProfileTextField(
            label: l10n.memberProfileAccountHolderLabel,
            controller: accountHolderController,
            hintText: l10n.memberProfileAccountHolderHint,
          ),
        ],
      ),
    );
  }
}
