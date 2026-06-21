import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_reader/utils/textstyle.dart';

import '../res/app_colors.dart';


void showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 12),

              Text(
                "Success",
                style: text20(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                  context: context,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Your order has been placed successfully.",
                textAlign: TextAlign.center,
                style: text14(
                  color: AppColors.textSecondary(context),
                  context: context,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: text14(
                          color: AppColors.grey900,
                          context: context,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "OK",
                        style: text14(
                          color: AppColors.navy(context),
                          fontWeight: FontWeight.w600,
                          context: context,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showConfirmDialog(BuildContext context) {
  // Add this method inside ProfileScreen class

  Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.navyMid(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Log Out",
        style: text20(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary(context),
          context: context,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        "Are you sure you want to log out?",
        style: text16(
          color: AppColors.textSecondary(context),
          context: context,
        ),
        textAlign: TextAlign.center,
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      actions: [
        Row(
          children: [
            // Cancel Button
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: BorderSide(color: AppColors.textSecondary(context)),
                ),
                child: Text(
                  "Cancel",
                  style: text16(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Logout Button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  // TODO: Add your logout logic here
                  // Example:
                  // Get.find<AuthController>().logout();
                  // Get.offAllNamed('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error, // Red color for logout
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Log Out",
                  style: text16(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    barrierDismissible: true,
  );
}
