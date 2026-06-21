import 'package:flutter/material.dart';
import '../../../res/app_colors.dart';
import '../../../utils/textstyle.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'Rohan Sharma');
  final _emailController = TextEditingController(text: 'rohan@example.com');
  final _bioController = TextEditingController(text: 'Avid reader & audiobook enthusiast.');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.navyMid(context),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.navyLight(context)),
                      ),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textMuted(context), size: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Edit Profile',
                      style: text24(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary(context),
                          context: context)),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    // Avatar Section
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.accent.withOpacity(0.4),
                                  width: 3),
                            ),
                            child: Center(
                              child: Text(
                                'R',
                                style: text30(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy(context),
                                  context: context,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.navy(context), width: 2),
                              ),
                              child: Icon(Icons.camera_alt_rounded,
                                  color: AppColors.navy(context), size: 14),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Form Fields
                    _buildField(context, 'Full Name', _nameController, Icons.person_outline_rounded),
                    const SizedBox(height: 14),
                    _buildField(context, 'Email Address', _emailController, Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 14),
                    _buildField(context, 'Bio', _bioController, Icons.edit_note_rounded,
                        maxLines: 3),

                    const SizedBox(height: 28),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.navy(context),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Save Changes',
                          style: text15(
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy(context),
                            context: context,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(BuildContext context, String label, TextEditingController controller, IconData icon,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Text(label.toUpperCase(),
              style: text12(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted(context),
                  context: context)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.navyMid(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.navyLight(context)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: text14(
              color: AppColors.textPrimary(context),
              context: context,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.textMuted(context), size: 18),
              border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
