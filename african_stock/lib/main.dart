import 'package:african_stock/painel_principal/telas/tela_relatorios_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

// --- NÚCLEO E CONSTANTES ---
import 'nucleo/constantes/constantes_cores.dart';
import 'nucleo/constantes/constantes_rotas.dart';
import 'nucleo/constantes/constantes_textos.dart';

// --- TELAS ---
import 'autenticacao/telas/tela_login.dart';
import 'autenticacao/telas/tela_splash.dart';
import 'autenticacao/telas/tela_recuperar_senha.dart';
import 'painel_principal/telas/tela_painel_principal.dart';
import 'materiais/telas/tela_lista_materiais.dart';
import 'movimentos_stock/telas/tela_registar_saida.dart';
import 'transferencias_stock/telas/tela_transferir_stock.dart';
import 'historico/telas/tela_historico_geral.dart';
import 'notificacoes/telas/tela_notificacoes.dart';
import 'perfil/telas/tela_perfil.dart';
import 'documentos/telas/tela_visualizar_pdf.dart';
import 'obras/telas/tela_lista_projetos.dart';
import 'obras/telas/tela_lista_funcionarios.dart';
import 'obras/telas/tela_agenda_global.dart';
import 'provincias/telas/tela_lista_provincias.dart';

// 1. CONTROLADOR DE TEMA GLOBAL
final ValueNotifier<ThemeMode> temaAtual = ValueNotifier(ThemeMode.light);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialização de Idioma (Português) para datas
  await initializeDateFormatting('pt_BR', null); 

  // Trava orientação do ecrã em modo vertical
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const SistemaGestaoStock());
}

class SistemaGestaoStock extends StatelessWidget {
  const SistemaGestaoStock({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: temaAtual,
      builder: (_, mode, __) {
        return MaterialApp(
          title: TextosApp.nomeApp,
          debugShowCheckedModeBanner: false,
          themeMode: mode, 

          // --- TEMA CLARO (LIGHT) ---
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primaryColor: CoresApp.primaria,
            scaffoldBackgroundColor: CoresApp.fundoClaro,
            cardColor: CoresApp.cardClaro,
            fontFamily: 'Inter',
            appBarTheme: const AppBarTheme(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
            ),
            colorScheme: const ColorScheme.light(
              primary: CoresApp.primaria,
              secondary: CoresApp.acento,
            ),
          ),

          // --- TEMA ESCURO (DARK) ---
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primaryColor: CoresApp.primaria,
            scaffoldBackgroundColor: const Color(0xFF001122), // Fundo Noturno que combina com o Radar
            cardColor: const Color(0xFF1E293B),
            fontFamily: 'Inter',
            appBarTheme: const AppBarTheme(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
            ),
            colorScheme: const ColorScheme.dark(
              primary: CoresApp.primaria,
              secondary: CoresApp.acento,
              background: Color(0xFF001122),
            ),
          ),

          // 2. ROTA INICIAL ALTERADA PARA SPLASH (Para carregar a animação primeiro)
          initialRoute: RotasApp.splash, 

          routes: {
            RotasApp.splash: (context) => const TelaSplash(),
            RotasApp.login: (context) => const TelaLogin(),
            RotasApp.recuperarSenha: (context) => const TelaRecuperarSenha(),
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
            RotasApp.relatoriosAdmin: (context) => const TelaRelatoriosAdmin(),
          },
        );
      },
    );
  }
}