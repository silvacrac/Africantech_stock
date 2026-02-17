import 'dart:convert';
import 'dart:io';
import 'package:african_stock/nucleo/configuracoes/config_ambiente.dart';
import 'package:http/http.dart' as http;
import '../seguranca/gestor_token.dart';

class ApiService {
  // IP do Servidor Node.js
  static const String _urlBase = "http://192.168.1.220:3000/api/v1";

  // Helper para Headers com Token
  Future<Map<String, String>> _getHeaders() async {
    final token = await GestorToken.obterToken();
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // 1. LOGIN REAL
  Future<Map<String, dynamic>> login(String email, String senha) async {
    final url = Uri.parse("$_urlBase/login");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email.trim(), "senha": senha.trim()}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['sucesso']) {
        await GestorToken.salvarToken(data['token']);
        return data;
      } else {
        throw data['mensagem'] ?? "Erro nas credenciais";
      }
    } catch (e) {
      throw "Falha de conexão: $e";
    }
  }
Future<Map<String, dynamic>> obterDadosDashboard() async {
  final url = Uri.parse("$_urlBase/dashboard/resumo");
  try {
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) return jsonDecode(response.body);
    return {"sucesso": false};
  } catch (e) {
    return {"sucesso": false};
  }
}

Future<List<dynamic>> obterCategorias() async {
  final url = Uri.parse("$_urlBase/categorias");
  final response = await http.get(url, headers: await _getHeaders());
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['dados'];
  }
  return [];
}

Future<Map<String, dynamic>> obterHistoricoGeral() async {
  final url = Uri.parse("$_urlBase/historico"); 
  try {
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {"sucesso": false, "dados": []};
  } catch (e) {
    return {"sucesso": false, "dados": []};
  }
}
  // 2. STOCK PAGINADO (Módulo 2)
  Future<Map<String, dynamic>> obterStockPaginado({
    int pagina = 1,
    String busca = "",
    String categoria = "Todos"
  }) async {
    final url = Uri.parse("$_urlBase/stock?page=$pagina&limit=15&busca=$busca&categoria=$categoria");
    try {
      final response = await http.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw "Erro ao carregar stock";
    } catch (e) {
      throw "Erro de rede: $e";
    }
  }

  // 1. Gravar Entrada Rápida (Lista de Checkboxes)
 Future<bool> registarEntradaRapida(List<Map<String, dynamic>> itens) async {
    final url = Uri.parse("$_urlBase/movimentos/entrada");
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode({
          "itens": itens, // Aqui o backend receberá o array dentro da chave 'itens'
          "observacoes": "Reposição de stock via Entrada Rápida"
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

   // 2. Novo Método: Criar Material Individual 
  Future<bool> criarMaterial(Map<String, dynamic> dados) async {
    final url = Uri.parse("$_urlBase/materiais");
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(dados),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

// 2. Criar Categoria Manual
Future<bool> criarCategoria(String nome) async {
  final url = Uri.parse("${ConfigApi.baseUrl}/categorias");
  final response = await http.post(
    url,
    headers: await _getHeaders(),
    body: jsonEncode({"nome": nome}),
  );
  return response.statusCode == 200;
}

  // 3. MOVIMENTOS: SAÍDA MULTI-MATERIAL (Módulo 5.7)
  Future<bool> registarSaida({
    required String codigoGuia,
    required int projetoId,
    required String observacoes,
    required List<Map<String, dynamic>> materiais,
  }) async {
    final url = Uri.parse("$_urlBase/movimentos/saida");
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode({
          "codigo_guia": codigoGuia,
          "projeto_id": projetoId,
          "observacoes": observacoes,
          "materiais": materiais,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // 4. PROJETOS / TRABALHOS (Módulo 3)
  Future<List<dynamic>> obterProjetos() async {
    final url = Uri.parse("$_urlBase/projetos");
    try {
      final response = await http.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['dados'];
      }
      return [];
    } catch (e) {
      throw "Erro ao carregar projetos: $e";
    }
  }

  // 5. EQUIPAS / FUNCIONÁRIOS (Módulo 4)
  Future<List<dynamic>> obterFuncionarios({String? provincia}) async {
    String query = provincia != null ? "?provincia=$provincia" : "";
    final url = Uri.parse("$_urlBase/funcionarios$query");
    try {
      final response = await http.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['dados'];
      }
      return [];
    } catch (e) {
      throw "Erro ao carregar equipas: $e";
    }
  }

  // 6. PROVÍNCIAS / LOCAIS (Módulo 6)
  Future<List<dynamic>> obterProvincias() async {
    final url = Uri.parse("$_urlBase/provincias");
    try {
      final response = await http.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['dados'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // 7. UPLOAD DE FOTO DE PERFIL
  Future<bool> atualizarFotoPerfil(File imagem) async {
    final url = Uri.parse("$_urlBase/update-profile-photo");
    final token = await GestorToken.obterToken();
    
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({"Authorization": "Bearer $token"});
      request.files.add(await http.MultipartFile.fromPath('foto', imagem.path));
      
      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}