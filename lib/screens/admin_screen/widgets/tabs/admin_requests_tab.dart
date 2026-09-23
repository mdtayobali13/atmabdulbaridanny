import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/screens/admin_screen/providers/admin_providers.dart';
import 'package:atmabdulbaridanny/services/repository/citizen_request_repository.dart';
import 'package:atmabdulbaridanny/utils/app_snack_bar.dart';

class AdminRequestsTab extends ConsumerStatefulWidget {
  final bool isBangla;
  final Future<void> Function() onRefresh;

  const AdminRequestsTab({
    super.key,
    required this.isBangla,
    required this.onRefresh,
  });

  @override
  ConsumerState<AdminRequestsTab> createState() => _AdminRequestsTabState();
}

class _AdminRequestsTabState extends ConsumerState<AdminRequestsTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'All Types';
  String _selectedStatus = 'All Status';
  String _activeSearch = '';
  int? _updatingRequestId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus(int id, String newStatus) async {
    setState(() => _updatingRequestId = id);
    final success = await CitizenRequestRepository.instance.updateCitizenRequestStatus(
      id,
      newStatus.toLowerCase(),
    );

    if (mounted) {
      setState(() => _updatingRequestId = null);
      if (success) {
        ref.invalidate(adminCitizenRequestsProvider);
        AppSnackBar.instance.success(
          widget.isBangla ? "স্ট্যাটাস আপডেট সফল হয়েছে" : "Status successfully updated to $newStatus",
        );
      } else {
        AppSnackBar.instance.error(
          widget.isBangla ? "স্ট্যাটাস আপডেট ব্যর্থ হয়েছে" : "Failed to update status",
        );
      }
    }
  }

  String _normalizeStatus(String? status) {
    if (status == null || status.isEmpty) return 'Pending';
    final s = status.toLowerCase();
    switch (s) {
      case 'processing':
        return 'Processing';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'completed':
        return 'Completed';
      case 'pending':
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(adminCitizenRequestsProvider);

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: AppColors.instance.primaryGreen,
      child: requestsAsync.when(
        data: (requests) {
          final filtered = requests.where((req) {
            if (_selectedType == 'Complaint') {
              if ((req.requestType ?? '').toLowerCase() != 'complaint') return false;
            } else if (_selectedType == 'Appointment') {
              if ((req.requestType ?? '').toLowerCase() != 'appointment') return false;
            }

            if (_selectedStatus != 'All Status') {
              if ((req.status ?? '').toLowerCase() != _selectedStatus.toLowerCase()) return false;
            }

            if (_activeSearch.isNotEmpty) {
              final q = _activeSearch.toLowerCase();
              final name = (req.name ?? '').toLowerCase();
              final tracking = (req.trackingNo ?? '').toLowerCase();
              final mobile = (req.mobile ?? '').toLowerCase();
              final subject = (req.subject ?? '').toLowerCase();
              final division = (req.divisionName ?? '').toLowerCase();
              final district = (req.districtName ?? '').toLowerCase();
              final idStr = (req.id?.toString() ?? '');

              if (!name.contains(q) &&
                  !tracking.contains(q) &&
                  !mobile.contains(q) &&
                  !subject.contains(q) &&
                  !division.contains(q) &&
                  !district.contains(q) &&
                  !idStr.contains(q)) {
                return false;
              }
            }
            return true;
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Breadcrumb & Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pages / Citizen Request",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.isBangla ? "নাগরিক আবেদন (Citizen Request)" : "Citizen Request",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 2. Filter Bar
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Search Input
                    TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: widget.isBangla ? "অনুসন্ধান (Search)" : "Search",
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                        prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _activeSearch = '');
                                },
                              )
                            : null,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.instance.primaryGreen, width: 1.5),
                        ),
                      ),
                      onChanged: (val) => setState(() {}),
                      onSubmitted: (val) => setState(() => _activeSearch = val.trim()),
                    ),
                    const SizedBox(height: 10),

                    // Dropdowns: All Types & All Status
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              value: _selectedType,
                              isExpanded: true,
                              style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                              items: const [
                                DropdownMenuItem(
                                  value: 'All Types',
                                  child: Text('All Types', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500)),
                                ),
                                DropdownMenuItem(
                                  value: 'Complaint',
                                  child: Text('Complaint', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500)),
                                ),
                                DropdownMenuItem(
                                  value: 'Appointment',
                                  child: Text('Appointment', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500)),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedType = val);
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 42,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 250,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                                  ],
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(height: 40, padding: EdgeInsets.symmetric(horizontal: 12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // All Status Dropdown
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              value: _selectedStatus,
                              isExpanded: true,
                              style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                              items: const [
                                DropdownMenuItem(value: 'All Status', child: Text('All Status', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500))),
                                DropdownMenuItem(value: 'Pending', child: Text('Pending', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500))),
                                DropdownMenuItem(value: 'Processing', child: Text('Processing', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500))),
                                DropdownMenuItem(value: 'Approved', child: Text('Approved', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500))),
                                DropdownMenuItem(value: 'Rejected', child: Text('Rejected', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500))),
                                DropdownMenuItem(value: 'Completed', child: Text('Completed', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500))),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedStatus = val);
                              },
                              buttonStyleData: ButtonStyleData(
                                height: 42,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 250,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                                  ],
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(height: 40, padding: EdgeInsets.symmetric(horizontal: 12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // SEARCH Button
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _activeSearch = _searchController.text.trim();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF063A24),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: Text(
                          widget.isBangla ? "অনুসন্ধান (SEARCH)" : "SEARCH",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 3. Count indicator bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isBangla
                        ? "মোট ${requests.length}টির মধ্যে ${filtered.length}টি প্রদর্শিত"
                        : "Showing ${filtered.length} of ${requests.length} requests",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "1-${filtered.length} of ${requests.length}",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 4. Results List
              if (filtered.isEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.tray, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          widget.isBangla ? "কোনো ফলাফল পাওয়া যায়নি" : "No citizen requests match the filter",
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _selectedType = 'All Types';
                              _selectedStatus = 'All Status';
                              _activeSearch = '';
                            });
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: Text(widget.isBangla ? "ফিল্টার রিসেট করুন" : "Reset Filters"),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final req = filtered[index];
                    final isComplaint = (req.requestType ?? '').toLowerCase() == 'complaint';
                    final isUpdating = _updatingRequestId == req.id;
                    final currentStatus = _normalizeStatus(req.status);

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  "${req.id ?? ''}",
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  req.trackingNo ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Color(0xFF475569), fontFamily: 'monospace'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isComplaint ? const Color(0xFFC53030) : const Color(0xFF103B2B),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  isComplaint ? "complaint" : "appointment",
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 18, color: Color(0xFFF1F5F9)),

                          // Name & Mobile
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.isBangla ? "নাম (Name)" : "Name",
                                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      req.name?.isNotEmpty == true ? req.name! : '-',
                                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                    ),
                                  ],
                                ),
                              ),
                              if (req.mobile?.isNotEmpty == true)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.isBangla ? "মোবাইল (Mobile)" : "Mobile",
                                        style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        req.mobile!,
                                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Division & District
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.isBangla ? "বিভাগ ও জেলা (Division / District)" : "Division / District",
                                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      "${req.divisionName?.isNotEmpty == true ? req.divisionName : '-'}, ${req.districtName?.isNotEmpty == true ? req.districtName : '-'}",
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isComplaint && req.appointmentDate != null && req.appointmentDate!.isNotEmpty)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.isBangla ? "সাক্ষাৎকার তারিখ" : "Appointment Date",
                                        style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        req.appointmentDate!.split('T').first,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F766E)),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Subject
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.isBangla ? "বিষয় (Subject)" : "Subject",
                                style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                req.subject?.isNotEmpty == true ? req.subject! : '-',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155), fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Created At & Status Dropdown
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.isBangla ? "আবেদনের সময় (Created At)" : "Created At",
                                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 1),
                                  Text(
                                    req.createdAt?.isNotEmpty == true
                                        ? (req.createdAt!.contains('T')
                                            ? req.createdAt!.split('T').first
                                            : req.createdAt!)
                                        : '-',
                                    style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),

                              isUpdating
                                  ? const SizedBox(width: 26, height: 26, child: CircularProgressIndicator(strokeWidth: 2))
                                  : DropdownButtonHideUnderline(
                                      child: DropdownButton2<String>(
                                        value: currentStatus,
                                        style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
                                        items: const [
                                          DropdownMenuItem(value: 'Pending', child: Text('Pending', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600))),
                                          DropdownMenuItem(value: 'Processing', child: Text('Processing', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600))),
                                          DropdownMenuItem(value: 'Approved', child: Text('Approved', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600))),
                                          DropdownMenuItem(value: 'Rejected', child: Text('Rejected', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600))),
                                          DropdownMenuItem(value: 'Completed', child: Text('Completed', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600))),
                                        ],
                                        onChanged: (val) {
                                          if (val != null && val != currentStatus && req.id != null) {
                                            _updateStatus(req.id!, val);
                                          }
                                        },
                                        buttonStyleData: ButtonStyleData(
                                          height: 34,
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: const Color(0xFFCBD5E1)),
                                          ),
                                        ),
                                        iconStyleData: const IconStyleData(
                                          icon: Icon(Icons.arrow_drop_down, size: 18, color: Colors.black),
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          maxHeight: 220,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(6),
                                            boxShadow: const [
                                              BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                                            ],
                                          ),
                                        ),
                                        menuItemStyleData: const MenuItemStyleData(height: 36, padding: EdgeInsets.symmetric(horizontal: 10)),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                widget.isBangla ? "রিকোয়েস্ট লোড হতে সমস্যা হয়েছে" : "Error loading requests",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: widget.onRefresh,
                icon: const Icon(Icons.refresh, size: 16),
                label: Text(widget.isBangla ? "পুনরায় চেষ্টা করুন" : "Retry"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.instance.primaryGreen,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
