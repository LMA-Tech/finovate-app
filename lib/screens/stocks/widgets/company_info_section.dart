import 'package:flutter/material.dart';

import '../../../models/stock.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/formatters.dart';

/// Company info section showing industry tag and expandable description.
class CompanyInfoSection extends StatefulWidget {
  final StockDetail stock;

  const CompanyInfoSection({
    required this.stock,
    super.key,
  });

  @override
  State<CompanyInfoSection> createState() => _CompanyInfoSectionState();
}

class _CompanyInfoSectionState extends State<CompanyInfoSection> {
  bool _isExpanded = false;
  static const int _maxLinesCollapsed = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              FinTexts.stockDetailAboutCompany,
              style: TextStyle(
                fontSize: FinSizes.fontSizeMd,
                fontWeight: FontWeight.w500,
                color: FinColors.textWhite,
              ),
            ),
            if (widget.stock.industry != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FinSizes.sm,
                  vertical: FinSizes.xs,
                ),
                decoration: ShapeDecoration(
                  color: FinColors.buttonLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(FinSizes.borderRadiusSm),
                  ),
                ),
                child: Text(
                  widget.stock.industry!,
                  style: const TextStyle(
                    fontSize: FinSizes.fontSizeS,
                    fontWeight: FontWeight.w500,
                    color: FinColors.textDark,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: FinSizes.md),
        if (widget.stock.company?.description != null)
          _buildExpandableDescription(widget.stock.company!.description!),
        if (_hasCompanyDetails()) ...[
          const SizedBox(height: FinSizes.md),
          _buildCompanyDetailsGrid(),
        ],
      ],
    );
  }

  bool _hasCompanyDetails() {
    final company = widget.stock.company;
    return company?.employees != null ||
        company?.headquarters != null ||
        company?.website != null ||
        company?.phone != null;
  }

  Widget _buildCompanyDetailsGrid() {
    final company = widget.stock.company;
    final details = <MapEntry<String, String>>[];

    if (company?.employees != null) {
      details.add(MapEntry('Funcionários', FinFormatters.formatNumber(company!.employees!.toDouble())));
    }
    if (company?.headquarters != null) {
      details.add(MapEntry('Sede', company!.headquarters!));
    }
    if (company?.website != null) {
      details.add(MapEntry('Website', company!.website!));
    }
    if (company?.phone != null) {
      details.add(MapEntry('Telefone', company!.phone!));
    }

    if (details.isEmpty) return const SizedBox.shrink();

    final rows = <Widget>[];
    for (var i = 0; i < details.length; i += 2) {
      final leftItem = details[i];
      final rightItem = i + 1 < details.length ? details[i + 1] : null;

      rows.add(
        Padding(
          padding: EdgeInsets.only(top: i > 0 ? FinSizes.md : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildDetailColumn(leftItem.key, leftItem.value)),
              if (rightItem != null)
                Expanded(child: _buildDetailColumn(rightItem.key, rightItem.value))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildDetailColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: FinSizes.fontSizeSm,
            fontWeight: FontWeight.w400,
            color: FinColors.textGray300,
          ),
        ),
        const SizedBox(height: FinSizes.xs / 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: FinSizes.fontSizeSm,
            fontWeight: FontWeight.w500,
            color: FinColors.textWhite,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableDescription(String description) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: description,
          style: const TextStyle(
            fontSize: FinSizes.fontSizeSm,
            fontWeight: FontWeight.w400,
            color: FinColors.textGray200,
            height: 1.5,
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: _maxLinesCollapsed,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Text(
                description,
                maxLines: _maxLinesCollapsed,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: FinSizes.fontSizeSm,
                  fontWeight: FontWeight.w400,
                  color: FinColors.textGray200,
                  height: 1.5,
                ),
              ),
              secondChild: Text(
                description,
                style: const TextStyle(
                  fontSize: FinSizes.fontSizeSm,
                  fontWeight: FontWeight.w400,
                  color: FinColors.textGray200,
                  height: 1.5,
                ),
              ),
            ),
            if (isOverflowing)
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: FinSizes.sm),
                  child: Text(
                    _isExpanded
                        ? FinTexts.stockDetailSeeLess
                        : FinTexts.stockDetailSeeMore,
                    style: const TextStyle(
                      fontSize: FinSizes.fontSizeSm,
                      fontWeight: FontWeight.w500,
                      color: FinColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: FinColors.primary,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
