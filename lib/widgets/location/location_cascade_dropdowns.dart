import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/models/location_models.dart';
import 'package:barristerkayserkamal/services/providers/api_providers.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';

class LocationCascadeDropdowns extends ConsumerWidget {
  final DivisionModel? selectedDivision;
  final DistrictModel? selectedDistrict;
  final UpazilaModel? selectedUpazila;
  final UnionModel? selectedUnion;
  final ValueChanged<DivisionModel?> onDivisionChanged;
  final ValueChanged<DistrictModel?> onDistrictChanged;
  final ValueChanged<UpazilaModel?> onUpazilaChanged;
  final ValueChanged<UnionModel?> onUnionChanged;
  final bool isBangla;
  final AppTranslations tr;

  const LocationCascadeDropdowns({
    super.key,
    required this.selectedDivision,
    required this.selectedDistrict,
    required this.selectedUpazila,
    required this.selectedUnion,
    required this.onDivisionChanged,
    required this.onDistrictChanged,
    required this.onUpazilaChanged,
    required this.onUnionChanged,
    required this.isBangla,
    required this.tr,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final divisionsAsync = ref.watch(divisionsProvider);
    final districtsAsync = selectedDivision?.id != null
        ? ref.watch(districtsProvider(selectedDivision!.id))
        : null;
    final upazilasAsync = selectedDistrict?.id != null
        ? ref.watch(upazilasProvider(selectedDistrict!.id))
        : null;
    final unionsAsync = selectedUpazila?.id != null
        ? ref.watch(unionsProvider(selectedUpazila!.id))
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Division Dropdown
        divisionsAsync.when(
          data: (divisions) => _buildDropdown<DivisionModel>(
            label: tr.divisionLabel,
            hint: tr.divisionHint,
            items: divisions,
            value: selectedDivision,
            itemLabel: (item) => item.localizedName(isBangla),
            onChanged: onDivisionChanged,
          ),
          loading: () => _buildDropdownLoading(tr.divisionLabel),
          error: (err, stack) => _buildDropdownError(tr.divisionLabel, tr.loadDivisionsError),
        ),
        const SizedBox(height: 16),

        // District Dropdown
        if (districtsAsync != null)
          districtsAsync.when(
            data: (districts) => _buildDropdown<DistrictModel>(
              label: tr.districtLabel,
              hint: tr.districtHint,
              items: districts,
              value: selectedDistrict,
              itemLabel: (item) => item.localizedName(isBangla),
              onChanged: onDistrictChanged,
            ),
            loading: () => _buildDropdownLoading(tr.districtLabel),
            error: (err, stack) => _buildDropdownError(tr.districtLabel, tr.loadDistrictsError),
          )
        else
          _buildDisabledDropdown(tr.districtLabel, tr.selectDivisionFirst),
        const SizedBox(height: 16),

        // Upazila Dropdown
        if (upazilasAsync != null)
          upazilasAsync.when(
            data: (upazilas) => _buildDropdown<UpazilaModel>(
              label: tr.upazilaLabel,
              hint: tr.upazilaHint,
              items: upazilas,
              value: selectedUpazila,
              itemLabel: (item) => item.localizedName(isBangla),
              onChanged: onUpazilaChanged,
            ),
            loading: () => _buildDropdownLoading(tr.upazilaLabel),
            error: (err, stack) => _buildDropdownError(tr.upazilaLabel, tr.loadUpazilasError),
          )
        else
          _buildDisabledDropdown(tr.upazilaLabel, tr.selectDistrictFirst),
        const SizedBox(height: 16),

        // Union Dropdown
        if (unionsAsync != null)
          unionsAsync.when(
            data: (unions) => _buildDropdown<UnionModel>(
              label: tr.unionLabel,
              hint: tr.unionHint,
              items: unions,
              value: selectedUnion,
              itemLabel: (item) => item.localizedName(isBangla),
              onChanged: onUnionChanged,
            ),
            loading: () => _buildDropdownLoading(tr.unionLabel),
            error: (err, stack) => _buildDropdownError(tr.unionLabel, tr.loadUnionsError),
          )
        else
          _buildDisabledDropdown(tr.unionLabel, tr.selectUpazilaFirst),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required String hint,
    required List<T> items,
    required T? value,
    required String Function(T) itemLabel,
    required void Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField2<T>(
          isExpanded: true,
          value: items.contains(value) ? value : null,
          hint: Text(hint, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600])),
          decoration: InputDecoration(
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
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            maxHeight: 280,
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabel(item), style: const TextStyle(fontSize: 14, color: Colors.black87)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdownLoading(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: const Row(
            children: [
              SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
              SizedBox(width: 12),
              Text("Loading options...", style: TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDisabledDropdown(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(placeholder, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildDropdownError(String label, String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Text(message, style: const TextStyle(color: Colors.red, fontSize: 13)),
        ),
      ],
    );
  }
}
