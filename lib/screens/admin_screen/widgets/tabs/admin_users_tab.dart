import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/models/auth_user_model.dart';
import 'package:barristerkayserkamal/screens/admin_screen/providers/admin_providers.dart';
import 'package:barristerkayserkamal/services/repository/admin_repository.dart';
import 'package:barristerkayserkamal/utils/app_snack_bar.dart';

class AdminUsersTab extends ConsumerStatefulWidget {
  final bool isBangla;
  final Future<void> Function() onRefresh;

  const AdminUsersTab({
    super.key,
    required this.isBangla,
    required this.onRefresh,
  });

  @override
  ConsumerState<AdminUsersTab> createState() => _AdminUsersTabState();
}

class _AdminUsersTabState extends ConsumerState<AdminUsersTab> {
  final TextEditingController _userSearchController = TextEditingController();
  String _activeUserSearch = '';

  @override
  void dispose() {
    _userSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = widget.isBangla;
    final usersAsync = ref.watch(adminUsersListProvider);

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: AppColors.instance.primaryGreen,
      child: usersAsync.when(
        data: (users) {
          final query = _activeUserSearch.toLowerCase().trim();
          final filteredUsers = users.where((u) {
            if (query.isEmpty) return true;
            final name = (u.name ?? '').toLowerCase();
            final email = (u.email ?? '').toLowerCase();
            return name.contains(query) || email.contains(query);
          }).toList();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              // 1. Breadcrumbs and Title (Exact as in Screenshot)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pages / Users",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isBangla ? "ইউজারবৃন্দ (Users)" : "Users",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 2. Filter & Action Card (Search input, SEARCH button, ADD USER button)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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
                    // Search by name or email
                    TextField(
                      controller: _userSearchController,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: isBangla
                            ? "নাম বা ইমেল দিয়ে অনুসন্ধান করুন (Search by name or email)"
                            : "Search by name or email",
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                        prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
                        suffixIcon: _userSearchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                                onPressed: () {
                                  _userSearchController.clear();
                                  setState(() => _activeUserSearch = '');
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
                      onChanged: (val) {
                        setState(() {});
                      },
                      onSubmitted: (val) {
                        setState(() => _activeUserSearch = val.trim());
                      },
                    ),
                    const SizedBox(height: 10),

                    // Action Buttons Row: SEARCH and ADD USER
                    Row(
                      children: [
                        // SEARCH Button (Deep Green)
                        Expanded(
                          child: SizedBox(
                            height: 42,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _activeUserSearch = _userSearchController.text.trim();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF063A24),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                              child: Text(
                                isBangla ? "অনুসন্ধান (SEARCH)" : "SEARCH",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // ADD USER Button (White with border)
                        Expanded(
                          child: SizedBox(
                            height: 42,
                            child: OutlinedButton(
                              onPressed: () => _showAddUserDialog(isBangla),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF063A24),
                                side: BorderSide(color: Colors.grey.shade400),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                isBangla ? "ইউজার যোগ করুন" : "ADD USER",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 3. Counter & Pagination Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isBangla
                        ? "মোট ${users.length} জনের মধ্যে ${filteredUsers.length} জন প্রদর্শিত"
                        : "Showing ${filteredUsers.length} of ${users.length} users",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "1-${filteredUsers.length} of ${users.length}",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 4. Users List
              if (filteredUsers.isEmpty) ...[
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
                        Icon(Icons.person_off_outlined, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          isBangla ? "কোনো ইউজার পাওয়া যায়নি" : "No users match the filter",
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: () {
                            _userSearchController.clear();
                            setState(() => _activeUserSearch = '');
                          },
                          icon: const Icon(Icons.refresh, size: 16),
                          label: Text(isBangla ? "ফিল্টার রিসেট করুন" : "Reset Filter"),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredUsers.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Header: ID badge on left, Action buttons (EDIT, DELETE) on right
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // ID Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "${user.id ?? ''}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),

                              // Action Buttons: EDIT & DELETE (Exact style from screenshot)
                              Row(
                                children: [
                                  // EDIT Button (Solid green)
                                  InkWell(
                                    onTap: () => _showEditUserDialog(user, isBangla),
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF063A24),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        "EDIT",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  // DELETE Button (White with red border and red text)
                                  InkWell(
                                    onTap: () => _showDeleteUserDialog(user, isBangla),
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: const Color(0xFFE53E3E)),
                                      ),
                                      child: const Text(
                                        "DELETE",
                                        style: TextStyle(
                                          color: Color(0xFFE53E3E),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 18, color: Color(0xFFF1F5F9)),

                          // Name & Email
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isBangla ? "নাম (Name)" : "Name",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      user.name?.isNotEmpty == true ? user.name! : '-',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isBangla ? "ইমেল (Email)" : "Email",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      user.email?.isNotEmpty == true ? user.email! : '-',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Permissions
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isBangla ? "অনুমতিসমূহ (Permissions)" : "Permissions",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user.permissions.isNotEmpty
                                    ? user.permissions.join(', ')
                                    : (isBangla ? "কোনো নির্দিষ্ট অনুমতি নেই" : "No specific permissions"),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                  height: 1.3,
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
              const SizedBox(height: 16),

              // Bottom footer indicator (Rows per page: 10, 1-2 of 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isBangla ? "প্রতি পৃষ্ঠায় সারি: 10" : "Rows per page: 10",
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  Text(
                    "1-${filteredUsers.length} of ${users.length}",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
                isBangla ? "ইউজার তালিকা লোড হতে সমস্যা হয়েছে" : "Error loading users",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: widget.onRefresh,
                icon: const Icon(Icons.refresh, size: 16),
                label: Text(isBangla ? "পুনরায় চেষ্টা করুন" : "Retry"),
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

  void _showAddUserDialog(bool isBangla) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              const Icon(Icons.person_add, color: Color(0xFF063A24)),
              const SizedBox(width: 8),
              Text(
                isBangla ? "নতুন ইউজার যোগ করুন" : "Add New User",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: isBangla ? "নাম" : "Name",
                    labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF063A24), width: 1.5)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailCtrl,
                  style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: isBangla ? "ইমেল" : "Email",
                    labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF063A24), width: 1.5)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordCtrl,
                  style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: isBangla ? "পাসওয়ার্ড" : "Password",
                    labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF063A24), width: 1.5)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting ? null : () => Navigator.pop(dialogCtx),
              child: Text(isBangla ? "বাতিল" : "Cancel", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      final name = nameCtrl.text.trim();
                      final email = emailCtrl.text.trim();
                      final pass = passwordCtrl.text.trim();
                      if (name.isEmpty || email.isEmpty || pass.isEmpty) {
                        AppSnackBar.instance.error(
                          isBangla ? "সবগুলো ফিল্ড পূরণ করুন" : "Please fill in all fields",
                        );
                        return;
                      }
                      setDialogState(() => isSubmitting = true);
                      final success = await AdminRepository.instance.createAdminUser(
                        name: name,
                        email: email,
                        password: pass,
                      );
                      if (dialogCtx.mounted) {
                        Navigator.pop(dialogCtx);
                      }
                      if (mounted) {
                        if (success) {
                          ref.invalidate(adminUsersListProvider);
                          AppSnackBar.instance.success(
                            isBangla ? "ইউজার সফলভাবে যোগ হয়েছে" : "User created successfully",
                          );
                        } else {
                          AppSnackBar.instance.error(
                            isBangla ? "ইউজার তৈরিতে ব্যর্থ হয়েছে" : "Failed to create user",
                          );
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF063A24),
                foregroundColor: Colors.white,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(isBangla ? "তৈরি করুন" : "CREATE"),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditUserDialog(AuthUserModel user, bool isBangla) {
    final nameCtrl = TextEditingController(text: user.name ?? '');
    final emailCtrl = TextEditingController(text: user.email ?? '');
    final passwordCtrl = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              const Icon(Icons.edit, color: Color(0xFF063A24)),
              const SizedBox(width: 8),
              Text(
                isBangla ? "ইউজার এডিট করুন" : "Edit User",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: isBangla ? "নাম" : "Name",
                    labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF063A24), width: 1.5)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailCtrl,
                  style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: isBangla ? "ইমেল" : "Email",
                    labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF063A24), width: 1.5)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordCtrl,
                  style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: isBangla ? "নতুন পাসওয়ার্ড (ঐচ্ছিক)" : "New Password (Optional)",
                    labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF063A24), width: 1.5)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting ? null : () => Navigator.pop(dialogCtx),
              child: Text(isBangla ? "বাতিল" : "Cancel", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      if (user.id == null) return;
                      final name = nameCtrl.text.trim();
                      final email = emailCtrl.text.trim();
                      final pass = passwordCtrl.text.trim();
                      if (name.isEmpty || email.isEmpty) {
                        AppSnackBar.instance.error(
                          isBangla ? "নাম ও ইমেল আবশ্যক" : "Name and email are required",
                        );
                        return;
                      }
                      setDialogState(() => isSubmitting = true);
                      final body = <String, dynamic>{
                        'name': name,
                        'email': email,
                        if (pass.isNotEmpty) 'password': pass,
                      };
                      final success = await AdminRepository.instance.updateAdminUser(user.id!, body);
                      if (dialogCtx.mounted) {
                        Navigator.pop(dialogCtx);
                      }
                      if (mounted) {
                        if (success) {
                          ref.invalidate(adminUsersListProvider);
                          AppSnackBar.instance.success(
                            isBangla ? "ইউজার সফলভাবে আপডেট হয়েছে" : "User updated successfully",
                          );
                        } else {
                          AppSnackBar.instance.error(
                            isBangla ? "আপডেট ব্যর্থ হয়েছে" : "Failed to update user",
                          );
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF063A24),
                foregroundColor: Colors.white,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(isBangla ? "সংরক্ষণ" : "SAVE"),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteUserDialog(AuthUserModel user, bool isBangla) {
    if (user.id == null) return;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          isBangla ? "ইউজার মুছে ফেলবেন?" : "Delete User",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: Text(
          isBangla
              ? "আপনি কি নিশ্চিত যে '${user.name ?? 'এই ইউজার'}' মুছে ফেলতে চান?"
              : "Are you sure you want to delete '${user.name ?? 'this user'}'?",
          style: const TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(isBangla ? "বাতিল" : "Cancel", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              final success = await AdminRepository.instance.deleteAdminUser(user.id!);
              if (mounted) {
                if (success) {
                  ref.invalidate(adminUsersListProvider);
                  AppSnackBar.instance.success(
                    isBangla ? "ইউজার সফলভাবে মুছে ফেলা হয়েছে" : "User deleted successfully",
                  );
                } else {
                  AppSnackBar.instance.error(
                    isBangla ? "মুছে ফেলতে ব্যর্থ হয়েছে" : "Failed to delete user",
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53E3E),
              foregroundColor: Colors.white,
            ),
            child: Text(isBangla ? "মুছুন" : "DELETE"),
          ),
        ],
      ),
    );
  }

  // 4. Contact Tab (Exact UI & Structure from Screenshot)
}
