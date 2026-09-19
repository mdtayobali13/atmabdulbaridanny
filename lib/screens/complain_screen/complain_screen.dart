import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/models/location_models.dart';
import 'package:barristerkayserkamal/screens/app_navigation/widgets/app_drawer.dart';
import 'package:barristerkayserkamal/screens/complain_screen/widgets/complain_form_card.dart';
import 'package:barristerkayserkamal/screens/complain_screen/widgets/complain_header_banner.dart';
import 'package:barristerkayserkamal/screens/complain_screen/widgets/complain_success_dialog.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/custom_footer.dart';
import 'package:barristerkayserkamal/services/repository/citizen_request_repository.dart';
import 'package:barristerkayserkamal/services/repository/home_repository.dart';
import 'package:barristerkayserkamal/utils/app_snack_bar.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';

class ComplainScreen extends ConsumerStatefulWidget {
  const ComplainScreen({super.key});

  @override
  ConsumerState<ComplainScreen> createState() => _ComplainScreenState();
}

class _ComplainScreenState extends ConsumerState<ComplainScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
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
    final stats = await HomeRepository.instance.recordVisit('/complaints');
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

  Future<void> _submitComplaint() async {
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

    setState(() => _isSubmitting = true);

    try {
      final result = await CitizenRequestRepository.instance.submitComplaint(
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
        subject: _subjectController.text.trim().isNotEmpty ? _subjectController.text.trim() : null,
        message: _messageController.text.trim(),
      );

      if (!mounted) return;

      if (result != null) {
        ComplainSuccessDialog.show(context, result.trackingNo ?? 'Submitted', tr);
        _discard();
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);
    final primaryGreen = AppColors.instance.primaryGreen;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ComplainHeaderBanner(
              primaryGreen: primaryGreen,
              tr: tr,
              visitStats: _visitStats,
              isBangla: isBangla,
            ),
            const SizedBox(height: 32),
            ComplainFormCard(
              formKey: _formKey,
              nameController: _nameController,
              mobileController: _mobileController,
              emailController: _emailController,
              subjectController: _subjectController,
              wardController: _wardController,
              villageController: _villageController,
              messageController: _messageController,
              selectedType: _selectedType,
              onTypeChanged: (type) => setState(() => _selectedType = type),
              selectedDivision: _selectedDivision,
              selectedDistrict: _selectedDistrict,
              selectedUpazila: _selectedUpazila,
              selectedUnion: _selectedUnion,
              onDivisionChanged: (div) {
                setState(() {
                  _selectedDivision = div;
                  _selectedDistrict = null;
                  _selectedUpazila = null;
                  _selectedUnion = null;
                });
              },
              onDistrictChanged: (dist) {
                setState(() {
                  _selectedDistrict = dist;
                  _selectedUpazila = null;
                  _selectedUnion = null;
                });
              },
              onUpazilaChanged: (upz) {
                setState(() {
                  _selectedUpazila = upz;
                  _selectedUnion = null;
                });
              },
              onUnionChanged: (uni) => setState(() => _selectedUnion = uni),
              isSubmitting: _isSubmitting,
              onDiscard: _discard,
              onSubmit: _submitComplaint,
              primaryGreen: primaryGreen,
              isBangla: isBangla,
              tr: tr,
            ),
            const SizedBox(height: 48),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
