import 'package:flutter/material.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/models/location_models.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';
import 'package:atmabdulbaridanny/widgets/location/location_cascade_dropdowns.dart';

class ComplainFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController emailController;
  final TextEditingController subjectController;
  final TextEditingController wardController;
  final TextEditingController villageController;
  final TextEditingController messageController;
  final String selectedType;
  final ValueChanged<String> onTypeChanged;
  final DivisionModel? selectedDivision;
  final DistrictModel? selectedDistrict;
  final UpazilaModel? selectedUpazila;
  final UnionModel? selectedUnion;
  final ValueChanged<DivisionModel?> onDivisionChanged;
  final ValueChanged<DistrictModel?> onDistrictChanged;
  final ValueChanged<UpazilaModel?> onUpazilaChanged;
  final ValueChanged<UnionModel?> onUnionChanged;
  final bool isSubmitting;
  final VoidCallback onDiscard;
  final VoidCallback onSubmit;
  final Color primaryGreen;
  final bool isBangla;
  final AppTranslations tr;

  const ComplainFormCard({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.mobileController,
    required this.emailController,
    required this.subjectController,
    required this.wardController,
    required this.villageController,
    required this.messageController,
    required this.selectedType,
    required this.onTypeChanged,
    required this.selectedDivision,
    required this.selectedDistrict,
    required this.selectedUpazila,
    required this.selectedUnion,
    required this.onDivisionChanged,
    required this.onDistrictChanged,
    required this.onUpazilaChanged,
    required this.onUnionChanged,
    required this.isSubmitting,
    required this.onDiscard,
    required this.onSubmit,
    required this.primaryGreen,
    required this.isBangla,
    required this.tr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryGreen, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.personalInfoSection,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // Name
            _buildTextField(
              label: tr.fullNameLabel,
              hint: tr.fullNameHint,
              controller: nameController,
              validator: (val) => val == null || val.trim().isEmpty ? tr.fullNameRequired : null,
            ),
            const SizedBox(height: 16),

            // Mobile
            _buildTextField(
              label: tr.mobileLabel,
              hint: tr.mobileHint,
              controller: mobileController,
              keyboardType: TextInputType.phone,
              validator: (val) => val == null || val.trim().isEmpty ? tr.mobileRequired : null,
            ),
            const SizedBox(height: 16),

            // Email
            _buildTextField(
              label: tr.emailOptionalLabel,
              hint: "e.g. user@example.com",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Type (local vs nrb)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.citizenTypeLabel,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                RadioGroup<String>(
                  groupValue: selectedType,
                  onChanged: (val) {
                    if (val != null) onTypeChanged(val);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text(tr.citizenLocal, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                          value: 'local',
                          contentPadding: EdgeInsets.zero,
                          activeColor: primaryGreen,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text(tr.citizenForeignNrb, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                          value: 'nrb',
                          contentPadding: EdgeInsets.zero,
                          activeColor: primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text(
              tr.addressDetailsSection,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // Location Cascading Dropdowns
            LocationCascadeDropdowns(
              selectedDivision: selectedDivision,
              selectedDistrict: selectedDistrict,
              selectedUpazila: selectedUpazila,
              selectedUnion: selectedUnion,
              onDivisionChanged: onDivisionChanged,
              onDistrictChanged: onDistrictChanged,
              onUpazilaChanged: onUpazilaChanged,
              onUnionChanged: onUnionChanged,
              isBangla: isBangla,
              tr: tr,
            ),
            const SizedBox(height: 16),

            // Ward & Village
            _buildTextField(
              label: tr.wardLabel,
              hint: tr.wardHint,
              controller: wardController,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: tr.villageLabel,
              hint: tr.villageHint,
              controller: villageController,
            ),
            const SizedBox(height: 24),

            Text(
              tr.complaintDetailsSection,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // Subject
            _buildTextField(
              label: tr.complaintSubjectLabel,
              hint: tr.complaintSubjectHint,
              controller: subjectController,
            ),
            const SizedBox(height: 16),

            // Message
            _buildTextField(
              label: tr.complaintMessageLabel,
              hint: tr.complaintMessageHint,
              controller: messageController,
              maxLines: 5,
              validator: (val) => val == null || val.trim().isEmpty ? tr.complaintMessageRequired : null,
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: isSubmitting ? null : onDiscard,
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: Text(
                        tr.discardBtn,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        elevation: 1,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: isSubmitting ? null : onSubmit,
                      icon: isSubmitting ? null : const Icon(Icons.send_rounded, size: 18),
                      label: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                tr.submitComplaintBtn,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C4B33),
                        foregroundColor: Colors.white,
                        elevation: 1.5,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 8),
        TextFormField(
          style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.instance.primaryGreen, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
