import 'package:flutter/material.dart';
import 'package:viveri/constants/theme/app_colors.dart';
import 'package:viveri/constants/theme/text_styles.dart';

class ProfileBaseLayout extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileBaseLayout({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 428,
            maxHeight: double.infinity,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 93,
                  color: AppColors.header,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 26,
                        top: 40,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: AppColors.primaria,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 12,
                                color: AppColors.amarelo,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headerTitle,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          ...children,
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0, top: 10.0),
                  child: Text("Version 1.5", style: AppTextStyles.infoValue),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.sectionTitle);
  }
}

class InfoBlock extends StatelessWidget {
  final String label;
  final String value;

  const InfoBlock({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.infoLabel),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(value, style: AppTextStyles.infoValue),
        ),
      ],
    );
  }
}

class ProfileDivider extends StatelessWidget {
  const ProfileDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      color: Colors.black.withValues(alpha: 0.21),
    );
  }
}

class ActionLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ActionLink({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(text, style: AppTextStyles.link),
    );
  }
}

class DocumentField extends StatefulWidget {
  final String label;
  final String value;

  const DocumentField({super.key, required this.label, required this.value});

  @override
  State<StatefulWidget> createState() => _DocumentFieldState();
}

class _DocumentFieldState extends State<DocumentField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.label, style: AppTextStyles.infoLabel),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isObscured = !_isObscured),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: AppColors.infoDoc,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isObscured
                          ? "•" * (widget.value.length > 14 ? 18 : 14)
                          : widget.value,
                      style: AppTextStyles.infoLabel.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColor,
                        letterSpacing: _isObscured ? 2 : 0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Icon(
                      _isObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
