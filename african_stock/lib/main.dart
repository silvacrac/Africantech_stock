import 'package:african_stock/obras/telas/tela_agenda_global.dart';
import 'package:african_stock/obras/telas/tela_lista_funcionarios.dart';
import 'package:african_stock/obras/telas/tela_lista_projetos.dart';
import 'package:african_stock/provincias/telas/tela_lista_provincias.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
// Importações das tuas telas (mantém as que já tens)
import 'autenticacao/telas/tela_login.dart';
import 'painel_principal/telas/tela_painel_principal.dart';
import 'materiais/telas/tela_lista_materiais.dart';
import 'movimentos_stock/telas/tela_registar_saida.dart';
import 'transferencias_stock/telas/tela_transferir_stock.dart';
import 'historico/telas/tela_historico_geral.dart';
import 'notificacoes/telas/tela_notificacoes.dart';
import 'perfil/telas/tela_perfil.dart';
import 'documentos/telas/tela_visualizar_pdf.dart';
import 'nucleo/constantes/constantes_cores.dart';
import 'nucleo/constantes/constantes_rotas.dart';
import 'nucleo/constantes/constantes_textos.dart';

// 1. CONTROLADOR DE TEMA GLOBAL
final ValueNotifier<ThemeMode> temaAtual = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null); 
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const SistemaGestaoStock());
}

class SistemaGestaoStock extends StatelessWidget {
  const SistemaGestaoStock({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. O ValueListenableBuilder reconstrói o app quando o tema muda
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: temaAtual,
      builder: (_, mode, __) {
        return MaterialApp(
          title: TextosApp.nomeApp,
          debugShowCheckedModeBanner: false,
          themeMode: mode, // Usa o modo selecionado pelo utilizador

          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primaryColor: CoresApp.primaria,
            scaffoldBackgroundColor: CoresApp.fundoClaro,
            cardColor: CoresApp.cardClaro,
            fontFamily: 'Inter',
            colorScheme: const ColorScheme.light(primary: CoresApp.primaria),
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primaryColor: CoresApp.primaria,
            scaffoldBackgroundColor: CoresApp.fundoEscuro,
            cardColor: CoresApp.cardEscuro,
            fontFamily: 'Inter',
            colorScheme: const ColorScheme.dark(primary: CoresApp.primaria),
          ),

          initialRoute: RotasApp.login,
          routes: {
            RotasApp.login: (context) => const TelaLogin(),
            RotasApp.dashboard: (context) => const TelaPainelPrincipal(),
            RotasApp.listaMateriais: (context) => const TelaListaMateriais(),
            RotasApp.registarSaida: (context) => const TelaRegistarSaida(),
            RotasApp.transferirStock: (context) => const TelaTransferirStock(),
            RotasApp.historicoGeral: (context) => const TelaHistoricoGeral(),
            RotasApp.visualizarPdf: (context) => const TelaVisualizarPdf(),
            RotasApp.perfil: (context) => const TelaPerfil(),
            RotasApp.notificacoes: (context) => const TelaNotificacoes(),
            RotasApp.projetos: (context) => const TelaListaProjetos(),
            RotasApp.equipas: (context) => const TelaListaFuncionarios(),
            RotasApp.agenda : (context) => const TelaAgendaGlobal(),
            RotasApp.provincias: (context) => const TelaListaProvincias(),
          },
        );
      },
    );
  }
}