import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
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
        _getTextSpan(),
        textAlign: TextAlign.left,
      ),
    );
  }

  TextSpan _getTextSpan() {
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
            _linkText(FinTexts.privacyPolicy),
            _normalText(' ${FinTexts.and} '),
            _linkText(FinTexts.termsOfUse),
            _normalText(FinTexts.privacyAgreementEnd),
          ],
        );
      case DisclaimerType.identityDocument:
        return TextSpan(
          children: [
            _normalText(FinTexts.identityDocumentDisclaimer),
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

  TextSpan _linkText(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(
        fontSize: FinSizes.fontSizeSm,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        decoration: TextDecoration.underline,
      ),
    );
  }
}

enum DisclaimerType {
  privacy,
  identityDocument
}