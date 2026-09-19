import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barristerkayserkamal/models/content_models.dart';
import 'package:barristerkayserkamal/screens/admin_screen/providers/admin_providers.dart';
import 'package:barristerkayserkamal/services/repository/admin_repository.dart';
import 'package:barristerkayserkamal/utils/app_snack_bar.dart';

class AdminAboutMeTab extends ConsumerStatefulWidget {
  final bool isBangla;
  final Future<void> Function() onRefresh;

  const AdminAboutMeTab({
    super.key,
    required this.isBangla,
    required this.onRefresh,
  });

  @override
  ConsumerState<AdminAboutMeTab> createState() => _AdminAboutMeTabState();
}

class _AdminAboutMeTabState extends ConsumerState<AdminAboutMeTab> {
  @override
  Widget build(BuildContext context) {
    final isBangla = widget.isBangla;
    final aboutMeAsync = ref.watch(adminAboutMeListProvider);

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb and Title
            Text(
              "Pages / About Me",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isBangla ? "আমার সম্পর্কে" : "About Me",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),

            // White Card Container matching web admin style
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Header: Title + Add new button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isBangla ? "আমার সম্পর্কে তালিকা" : "About Me list",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showAddEditAboutMeDialog(null, isBangla),
                        icon: const Icon(Icons.add, size: 16, color: Colors.white),
                        label: Text(
                          isBangla ? "নতুন যোগ করুন" : "Add new",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 44,
                          child: Text(
                            "SN",
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Photo",
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                        Text(
                          "Action",
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Data List
                  aboutMeAsync.when(
                    data: (items) {
                      if (items.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 36),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(CupertinoIcons.person_crop_circle, size: 48, color: Colors.grey.shade300),
                                const SizedBox(height: 8),
                                Text(
                                  isBangla ? "কোনো তথ্য পাওয়া যায়নি" : "No About Me entries found",
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (_, index) => Divider(height: 20, color: Colors.grey.shade100),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final sn = index + 1;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                child: Row(
                                  children: [
                                    // SN
                                    SizedBox(
                                      width: 44,
                                      child: Text(
                                        "$sn",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF334155),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Photo Thumbnail
                                    Expanded(
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: item.file != null && item.file!.isNotEmpty
                                                ? Image.network(
                                                    item.fullImageUrl,
                                                    width: 44,
                                                    height: 44,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (_, error, stackTrace) => Container(
                                                      width: 44,
                                                      height: 44,
                                                      color: Colors.grey.shade200,
                                                      child: const Icon(Icons.person, color: Colors.grey, size: 24),
                                                    ),
                                                  )
                                                : Container(
                                                    width: 44,
                                                    height: 44,
                                                    color: Colors.grey.shade200,
                                                    child: const Icon(Icons.person, color: Colors.grey, size: 24),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Actions: Delete (Red) & Edit (Blue)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Delete Icon
                                        IconButton(
                                          icon: const Icon(CupertinoIcons.trash, color: Color(0xFFE53E3E), size: 19),
                                          tooltip: isBangla ? "মুছুন" : "Delete",
                                          onPressed: () => _showDeleteAboutMeDialog(item, isBangla),
                                        ),
                                        // Edit Icon
                                        IconButton(
                                          icon: const Icon(Icons.edit_square, color: Color(0xFF3B82F6), size: 20),
                                          tooltip: isBangla ? "সম্পাদনা" : "Edit",
                                          onPressed: () => _showAddEditAboutMeDialog(item, isBangla),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Content Preview if available
                              if ((item.contentEn != null && item.contentEn!.trim().isNotEmpty) ||
                                  (item.contentBn != null && item.contentBn!.trim().isNotEmpty)) ...[
                                const SizedBox(height: 6),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(left: 4, right: 4, top: 2),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (item.contentEn != null && item.contentEn!.trim().isNotEmpty) ...[
                                        Text(
                                          "EN: ${item.contentEn!}",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF334155),
                                            height: 1.35,
                                          ),
                                        ),
                                      ],
                                      if (item.contentBn != null && item.contentBn!.trim().isNotEmpty) ...[
                                        if (item.contentEn != null && item.contentEn!.trim().isNotEmpty)
                                          const SizedBox(height: 4),
                                        Text(
                                          "BN: ${item.contentBn!}",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF334155),
                                            height: 1.35,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, _) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.error_outline, size: 40, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text(
                              isBangla ? "তথ্য লোড হতে সমস্যা হয়েছে" : "Error loading About Me",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () => ref.invalidate(adminAboutMeListProvider),
                              icon: const Icon(Icons.refresh, size: 14),
                              label: Text(isBangla ? "পুনরায় চেষ্টা" : "Retry"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6366F1),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showAddEditAboutMeDialog(AboutMeModel? item, bool isBangla) {
    final isEditing = item != null;
    final enController = TextEditingController(text: item?.contentEn ?? '');
    final bnController = TextEditingController(text: item?.contentBn ?? '');
    String? pickedImagePath;
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0x1A6366F1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(CupertinoIcons.person_crop_circle, color: Color(0xFF6366F1), size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isEditing
                        ? (isBangla ? "আমার সম্পর্কে সম্পাদনা" : "Edit About Me")
                        : (isBangla ? "নতুন তথ্য যোগ করুন" : "Add New About Me"),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54, size: 20),
                  onPressed: () => Navigator.pop(dialogCtx),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo Picker Section
                    Text(
                      isBangla ? "ছবি (Photo)" : "Photo",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: pickedImagePath != null
                                  ? Image.file(File(pickedImagePath!), fit: BoxFit.cover)
                                  : (item?.file != null && item!.file!.isNotEmpty
                                      ? Image.network(
                                          item.fullImageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, error, stackTrace) =>
                                              const Icon(Icons.person, size: 50, color: Colors.grey),
                                        )
                                      : const Icon(Icons.person, size: 50, color: Colors.grey)),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () async {
                                final picker = ImagePicker();
                                final picked = await picker.pickImage(source: ImageSource.gallery);
                                if (picked != null) {
                                  setDialogState(() {
                                    pickedImagePath = picked.path;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF6366F1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: TextButton.icon(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(source: ImageSource.gallery);
                          if (picked != null) {
                            setDialogState(() {
                              pickedImagePath = picked.path;
                            });
                          }
                        },
                        icon: const Icon(Icons.photo_library, size: 16, color: Color(0xFF6366F1)),
                        label: Text(
                          isBangla ? "ছবি পরিবর্তন করুন" : "Choose Photo",
                          style: const TextStyle(fontSize: 12, color: Color(0xFF6366F1), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Content English
                    Text(
                      isBangla ? "বিবরণ (English)" : "Content (English)",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: enController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: isBangla ? "ইংরেজি বিবরণ লিখুন..." : "Enter English content...",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
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
                          borderSide: const BorderSide(color: Color(0xFF6366F1)),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Content Bangla
                    Text(
                      isBangla ? "বিবরণ (বাংলা)" : "Content (Bangla)",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: bnController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: isBangla ? "বাংলা বিবরণ লিখুন..." : "Enter Bangla content...",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
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
                          borderSide: const BorderSide(color: Color(0xFF6366F1)),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSaving ? null : () => Navigator.pop(dialogCtx),
                child: Text(
                  isBangla ? "বাতিল" : "Cancel",
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton(
                onPressed: isSaving
                    ? null
                    : () async {
                        setDialogState(() {
                          isSaving = true;
                        });
                        bool success = false;
                        if (isEditing) {
                          success = await AdminRepository.instance.updateAboutMe(
                            id: item.id!,
                            contentEn: enController.text,
                            contentBn: bnController.text,
                            filePath: pickedImagePath,
                          );
                        } else {
                          success = await AdminRepository.instance.createAboutMe(
                            contentEn: enController.text,
                            contentBn: bnController.text,
                            filePath: pickedImagePath,
                          );
                        }
                        if (mounted) {
                          setDialogState(() {
                            isSaving = false;
                          });
                          if (dialogCtx.mounted) {
                            Navigator.pop(dialogCtx);
                          }
                          if (success) {
                            ref.invalidate(adminAboutMeListProvider);
                            AppSnackBar.instance.success(
                              isBangla
                                  ? (isEditing ? "সফলভাবে আপডেট হয়েছে" : "সফলভাবে তৈরি হয়েছে")
                                  : (isEditing ? "Successfully updated" : "Successfully created"),
                            );
                          } else {
                            AppSnackBar.instance.error(
                              isBangla ? "সংরক্ষণ ব্যর্থ হয়েছে" : "Failed to save",
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        isBangla ? "সংরক্ষণ করুন" : "Save",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteAboutMeDialog(AboutMeModel item, bool isBangla) {
    if (item.id == null) return;
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          isBangla ? "তথ্য মুছে ফেলবেন?" : "Delete About Me",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: Text(
          isBangla
              ? "আপনি কি নিশ্চিত যে এই তথ্যটি মুছে ফেলতে চান?"
              : "Are you sure you want to delete this About Me item?",
          style: const TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              isBangla ? "বাতিল" : "Cancel",
              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              final success = await AdminRepository.instance.deleteAboutMe(item.id!);
              if (mounted) {
                if (success) {
                  ref.invalidate(adminAboutMeListProvider);
                  AppSnackBar.instance.success(
                    isBangla ? "সফলভাবে মুছে ফেলা হয়েছে" : "Deleted successfully",
                  );
                } else {
                  AppSnackBar.instance.error(
                    isBangla ? "মুছে ফেলতে ব্যর্থ হয়েছে" : "Failed to delete",
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
