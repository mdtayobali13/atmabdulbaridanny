import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/models/location_models.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';
import 'package:flutter_riverpod_template/services/repository/citizen_request_repository.dart';
import 'package:flutter_riverpod_template/services/repository/home_repository.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/utils/languages/language_provider.dart';
import 'package:go_router/go_router.dart';

class AppointmentScreen extends ConsumerStatefulWidget {
  const AppointmentScreen({super.key});

  @override
  ConsumerState<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends ConsumerState<AppointmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _dateController = TextEditingController();
  final _wardController = TextEditingController();
  final _villageController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedType = 'local';
  DivisionModel? _selectedDivision;
  DistrictModel? _selectedDistrict;
  UpazilaModel? _selectedUpazila;
  UnionModel? _selectedUnion;

  bool _isSubmitting = false;
  Map<String, dynamic>? _visitStats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await HomeRepository.instance.recordVisit('/appointments');
    if (mounted && stats != null) {
      setState(() => _visitStats = stats);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _dateController.dispose();
    _wardController.dispose();
    _villageController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _discard() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _mobileController.clear();
    _emailController.clear();
    _subjectController.clear();
    _dateController.clear();
    _wardController.clear();
    _villageController.clear();
    _messageController.clear();
    setState(() {
      _selectedDivision = null;
      _selectedDistrict = null;
      _selectedUpazila = null;
      _selectedUnion = null;
      _selectedType = 'local';
    });
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.instance.primaryGreen,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitAppointment() async {
    final isBangla = ref.read(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);

    if (!_formKey.currentState!.validate()) return;

    if (_selectedDivision == null ||
        _selectedDistrict == null ||
        _selectedUpazila == null ||
        _selectedUnion == null) {
      AppSnackBar.instance.error(tr.selectLocationError);
      return;
    }

    if (_dateController.text.trim().isEmpty) {
      AppSnackBar.instance.error(tr.selectDateError);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final result = await CitizenRequestRepository.instance.submitAppointment(
        name: _nameController.text.trim(),
        mobile: _mobileController.text.trim(),
        email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
        type: _selectedType,
        divisionId: _selectedDivision!.id,
        districtId: _selectedDistrict!.id,
        upazilaId: _selectedUpazila!.id,
        unionId: _selectedUnion!.id,
        wardNo: _wardController.text.trim().isNotEmpty ? _wardController.text.trim() : null,
        village: _villageController.text.trim().isNotEmpty ? _villageController.text.trim() : null,
        subject: _subjectController.text.trim(),
        appointmentDate: _dateController.text.trim(),
        message: _messageController.text.trim(),
      );

      if (!mounted) return;

      if (result != null) {
        _showSuccessDialog(result.trackingNo ?? 'Booked');
        _discard();
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog(String trackingNo) {
    final isBangla = ref.read(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF0C4B33), size: 28),
              const SizedBox(width: 8),
              Text(tr.appointmentRequestedTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr.appointmentRequestedMessage,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF0C4B33), width: 1.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        trackingNo,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0C4B33),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20, color: Color(0xFF0C4B33)),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: trackingNo));
                        AppSnackBar.instance.success(tr.trackingCopied);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C4B33),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(tr.done, style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);
    final primaryGreen = AppColors.instance.primaryGreen;

    final divisionsAsync = ref.watch(divisionsProvider);
    final districtsAsync = _selectedDivision?.id != null
        ? ref.watch(districtsProvider(_selectedDivision!.id))
        : null;
    final upazilasAsync = _selectedDistrict?.id != null
        ? ref.watch(upazilasProvider(_selectedDistrict!.id))
        : null;
    final unionsAsync = _selectedUpazila?.id != null
        ? ref.watch(unionsProvider(_selectedUpazila!.id))
        : null;

    final todayVisits = (_visitStats?['today_visits']?.toString() ?? '2').toBanglaDigits(isBangla);
    final totalVisits = (_visitStats?['total_visits']?.toString() ?? '192').toBanglaDigits(isBangla);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Green Banner
            Container(
              width: double.infinity,
              color: primaryGreen,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          tr.appointmentBannerTitle,
                          style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              context.goNamed('homeScreen');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr.appointmentBannerSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  // Visitor Stats
                  Container(
                    width: 250,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatItem(tr.todayVisitor, todayVisits),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.white30,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        _buildStatItem(tr.totalVisitor, totalVisits),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Form Container
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryGreen, width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.personalInfoSection,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),

                    _buildTextFormField(
                      label: tr.fullNameLabel,
                      hint: tr.fullNameHint,
                      controller: _nameController,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? tr.fullNameRequired
                          : null,
                    ),
                    const SizedBox(height: 16),

                    _buildTextFormField(
                      label: tr.mobileLabel,
                      hint: tr.mobileHint,
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? tr.mobileRequired
                          : null,
                    ),
                    const SizedBox(height: 16),

                    _buildTextFormField(
                      label: tr.emailOptionalLabel,
                      hint: tr.emailHint,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Type
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr.citizenTypeLabel,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        RadioGroup<String>(
                          groupValue: _selectedType,
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedType = val);
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

                    // Division
                    divisionsAsync.when(
                      data: (divisions) => _buildDropdown<DivisionModel>(
                        label: tr.divisionLabel,
                        hint: tr.divisionHint,
                        items: divisions,
                        value: _selectedDivision,
                        itemLabel: (item) => item.localizedName(isBangla),
                        onChanged: (division) {
                          setState(() {
                            _selectedDivision = division;
                            _selectedDistrict = null;
                            _selectedUpazila = null;
                            _selectedUnion = null;
                          });
                        },
                      ),
                      loading: () => _buildDropdownLoading(tr.divisionLabel),
                      error: (err, stack) => _buildDropdownError(tr.divisionLabel, tr.loadDivisionsError),
                    ),
                    const SizedBox(height: 16),

                    // District
                    if (districtsAsync != null)
                      districtsAsync.when(
                        data: (districts) => _buildDropdown<DistrictModel>(
                          label: tr.districtLabel,
                          hint: tr.districtHint,
                          items: districts,
                          value: _selectedDistrict,
                          itemLabel: (item) => item.localizedName(isBangla),
                          onChanged: (district) {
                            setState(() {
                              _selectedDistrict = district;
                              _selectedUpazila = null;
                              _selectedUnion = null;
                            });
                          },
                        ),
                        loading: () => _buildDropdownLoading(tr.districtLabel),
                        error: (err, stack) => _buildDropdownError(tr.districtLabel, tr.loadDistrictsError),
                      )
                    else
                      _buildDisabledDropdown(tr.districtLabel, tr.selectDivisionFirst),
                    const SizedBox(height: 16),

                    // Upazila
                    if (upazilasAsync != null)
                      upazilasAsync.when(
                        data: (upazilas) => _buildDropdown<UpazilaModel>(
                          label: tr.upazilaLabel,
                          hint: tr.upazilaHint,
                          items: upazilas,
                          value: _selectedUpazila,
                          itemLabel: (item) => item.localizedName(isBangla),
                          onChanged: (upazila) {
                            setState(() {
                              _selectedUpazila = upazila;
                              _selectedUnion = null;
                            });
                          },
                        ),
                        loading: () => _buildDropdownLoading(tr.upazilaLabel),
                        error: (err, stack) => _buildDropdownError(tr.upazilaLabel, tr.loadUpazilasError),
                      )
                    else
                      _buildDisabledDropdown(tr.upazilaLabel, tr.selectDistrictFirst),
                    const SizedBox(height: 16),

                    // Union
                    if (unionsAsync != null)
                      unionsAsync.when(
                        data: (unions) => _buildDropdown<UnionModel>(
                          label: tr.unionLabel,
                          hint: tr.unionHint,
                          items: unions,
                          value: _selectedUnion,
                          itemLabel: (item) => item.localizedName(isBangla),
                          onChanged: (union) {
                            setState(() => _selectedUnion = union);
                          },
                        ),
                        loading: () => _buildDropdownLoading(tr.unionLabel),
                        error: (err, stack) => _buildDropdownError(tr.unionLabel, tr.loadUnionsError),
                      )
                    else
                      _buildDisabledDropdown(tr.unionLabel, tr.selectUpazilaFirst),
                    const SizedBox(height: 16),

                    _buildTextFormField(
                      label: tr.wardLabel,
                      hint: tr.wardHint,
                      controller: _wardController,
                    ),
                    const SizedBox(height: 16),

                    _buildTextFormField(
                      label: tr.villageLabel,
                      hint: tr.villageHint,
                      controller: _villageController,
                    ),
                    const SizedBox(height: 24),

                    Text(
                      tr.appointmentDetailsSection,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),

                    // Appointment Date
                    _buildTextFormField(
                      label: tr.appointmentDateLabel,
                      hint: tr.appointmentDateHint,
                      controller: _dateController,
                      readOnly: true,
                      onTap: _selectDate,
                      icon: Icons.calendar_today,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? tr.appointmentDateRequired
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Subject
                    _buildTextFormField(
                      label: tr.appointmentSubjectLabel,
                      hint: tr.appointmentSubjectHint,
                      controller: _subjectController,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? tr.appointmentSubjectRequired
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Message
                    _buildTextFormField(
                      label: tr.appointmentMessageLabel,
                      hint: tr.appointmentMessageHint,
                      controller: _messageController,
                      maxLines: 5,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? tr.appointmentMessageRequired
                          : null,
                    ),

                    const SizedBox(height: 24),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: _isSubmitting ? null : _discard,
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
                              onPressed: _isSubmitting ? null : _submitAppointment,
                              icon: _isSubmitting ? null : const Icon(Icons.send_rounded, size: 18),
                              label: _isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        tr.bookAppointmentBtn,
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
            ),

            const SizedBox(height: 48),

            // Footer
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? icon,
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
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: icon != null ? Icon(icon, color: Colors.grey[600], size: 20) : null,
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
