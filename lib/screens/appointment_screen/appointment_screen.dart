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
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDivision == null ||
        _selectedDistrict == null ||
        _selectedUpazila == null ||
        _selectedUnion == null) {
      AppSnackBar.instance.error("Please select Division, District, Upazila, and Union");
      return;
    }

    if (_dateController.text.trim().isEmpty) {
      AppSnackBar.instance.error("Please select appointment date");
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF0C4B33), size: 28),
              SizedBox(width: 8),
              Text("Appointment Requested", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Your appointment request has been submitted successfully. Please save your tracking number:",
                style: TextStyle(fontSize: 14, color: Colors.black87),
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
                        AppSnackBar.instance.success("Tracking number copied!");
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
              child: const Text("Done", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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

    final todayVisits = _visitStats?['today_visits']?.toString() ?? '2';
    final totalVisits = _visitStats?['total_visits']?.toString() ?? '192';

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
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Get An Appointment",
                          style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
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
                  const Text(
                    "Fill out the form below to request an appointment. Provide accurate information so we can assist you efficiently.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
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
                        _buildStatItem("Today Visitor", todayVisits),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.white30,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        _buildStatItem("Total Visitor", totalVisits),
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
                    const Text(
                      "Personal Information",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),

                    _buildTextFormField(
                      label: "Full Name *",
                      hint: "Enter your full name",
                      controller: _nameController,
                      validator: (val) => val == null || val.trim().isEmpty ? "Name is required" : null,
                    ),
                    const SizedBox(height: 16),

                    _buildTextFormField(
                      label: "Mobile Number *",
                      hint: "e.g. 01700000000",
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      validator: (val) => val == null || val.trim().isEmpty ? "Mobile number is required" : null,
                    ),
                    const SizedBox(height: 16),

                    _buildTextFormField(
                      label: "Email (Optional)",
                      hint: "e.g. user@example.com",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Type
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Citizen Type *",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text("Local", style: TextStyle(fontSize: 14, color: Colors.black87)),
                                value: 'local',
                                groupValue: _selectedType,
                                contentPadding: EdgeInsets.zero,
                                activeColor: primaryGreen,
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedType = val);
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text("Foreign / NRB", style: TextStyle(fontSize: 14, color: Colors.black87)),
                                value: 'nrb',
                                groupValue: _selectedType,
                                contentPadding: EdgeInsets.zero,
                                activeColor: primaryGreen,
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedType = val);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Text(
                      "Address Details",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),

                    // Division
                    divisionsAsync.when(
                      data: (divisions) => _buildDropdown<DivisionModel>(
                        label: "Division *",
                        hint: "Select Division",
                        items: divisions,
                        value: _selectedDivision,
                        itemLabel: (item) => item.localizedName(false),
                        onChanged: (division) {
                          setState(() {
                            _selectedDivision = division;
                            _selectedDistrict = null;
                            _selectedUpazila = null;
                            _selectedUnion = null;
                          });
                        },
                      ),
                      loading: () => _buildDropdownLoading("Division *"),
                      error: (err, stack) => _buildDropdownError("Division *", "Failed to load divisions"),
                    ),
                    const SizedBox(height: 16),

                    // District
                    if (districtsAsync != null)
                      districtsAsync.when(
                        data: (districts) => _buildDropdown<DistrictModel>(
                          label: "District *",
                          hint: "Select District",
                          items: districts,
                          value: _selectedDistrict,
                          itemLabel: (item) => item.localizedName(false),
                          onChanged: (district) {
                            setState(() {
                              _selectedDistrict = district;
                              _selectedUpazila = null;
                              _selectedUnion = null;
                            });
                          },
                        ),
                        loading: () => _buildDropdownLoading("District *"),
                        error: (err, stack) => _buildDropdownError("District *", "Failed to load districts"),
                      )
                    else
                      _buildDisabledDropdown("District *", "Select Division first"),
                    const SizedBox(height: 16),

                    // Upazila
                    if (upazilasAsync != null)
                      upazilasAsync.when(
                        data: (upazilas) => _buildDropdown<UpazilaModel>(
                          label: "Upazila *",
                          hint: "Select Upazila",
                          items: upazilas,
                          value: _selectedUpazila,
                          itemLabel: (item) => item.localizedName(false),
                          onChanged: (upazila) {
                            setState(() {
                              _selectedUpazila = upazila;
                              _selectedUnion = null;
                            });
                          },
                        ),
                        loading: () => _buildDropdownLoading("Upazila *"),
                        error: (err, stack) => _buildDropdownError("Upazila *", "Failed to load upazilas"),
                      )
                    else
                      _buildDisabledDropdown("Upazila *", "Select District first"),
                    const SizedBox(height: 16),

                    // Union
                    if (unionsAsync != null)
                      unionsAsync.when(
                        data: (unions) => _buildDropdown<UnionModel>(
                          label: "Union / Pourashava *",
                          hint: "Select Union",
                          items: unions,
                          value: _selectedUnion,
                          itemLabel: (item) => item.localizedName(false),
                          onChanged: (union) {
                            setState(() => _selectedUnion = union);
                          },
                        ),
                        loading: () => _buildDropdownLoading("Union / Pourashava *"),
                        error: (err, stack) => _buildDropdownError("Union *", "Failed to load unions"),
                      )
                    else
                      _buildDisabledDropdown("Union / Pourashava *", "Select Upazila first"),
                    const SizedBox(height: 16),

                    _buildTextFormField(
                      label: "Ward Number (Optional)",
                      hint: "e.g. 3",
                      controller: _wardController,
                    ),
                    const SizedBox(height: 16),

                    _buildTextFormField(
                      label: "Village / Mohallah (Optional)",
                      hint: "e.g. Nabinagar",
                      controller: _villageController,
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "Appointment Details",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),

                    // Appointment Date
                    _buildTextFormField(
                      label: "Preferred Appointment Date *",
                      hint: "YYYY-MM-DD",
                      controller: _dateController,
                      readOnly: true,
                      onTap: _selectDate,
                      icon: Icons.calendar_today,
                      validator: (val) => val == null || val.trim().isEmpty ? "Date is required" : null,
                    ),
                    const SizedBox(height: 16),

                    // Subject
                    _buildTextFormField(
                      label: "Appointment Subject *",
                      hint: "e.g. Constitutional advisory meeting",
                      controller: _subjectController,
                      validator: (val) => val == null || val.trim().isEmpty ? "Subject is required" : null,
                    ),
                    const SizedBox(height: 16),

                    // Message
                    _buildTextFormField(
                      label: "Meeting Purpose / Details *",
                      hint: "Explain the reason and agenda for requesting the appointment...",
                      controller: _messageController,
                      maxLines: 5,
                      validator: (val) => val == null || val.trim().isEmpty ? "Details are required" : null,
                    ),

                    const SizedBox(height: 32),

                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _isSubmitting ? null : _discard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Text("Discard", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitAppointment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0C4B33),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text("Book Appointment", style: TextStyle(fontWeight: FontWeight.bold)),
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
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
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
