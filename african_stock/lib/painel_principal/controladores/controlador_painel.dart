import 'package:flutter/material.dart';

class ControladorPainel extends ChangeNotifier {
  // Dados Mockados para visualização imediata
  double stockTotalGeral = 45200;
  double stockProvincialAtual = 12400;
  int transferenciasInbound = 5;
  int alertasStockBaixo = 12;

  final List<Map<String, dynamic>> movimentosRecentes = [
    {
      "item": "Varão de Aço X-102",
      "data": "Hoje, 14:15",
      "tipo": "ENTRADA",
      "quantidade": "+250",
      "cor": "sucesso"
    },
    {
      "item": "Solvente Industrial B",
      "data": "Hoje, 11:40",
      "tipo": "SAÍDA",
      "quantidade": "-40",
      "cor": "erro"
    },
    {
      "item": "Cabo Condutor (30m)",
      "data": "Ontem",
      "tipo": "TRANSFERÊNCIA",
      "quantidade": "120",
      "cor": "info"
    },
  ];
}