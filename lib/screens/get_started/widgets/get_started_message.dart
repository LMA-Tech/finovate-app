import 'package:flutter/material.dart';

class GetStartedMessage extends StatelessWidget {
  const GetStartedMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.left,
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Crie',
            style: TextStyle(
              color: Colors.white /* Neutral-gray-00 */,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.40,
              letterSpacing: -0.40,
            ),
          ),
          TextSpan(
            text: ' ou ',
            style: TextStyle(
              color: Colors.white /* Neutral-gray-00 */,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              height: 1.40,
              letterSpacing: -0.40,
            ),
          ),
          TextSpan(
            text: 'acesse sua conta',
            style: TextStyle(
              color: Colors.white /* Neutral-gray-00 */,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.40,
              letterSpacing: -0.40,
            ),
          ),
          TextSpan(
            text: ' e dê o primeiro passo para alcançar seus objetivos financeiros.',
            style: TextStyle(
              color: Colors.white /* Neutral-gray-00 */,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              height: 1.40,
              letterSpacing: -0.40,
            ),
          ),
        ],
      ),
    );
  }
}