class ConfigApi {
  static const String baseUrl = "http://192.168.1.220:3000/api/v1";

  // Endpoints constantes
  static const String login = "$baseUrl/login";
  static const String stock = "$baseUrl/stock";
  static const String categorias = "$baseUrl/categorias";
  static const String importarExcel = "$baseUrl/materiais/import-excel";
  static const String movimentosSaida = "$baseUrl/movimentos/saida";
  static const String movimentosEntrada = "$baseUrl/movimentos/entrada";
  static const String projetos = "$baseUrl/projetos";
  static const String funcionarios = "$baseUrl/funcionarios";
  static const String provincias = "$baseUrl/provincias";
}