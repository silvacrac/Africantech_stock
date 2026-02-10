import 'package:flutter/material.dart';
import '../modelos/transferencia_stock.dart';

class ControladorTransferencias extends ChangeNotifier {
  // Simulação de dados vindos da API
  final List<TransferenciaStock> _pendentes = [
    TransferenciaStock(
      id: 'TR-8821',
      materialId: 'MAT-01',
      materialNome: 'Varão de Aço 12mm',
      quantidade: 250,
      origemTipo: 'GERAL',
      destinoTipo: 'PROVINCIAL',
      destinoProvinciaId: 'GAZA',
      status: StatusTransferencia.pendente,
      responsavelOrigem: 'Alex Thompson',
      dataCriacao: DateTime.now().subtract(const Duration(days: 1)),
      numeroDocumento: 'GUIA-2023-001',
    ),
    TransferenciaStock(
      id: 'TR-8845',
      materialId: 'MAT-05',
      materialNome: 'Cimento Portland 50kg',
      quantidade: 100,
      origemTipo: 'PROVINCIAL',
      origemProvinciaId: 'MAPUTO',
      destinoTipo: 'PROVINCIAL',
      destinoProvinciaId: 'GAZA',
      status: StatusTransferencia.pendente,
      responsavelOrigem: 'Marta Silveira',
      dataCriacao: DateTime.now().subtract(const Duration(hours: 5)),
      numeroDocumento: 'GUIA-2023-045',
    ),
  ];

  List<TransferenciaStock> get pendentes => _pendentes;

  void confirmarRecebimento(String id) {
    // Aqui no futuro chamaremos a API
    _pendentes.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}