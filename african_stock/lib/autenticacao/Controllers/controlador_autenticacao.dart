import 'package:flutter/material.dart';
import '../../obras/modelos/funcionario.dart';

class ControladorAutenticacao extends ChangeNotifier {
  static final ControladorAutenticacao instancia = ControladorAutenticacao._internal();
  ControladorAutenticacao._internal();

  Funcionario? _funcionarioLogado;
  Funcionario? get funcionarioLogado => _funcionarioLogado;

  Future<bool> login(String email, String senha) async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulação de base de dados de funcionários
    if (email == "admin@africantech.co.mz") {
      _funcionarioLogado = Funcionario(
        id: "EMP001",
        nome: "Alex Johnson",
        email: email,
        funcao: "Gestor de Operações",
        provincia: "Maputo",
        tipo: TipoAcesso.admin, // PERMISSÃO TOTAL
        telefone: "840000000",
      );
    } else {
      _funcionarioLogado = Funcionario(
        id: "EMP002",
        nome: "Ricardo Matsinhe",
        email: email,
        funcao: "Técnico de Campo",
        provincia: "Gaza",
        tipo: TipoAcesso.operacional, // PERMISSÃO LIMITADA
        telefone: "820000000",
      );
    }
    
    notifyListeners();
    return true;
  }

  void logout() {
    _funcionarioLogado = null;
    notifyListeners();
  }
}