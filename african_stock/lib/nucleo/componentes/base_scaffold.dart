import 'package:flutter/material.dart';
import '../constantes/constantes_cores.dart';
import '../constantes/constantes_rotas.dart';
import '../controladores/controlador_utilizador.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final int indexAtivo;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final List<Widget>? acoesAppBar;
  final String? tituloCustom;

  const BaseScaffold({
    super.key,
    required this.body,
    required this.indexAtivo,
    this.appBar,
    this.floatingActionButton,
    this.acoesAppBar,
    this.tituloCustom,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // 1. CABEÇALHO PADRÃO (Avatar Esq. | Logo Centro | Notificações Dir.)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 70,
        // AVATAR NO CANTO SUPERIOR ESQUERDO
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
          child: ValueListenableBuilder(
            valueListenable: fotoPerfilGlobal,
            builder: (context, foto, _) {
              return GestureDetector(
                onTap: () {
                  if (indexAtivo != 3)
                    Navigator.pushReplacementNamed(context, RotasApp.perfil);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: indexAtivo == 3
                          ? CoresApp.primaria
                          : Colors.grey.withOpacity(0.5),
                      width: 1.5,
                    ),
                    color: CoresApp.primaria.withOpacity(0.1),
                  ),
                  child: ClipOval(
                    child: foto != null
                        ? Image.file(foto, fit: BoxFit.cover)
                        : Icon(
                            Icons.person,
                            color: isDark ? Colors.white : CoresApp.primaria,
                            size: 20,
                          ),
                  ),
                ),
              );
            },
          ),
        ),
        // LOGO DA EMPRESA NO CENTRO
        title: tituloCustom != null
            ? Text(
                tituloCustom!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            : SizedBox(
                height: 35,
                child: Image.asset(
                  'assets/imagens/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.inventory_2, color: CoresApp.primaria),
                ),
              ),
        // NOTIFICAÇÕES NO CANTO DIREITO
        actions:
            acoesAppBar ??
            [
              IconButton(
                icon: Icon(
                  Icons.notifications_none_rounded,
                  color: isDark ? Colors.white : const Color(0xFF64748B),
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, RotasApp.notificacoes),
              ),
              const SizedBox(width: 8),
            ],
      ),

      body: body,

      // 2. BOTÃO FLUTUANTE (SCANNER QR)
      floatingActionButton:
          floatingActionButton ??
          FloatingActionButton(
            backgroundColor: CoresApp.primaria,
            elevation: 8,
            shape: const CircleBorder(
              side: BorderSide(color: Colors.white, width: 4),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("A abrir Scanner QR...")),
              );
            },
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      extendBody: true,

      // 3. MENU INFERIOR REUTILIZÁVEL
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        height: 70,
        decoration: BoxDecoration(
          color: isDark
              ? CoresApp.cardEscuro.withOpacity(0.95)
              : Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.5 : 0.1),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, Icons.home_filled, "HOME", 0, RotasApp.dashboard),
            _navItem(
              context,
              Icons.inventory,
              "STOCK",
              1,
              RotasApp.listaMateriais,
            ),
            const SizedBox(width: 40), // Espaço para o botão central
            _navItem(
              context,
              Icons.history_rounded,
              "HISTÓRICO",
              2,
              RotasApp.historicoGeral,
            ),
            _navItem(
              context,
              Icons.settings_rounded,
              "CONFIG",
              3,
              RotasApp.perfil,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    String rota,
  ) {
    bool ativo = indexAtivo == index;
    return GestureDetector(
      onTap: () {
        if (indexAtivo != index) {
          // Usamos pushReplacementNamed para as abas principais para evitar pilhas infinitas
          Navigator.pushReplacementNamed(context, rota);
        }
      },
      child: Container(
        color: Colors.transparent, // Aumenta a área de clique
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: ativo ? CoresApp.primaria : const Color(0xFF94A3B8),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: ativo ? CoresApp.primaria : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
