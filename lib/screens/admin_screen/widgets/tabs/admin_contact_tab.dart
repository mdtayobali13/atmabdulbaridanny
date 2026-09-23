import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/models/admin_dashboard_model.dart';
import 'package:atmabdulbaridanny/screens/admin_screen/providers/admin_providers.dart';
import 'package:atmabdulbaridanny/services/repository/admin_repository.dart';
import 'package:atmabdulbaridanny/utils/app_snack_bar.dart';

class AdminContactTab extends ConsumerStatefulWidget {
  final bool isBangla;
  final Future<void> Function() onRefresh;

  const AdminContactTab({
    super.key,
    required this.isBangla,
    required this.onRefresh,
  });

  @override
  ConsumerState<AdminContactTab> createState() => _AdminContactTabState();
}

class _AdminContactTabState extends ConsumerState<AdminContactTab> {
  @override
  Widget build(BuildContext context) {
    final isBangla = widget.isBangla;
    final contactsAsync = ref.watch(adminContactListProvider);

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: AppColors.instance.primaryGreen,
      child: contactsAsync.when(
        data: (contacts) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              if (contacts.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "1-${contacts.length} of ${contacts.length}",
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
              ],

              // 3. Contact Cards List
              if (contacts.isEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.mail, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          isBangla ? "কোনো যোগাযোগ বার্তা পাওয়া যায়নি" : "No contact messages found",
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: contacts.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = contacts[index];

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
                          // Top Header: SN badge on left, Action buttons (VIEW, DELETE) on right
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // SN Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  "#${index + 1}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),

                              // Actions: VIEW & DELETE
                              Row(
                                children: [
                                  // VIEW Button
                                  InkWell(
                                    onTap: () => _showContactDetailsDialog(item, isBangla),
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF063A24),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        "VIEW",
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

                                  // DELETE Button
                                  InkWell(
                                    onTap: () => _showDeleteContactDialog(item, isBangla),
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

                          // Name & Mobile
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
                                      item.name?.isNotEmpty == true ? item.name! : '-',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0F172A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (item.number != null && item.number!.isNotEmpty)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isBangla ? "মোবাইল (Mobile)" : "Mobile",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        item.number!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0F172A),
                                        ),
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
                                isBangla ? "বিষয় (Subject)" : "Subject",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                item.subject?.isNotEmpty == true ? item.subject! : '-',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),

                          // Message preview
                          if (item.message != null && item.message!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              item.message!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF475569),
                                height: 1.3,
                              ),
                            ),
                          ],

                          // Date
                          if (item.createdAt != null && item.createdAt!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              item.createdAt!.contains('T') ? item.createdAt!.split('T').first : item.createdAt!,
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],
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
                isBangla ? "যোগাযোগ তালিকা লোড হতে সমস্যা হয়েছে" : "Error loading contact list",
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

  void _showContactDetailsDialog(ContactMessageModel item, bool isBangla) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            const Icon(CupertinoIcons.mail, color: Color(0xFF063A24)),
            const SizedBox(width: 8),
            Text(
              isBangla ? "যোগাযোগের বিবরণ" : "Contact Details",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem(isBangla ? "নাম" : "Name", item.name ?? '-'),
              const SizedBox(height: 8),
              if (item.number != null && item.number!.isNotEmpty) ...[
                _buildDetailItem(isBangla ? "মোবাইল / ফোন" : "Mobile / Phone", item.number!),
                const SizedBox(height: 8),
              ],
              if (item.email != null && item.email!.isNotEmpty) ...[
                _buildDetailItem(isBangla ? "ইমেল" : "Email", item.email!),
                const SizedBox(height: 8),
              ],
              _buildDetailItem(isBangla ? "বিষয়" : "Subject", item.subject ?? '-'),
              const SizedBox(height: 8),
              _buildDetailItem(isBangla ? "বার্তা" : "Message", item.message ?? '-'),
              if (item.createdAt != null && item.createdAt!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildDetailItem(
                  isBangla ? "তারিখ" : "Date",
                  item.createdAt!.contains('T') ? item.createdAt!.split('T').first : item.createdAt!,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(isBangla ? "বন্ধ করুন" : "Close", style: const TextStyle(color: Color(0xFF063A24))),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  void _showDeleteContactDialog(ContactMessageModel item, bool isBangla) {
    if (item.id == null) return;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          isBangla ? "মেসেজ মুছে ফেলবেন?" : "Delete Message",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: Text(
          isBangla
              ? "আপনি কি নিশ্চিত যে এই মেসেজটি মুছে ফেলতে চান?"
              : "Are you sure you want to delete this contact message?",
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
              final success = await AdminRepository.instance.deleteContact(item.id!);
              if (mounted) {
                if (success) {
                  ref.invalidate(adminContactListProvider);
                  AppSnackBar.instance.success(
                    isBangla ? "মেসেজটি সফলভাবে মুছে ফেলা হয়েছে" : "Message deleted successfully",
                  );
                } else {
                  AppSnackBar.instance.error(
                    isBangla ? "মুছে ফেলতে ব্যর্থ হয়েছে" : "Failed to delete message",
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
}
