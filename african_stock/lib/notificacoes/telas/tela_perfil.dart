import 'package:flutter/material.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/constantes/constantes_rotas.dart';
import '../../nucleo/componentes/barra_superior.dart';
import '../../nucleo/componentes/card_padrao.dart';

class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraSuperior(titulo: "Meu Perfil", mostrarVoltar: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildAvatarSection(),
            const SizedBox(height: 40),
            _buildMenuOption("Editar Perfil", Icons.person_outline),
            _buildMenuOption("Configurações da App", Icons.settings_outlined),
            _buildMenuOption("Segurança e Privacidade", Icons.lock_outline),
            const SizedBox(height: 32),
            _buildLogoutButton(context),
            const SizedBox(height: 40),
            const Text("STOCK PRO v2.4.0", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: CoresApp.borda)),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: CoresApp.primaria.withOpacity(0.1),
              child: const Icon(Icons.person, size: 50, color: CoresApp.primaria),
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: CoresApp.primaria, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        const Text("Alex Johnson", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(color: CoresApp.primaria.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
          child: const Text("ADMINISTRADOR", style: TextStyle(color: CoresApp.primaria, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildMenuOption(String titulo, IconData icone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CardPadrao(
        child: Row(
          children: [
            Icon(icone, color: CoresApp.primaria, size: 22),
            const SizedBox(width: 16),
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            const Icon(Icons.chevron_right, color: CoresApp.borda),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(16),
          backgroundColor: CoresApp.erro.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
        ),
        onPressed: () => Navigator.pushReplacementNamed(context, RotasApp.login),
        icon: const Icon(Icons.logout, color: CoresApp.erro),
        label: const Text("Terminar Sessão", style: TextStyle(color: CoresApp.erro, fontWeight: FontWeight.bold)),
      ),
    );
  }
}