import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_text_field.dart';

class AppointmentForm extends StatelessWidget {
  const AppointmentForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lightGreen = AppColors.instance.lightGreen;
    final primaryGreen = AppColors.instance.primaryGreen;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            "For Appointment",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            "Please fill out the form below",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 20),
          const CustomTextField(hint: "Name *"),
          const SizedBox(height: 12),
          const CustomTextField(hint: "Mobile No *"),
          const SizedBox(height: 12),
          const CustomTextField(hint: "Email"),
          const SizedBox(height: 12),
          const CustomTextField(hint: "Subject *"),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text("Select Branch"),
                items: ["Dhaka", "Sylhet", "Chittagong"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
            ),
          ),
          const SizedBox(height: 12),
          const CustomTextField(hint: "Your comments (if any)", maxLines: 3),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                child: const Text("Submit", style: TextStyle(color: Colors.white)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
