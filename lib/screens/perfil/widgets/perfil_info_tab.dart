import 'package:flutter/material.dart';

import '../../../common/widgets/security_notice.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/data_masking.dart';

/// Conta (Account/Personal Info) tab content.
///
/// Displays user's personal information with masked values.
/// Uses the same row styling as MeuPlanoTab for consistency.
class PerfilInfoTab extends StatelessWidget {
  final String fullName;
  final String? nickname;
  final String email;
  final String phone;
  final String cpf;
  final DateTime? birthDate;
  final Function(String field)? onEditField;
  final VoidCallback? onLogoutTap;

  const PerfilInfoTab({
    required this.fullName,
    this.nickname,
    required this.email,
    required this.phone,
    required this.cpf,
    this.birthDate,
    this.onEditField,
    this.onLogoutTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: FinSizes.lg), // 20px from tabs

          // Nome
          _buildEditableRow(
            label: FinTexts.perfilNomeCompleto,
            value: fullName.isNotEmpty ? fullName : '-',
            onEditTap: () => onEditField?.call('fullName'),
          ),
          _buildDivider(),

          // Apelido
          _buildEditableRow(
            label: FinTexts.perfilApelido,
            value: nickname ?? firstName,
            onEditTap: () => onEditField?.call('nickname'),
          ),
          _buildDivider(),

          // E-mail (masked)
          _buildEditableRow(
            label: FinTexts.perfilEmail,
            value: email.isNotEmpty ? maskEmail(email) : '-',
            onEditTap: () => onEditField?.call('email'),
          ),
          _buildDivider(),

          // Número do seu celular (masked)
          _buildEditableRow(
            label: FinTexts.perfilTelefone,
            value: phone.isNotEmpty ? maskPhone(phone) : '-',
            onEditTap: () => onEditField?.call('phone'),
          ),
          _buildDivider(),

          // Seu CPF (masked, not editable)
          _buildEditableRow(
            label: FinTexts.perfilCpf,
            value: cpf.isNotEmpty ? maskCPF(cpf) : '-',
          ),
          _buildDivider(),

          // Sua data de nascimento (not editable)
          _buildEditableRow(
            label: FinTexts.perfilDataNascimento,
            value: birthDate != null ? _formatDate(birthDate!) : '-',
          ),

          const SizedBox(height: FinSizes.spaceBtwSections),

          // Security notice
          const SecurityNotice(
            message: FinTexts.perfilSecurityNotice,
          ),

          // Logout button
          if (onLogoutTap != null) ...[
            const SizedBox(height: FinSizes.spaceBtwSections),
            Center(
              child: GestureDetector(
                onTap: onLogoutTap,
                child: Text(
                  FinTexts.perfilSairConta,
                  style: TextStyle(
                    fontSize: FinSizes.fontSizeSm,
                    fontWeight: FontWeight.w400,
                    color: FinColors.textWhite.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: FinSizes.lg),
          ],
        ],
      ),
    );
  }

  Widget _buildEditableRow({
    required String label,
    required String value,
    VoidCallback? onEditTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FinSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: const TextStyle(
              fontSize: FinSizes.fontSizeS,
              fontWeight: FontWeight.w400,
              color: FinColors.textGray300,
              height: 1.50,
            ),
          ),
          const SizedBox(height: FinSizes.xs),
          // Value with edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: FinSizes.fontSizeMd,
                    fontWeight: FontWeight.w400,
                    color: FinColors.textWhite,
                  ),
                ),
              ),
              if (onEditTap != null)
                GestureDetector(
                  onTap: onEditTap,
                  child: const Text(
                    FinTexts.perfilEditar,
                    style: TextStyle(
                      fontSize: FinSizes.fontSizeSm,
                      fontWeight: FontWeight.w500,
                      color: FinColors.borderMint,
                      height: 1.50,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: FinSizes.borderWidthSm,
      thickness: FinSizes.borderWidthSm,
      color: FinColors.textWhite.withValues(alpha: 0.1),
    );
  }

  /// Format date as DD/MM/YYYY
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Get first name from full name
  String get firstName {
    if (fullName.isEmpty) return '';
    return fullName.split(' ').first;
  }
}
