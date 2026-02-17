import 'package:flutter/material.dart';
import '../../obras/modelos/funcionario.dart';
import '../../nucleo/servicos/api_service.dart';

class ControladorAutenticacao extends ChangeNotifier {
  // Instância Singleton para acesso global
  static final ControladorAutenticacao instancia = ControladorAutenticacao._internal();
  ControladorAutenticacao._internal();

  Funcionario? _funcionarioLogado;
  Funcionario? get funcionarioLogado => _funcionarioLogado;

  // Realiza o login conectando ao Banco de Dados Real (Node.js + MySQL)
  Future<bool> login(String email, String senha) async {
    try {
      // 1. Chamada ao Serviço de API
      final resultado = await ApiService().login(email, senha);

      if (resultado['sucesso'] == true) {
        // O seu backend Node costuma devolver os dados dentro de 'usuario' ou 'dados'
        // Verifique se no seu Node.js o retorno é { sucesso: true, dados: {...} }
        final dados = resultado['dados'];

        // 2. Mapeamento dos dados vindos do MySQL para o Modelo Flutter
        _funcionarioLogado = Funcionario(
          id: dados['id'].toString(),
          nome: dados['nome'] ?? "Utilizador",
          email: dados['email'] ?? email,
          funcao: dados['funcao'] ?? "Colaborador",
          provincia: dados['provincia_nome'] ?? "Geral", 
          
          // CONVERSÃO DO ENUM: 
          // O MySQL devolve 'admin', 'responsavel' ou 'operacional'.
          // Mapeamos 'admin' para TipoAcesso.admin, o resto para operacional.
          tipo: (dados['tipo_acesso'] == 'admin' || dados['tipo'] == 'admin') 
                ? TipoAcesso.admin 
                : TipoAcesso.operacional,
          
          telefone: dados['telefone'] ?? "",
          fotoUrl: dados['foto_perfil'], // Pega o caminho da imagem se existir
        );

        // 3. Notifica todas as telas (Dashboard, Listas, etc) para se atualizarem
        notifyListeners();
        
        debugPrint("SISTEMA: Usuário ${_funcionarioLogado!.nome} logado!");
        debugPrint("NÍVEL DE ACESSO: ${_funcionarioLogado!.tipo}");
        
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("ERRO CONTROLADOR LOGIN: $e");
      rethrow; 
    }
  }

  // Finaliza a sessão e limpa os dados da memória
  void logout() {
    _funcionarioLogado = null;
    notifyListeners();
  }
}