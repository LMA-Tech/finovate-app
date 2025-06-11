import 'package:finovate_app/screens/signup/widgets/policy_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

class DisclaimerWidget extends StatelessWidget {
  final DisclaimerType type;
  final EdgeInsetsGeometry? padding;

  const DisclaimerWidget({
    super.key,
    required this.type,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: FinSizes.md),
      child: Text.rich(
        _getTextSpan(context),
        textAlign: TextAlign.left,
      ),
    );
  }

  TextSpan _getTextSpan(BuildContext context) {
    switch (type) {
      case DisclaimerType.privacy:
        return TextSpan(
          style: const TextStyle(
            color: Color(0xFFDFDFE0) /* Neutral-gray-200 */,
            fontSize: FinSizes.fontSizeSm,
            fontWeight: FontWeight.w400,
            height: 1.29,
          ),
          children: [
            _normalText(FinTexts.privacyAgreement),
            _clickableLinkText(
              FinTexts.privacyPolicy,
              onTap: () => PolicyBottomSheet.showPrivacyPolicy(context),
            ),
            _normalText(' ${FinTexts.and} '),
            _clickableLinkText(
              FinTexts.termsOfUse,
              onTap: () => PolicyBottomSheet.showTermsOfService(context),
            ),
            _normalText(FinTexts.privacyAgreementEnd),
          ],
        );
      case DisclaimerType.identityDocument:
        return TextSpan(
          children: [
            _normalText(FinTexts.identityDocumentDisclaimer),
          ],
        );
      case DisclaimerType.dataCollection:  // ADD THIS CASE
        return TextSpan(
          children: [
            _normalText("Coletamos informações para garantir sua segurança e cumprir obrigações legais de proteção de dados."),
          ],
        );
      case DisclaimerType.verification:  // ADD THIS CASE
        return TextSpan(
          children: [
            _normalText("Enviaremos um código de 6 dígitos para verificar sua conta."),
          ],
        );
    }
  }

  TextSpan _normalText(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontSize: FinSizes.fontSizeSm,
        fontWeight: FontWeight.w400,
        color: Colors.white.withOpacity(0.8),
      ),
    );
  }

  TextSpan _clickableLinkText(String text, {required VoidCallback onTap}) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        fontSize: FinSizes.fontSizeSm,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()..onTap = onTap,
    );
  }
}

enum DisclaimerType { privacy, identityDocument, dataCollection, verification }
