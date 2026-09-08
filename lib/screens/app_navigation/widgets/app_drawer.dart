import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
            decoration: BoxDecoration(color: AppColors.instance.primaryGreen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text(
                            "Monday, August 31, 2026",
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const _LanguageToggle(),
                  ],
                ),
                const SizedBox(height: 24),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.gavel, color: AppColors.instance.primaryGreen, size: 36),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Barrister Kayser Kamal",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text("Secondary Categories", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.phone,
                  title: "Contact",
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    context.go('/contact_screen');
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.calendar,
                  title: "Appointment",
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    context.go('/appointment_screen');
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.exclamationmark_bubble,
                  title: "Complaint",
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    context.go('/complain_screen');
                  },
                ),
                _buildDrawerDropdown(
                  context: context,
                  icon: CupertinoIcons.building_2_fill,
                  title: "Development Works",
                  children: [
                    _buildSubDrawerItem(
                      context: context,
                      title: "Kalmakanda Upazila",
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/kalmakanda_upazila_screen');
                      },
                    ),
                    _buildSubDrawerItem(
                      context: context,
                      title: "Durgapur Upazila",
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/durgapur_upazila_screen');
                      },
                    ),
                    _buildSubDrawerItem(
                      context: context,
                      title: "Others",
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/others_screen');
                      },
                    ),
                  ],
                ),
                _buildDrawerDropdown(
                  context: context,
                  icon: CupertinoIcons.news,
                  title: "Media",
                  children: [
                    _buildSubDrawerItem(
                      context: context,
                      title: "Print Media",
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/print_media_screen');
                      },
                    ),
                    _buildSubDrawerItem(
                      context: context,
                      title: "Electronic Media",
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/electronic_media_screen');
                      },
                    ),
                  ],
                ),
                const Divider(),
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.doc_text,
                  title: "Terms and Conditions",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.shield,
                  title: "Privacy Policy",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.question_circle,
                  title: "FAQ",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // App Version
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text("Version 1.0.0", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.instance.primaryGreen, size: 24),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      onTap: onTap,
    );
  }

  Widget _buildDrawerDropdown({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: AppColors.instance.primaryGreen, size: 24),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        iconColor: Colors.grey[400],
        collapsedIconColor: Colors.grey[400],
        tilePadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
        children: children,
      ),
    );
  }

  Widget _buildSubDrawerItem({required BuildContext context, required String title, required VoidCallback onTap}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[800]),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[300]),
      contentPadding: const EdgeInsets.only(left: 64.0, right: 24.0, top: 0.0, bottom: 0.0),
      onTap: onTap,
    );
  }
}

class _LanguageToggle extends StatefulWidget {
  const _LanguageToggle({super.key});

  @override
  State<_LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<_LanguageToggle> {
  String _selectedLang = 'Eng';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                setState(() => _selectedLang = 'Eng');
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _selectedLang == 'Eng' ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "Eng",
                  style: TextStyle(
                    color: _selectedLang == 'Eng' ? AppColors.instance.primaryGreen : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() => _selectedLang = 'বাংলা');
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _selectedLang == 'বাংলা' ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "বাংলা",
                  style: TextStyle(
                    color: _selectedLang == 'বাংলা' ? AppColors.instance.primaryGreen : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
