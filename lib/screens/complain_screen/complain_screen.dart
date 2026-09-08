import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:go_router/go_router.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ComplainScreen extends StatefulWidget {
  const ComplainScreen({super.key});

  @override
  State<ComplainScreen> createState() => _ComplainScreenState();
}

class _ComplainScreenState extends State<ComplainScreen> {
  String? _selectedType = 'Local';
  String? _selectedDivision;
  String? _selectedDistrict;
  String? _selectedUpazila;
  String? _selectedUnion;
  String? _selectedWard;

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;

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
                          "Complain",
                          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
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
                    "Submit your complaint, feedback, or important information using the form below.",
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
                        _buildStatItem("Today Visitor", "1"),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.white30,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        _buildStatItem("Total Visitor", "288"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Form Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryGreen, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Personal Information",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // Name and Mobile
                  _buildTextField("Name", "Name"),
                  const SizedBox(height: 16),
                  _buildTextField("Mobile Number", "Mobile Number"),
                  const SizedBox(height: 16),

                  // Email and Type
                  _buildTextField("Email", "Email"),
                  const SizedBox(height: 16),
                  _buildDropdownField("Type", ["Local", "Foreign"], _selectedType, (val) {
                    setState(() => _selectedType = val);
                  }),

                  const SizedBox(height: 32),
                  const Text(
                    "Address",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // Address Fields
                  _buildDropdownField("Division", ["Select Division"], _selectedDivision, (val) {}),
                  const SizedBox(height: 16),
                  _buildDropdownField("District", ["Select District"], _selectedDistrict, (val) {}),
                  const SizedBox(height: 16),
                  _buildDropdownField("Upazila", ["Select Upazila"], _selectedUpazila, (val) {}),
                  const SizedBox(height: 16),
                  _buildDropdownField("Union/Pourashava", ["Select Union/Pourashava"], _selectedUnion, (val) {}),
                  const SizedBox(height: 16),
                  _buildDropdownField("Select Ward Number", ["Select Ward Number"], _selectedWard, (val) {}),
                  const SizedBox(height: 16),
                  _buildTextField("Village / Mohallah", "Village / Mohallah"),

                  const SizedBox(height: 24),



                  // Message
                  _buildTextField("Message", "Message", maxLines: 5),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text("Discard", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0C4B33), // Darker green
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text("Submit", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
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

  Widget _buildTextField(String label, String hint, {int maxLines = 1, IconData? icon, TextEditingController? controller, VoidCallback? onTap, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onTap: onTap,
          readOnly: readOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: icon != null ? Icon(icon, color: Colors.grey[400], size: 20) : null,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
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

  Widget _buildDropdownField(String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField2<String>(
          isExpanded: true,
          value: items.contains(selectedValue) ? selectedValue : null,
          hint: Text(items.first, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[400])),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
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
          ),
          menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 16)),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
