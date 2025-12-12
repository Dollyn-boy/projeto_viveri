// lib/core/widgets/viveri_logo.dart

import 'package:flutter/material.dart';

class ViveriLogo extends StatelessWidget {
  const ViveriLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/viveri_logo.png',
      height: 172, 
    );
  }
}