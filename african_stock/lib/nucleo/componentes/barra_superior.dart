import 'package:flutter/material.dart';
import 'dart:ui';

class BarraSuperior extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final List<Widget>? acoes;
  final bool mostrarVoltar;

  const BarraSuperior({
    super.key,
    required this.titulo,
    this.acoes,
    this.mostrarVoltar = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
          elevation: 0,
          leading: mostrarVoltar 
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              )
            : null,
          actions: acoes,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}