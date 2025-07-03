import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.imageWidth,
    required this.imageHeight,
  });

  final String imagePath, title, subTitle;
  final double imageWidth, imageHeight;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Image.asset(
            imagePath,
            width: imageWidth,
            height: imageHeight,
            fit: BoxFit.contain,
          ),

          SizedBox(height: screenHeight * 0.05), // Responsive spacing

          // Title with responsive sizing
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate max height for title (15% of screen)
              final maxTitleHeight = screenHeight * 0.15;

              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxTitleHeight,
                  maxWidth: constraints.maxWidth,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth < 360 ? 26 : 30, // Responsive base size
                        fontWeight: FontWeight.w500,
                        height: 1.33,
                        letterSpacing: -0.60,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      softWrap: true,
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: screenHeight * 0.03), // Responsive spacing

          // Subtitle with responsive sizing
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate max height for subtitle (20% of screen)
              final maxSubtitleHeight = screenHeight * 0.2;

              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxSubtitleHeight,
                  maxWidth: constraints.maxWidth,
                ),
                child: Text(
                  subTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth < 360 ? 14 : 16, // Responsive base size
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: -0.32,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 8, // Allow more lines
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              );
            },
          ),

          // Bottom spacer to prevent overlap with navigation
          SizedBox(height: screenHeight * 0.12), // Reserve space for buttons
        ],
      ),
    );
  }
}