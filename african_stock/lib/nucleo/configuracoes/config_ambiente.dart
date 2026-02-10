class ConfigAmbiente {
  static const String versaoApp = "2.4.0-enterprise";
  static const String urlBaseAPI = "https://api.africantech.stock.com/v1"; 
  static const Duration timeoutAPI = Duration(seconds: 30);
  
  // Flags de configuração
  static const bool usarFirebase = true;
  static const bool logHabilitado = true;
}