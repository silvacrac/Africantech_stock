import 'package:flutter/material.dart';
import '../constantes/constantes_cores.dart';

class CampoTextoPadrao extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final IconData? prefixIcon;
  final TextInputType keyboardType;

  const CampoTextoPadrao({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<CampoTextoPadrao> createState() => _CampoTextoPadraoState();
}

class _CampoTextoPadraoState extends State<CampoTextoPadrao> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(widget.label, 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        TextField(
          controller: widget.controller,
          obscureText: _isObscured,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.hint,
            filled: true,
            fillColor: isDark ? CoresApp.cardEscuro : Colors.white,
            prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: CoresApp.primaria) : null,
            suffixIcon: widget.obscureText 
              ? IconButton(
                  icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                )
              : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: isDark ? CoresApp.bordaEscuro : CoresApp.borda),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: isDark ? CoresApp.bordaEscuro : CoresApp.borda),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: CoresApp.primaria, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}