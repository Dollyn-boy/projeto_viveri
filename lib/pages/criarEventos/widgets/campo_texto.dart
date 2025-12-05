import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  final String label;
  final double largura;
  final double? altura;
  final TextEditingController? controller;
  final String? texto;
  final bool readOnly;
  final VoidCallback? onTap;

  const CampoTexto({
    super.key,
    required this.label,
    required this.largura,
    this.altura,
    this.controller,
    this.texto,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      height: altura,
      decoration: BoxDecoration(
        color: const Color(0xFFC1CEBF),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: altura != null ? null : 1,
        expands: altura != null,
        decoration: InputDecoration(
          border: InputBorder.none,
          // Se texto foi passado, mostra ele
          hintText: texto,
        ),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}