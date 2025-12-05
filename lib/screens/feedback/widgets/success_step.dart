import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../feedback_controller.dart';

/// Step 4: Success/Thank you screen
/// Shows Finovate logo centered with thank you button at bottom
class SuccessStep extends StatefulWidget {
  final FeedbackController controller;

  const SuccessStep({required this.controller, super.key});

  @override
  State<SuccessStep> createState() => _SuccessStepState();
}

class _SuccessStepState extends State<SuccessStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _goBack() {
    widget.controller.reset();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: FinSizes.sm,
          left: FinSizes.defaultSpace,
          right: FinSizes.defaultSpace,
          bottom: FinSizes.defaultSpace,
        ),
        child: Column(
          children: [
            // Logo centered in the upper area
            Expanded(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    FinImages.tealStripWhite,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Thank you button at bottom
            _buildThankYouButton(),
            const SizedBox(height: FinSizes.spaceBtwSections),
          ],
        ),
      ),
    );
  }

  Widget _buildThankYouButton() {
    return GestureDetector(
      onTap: _goBack,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: 24,
          right: 8,
          top: 12,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: FinColors.borderBlue,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Obrigado pelo feedback!',
              style: TextStyle(
                color: FinColors.textWhite,
                fontSize: FinSizes.fontSizeMd,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            // Close button
            SizedBox(
              width: 28,
              height: 28,
              child: Center(
                child: Icon(
                  Icons.close,
                  color: FinColors.textWhite.withValues(alpha: 0.7),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
