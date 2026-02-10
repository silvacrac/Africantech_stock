import 'package:flutter/material.dart';
import '../../movimentos_stock/modelos/movimento_stock.dart';

class ItemHistorico {
  final String id;
  final String titulo;
  final String subtitulo;
  final String quantidade;
  final DateTime data;
  final TipoMovimento tipo;
  final Color corTipo;

  ItemHistorico({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.quantidade,
    required this.data,
    required this.tipo,
    required this.corTipo,
  });
}