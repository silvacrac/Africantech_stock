import 'dart:io';
import 'package:african_stock/nucleo/controladores/controlador_utilizador.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../main.dart'; 
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/constantes/constantes_rotas.dart';
import '../../nucleo/componentes/card_padrao.dart';
import '../../nucleo/componentes/base_scaffold.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final ImagePicker _picker = ImagePicker();

  // Função para carregar foto da galeria
  Future<void> _alterarFoto() async {
    final XFile? imagem = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (imagem != null) {
      // Atualiza a variável global definida no main.dart
      fotoPerfilGlobal.value = File(imagem.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseScaffold(
      indexAtivo: 3, // Aba CONFIG ativa
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. SEÇÃO DE PERFIL (AVATAR GRANDE)
            _buildAvatarGrande(isDark),

            const SizedBox(height: 32),

            // 2. CONFIGURAÇÕES DE SISTEMA (TEMA)
            _buildSecaoTitulo("SISTEMA"),
            _buildToggleTema(isDark),

            const SizedBox(height: 24),

            // 3. MENUS DE CONTA
            _buildSecaoTitulo("CONTA E SEGURANÇA"),
            _buildItemMenu(
              context,
              "Editar Perfil",
              Icons.person_outline_rounded,
              onTap: () {},
            ),
            _buildItemMenu(
              context,
              "Alterar Palavra-passe",
              Icons.lock_reset_rounded,
              onTap: () {},
            ),
            _buildItemMenu(
              context,
              "Histórico de Acessos",
              Icons.shield_outlined,
              onTap: () =>
                  Navigator.pushNamed(context, RotasApp.historicoGeral),
            ),

            const SizedBox(height: 24),

            // 4. SUPORTE E APP
            _buildSecaoTitulo("SUPORTE"),
            _buildItemMenu(
              context,
              "Centro de Ajuda",
              Icons.help_outline_rounded,
              onTap: () {},
            ),
            _buildItemMenu(
              context,
              "Termos e Privacidade",
              Icons.description_outlined,
              onTap: () {},
            ),

            const SizedBox(height: 40),

            // 5. BOTÃO DE LOGOUT
            _buildBotaoSair(context),

            const SizedBox(height: 20),
            const Text(
              "Africantech Stock",
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 120), // Espaço para não cobrir pela Nav Bar
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarGrande(bool isDark) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            ValueListenableBuilder<File?>(
              valueListenable: fotoPerfilGlobal,
              builder: (context, foto, _) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: CoresApp.primaria, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: CoresApp.primaria.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: foto != null
                        ? Image.file(foto, fit: BoxFit.cover)
                        : Container(
                            color: isDark ? CoresApp.cardEscuro : Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 70,
                              color: CoresApp.primaria.withOpacity(0.4),
                            ),
                          ),
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: _alterarFoto,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: CoresApp.primaria,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "Eduardo da Silva",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Text(
          "Tecnico de Informatica • Admin",
          style: TextStyle(
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleTema(bool isDark) {
    return CardPadrao(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(
            isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            color: CoresApp.primaria,
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              "Modo Escuro",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Switch(
            value: isDark,
            activeColor: CoresApp.primaria,
            onChanged: (bool value) {
              temaAtual.value = value ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemMenu(
    BuildContext context,
    String titulo,
    IconData icone, {
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CardPadrao(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icone, color: CoresApp.primaria, size: 22),
            const SizedBox(width: 16),
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecaoTitulo(String t) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
        child: Text(
          t,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildBotaoSair(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF4444).withOpacity(0.1),
          foregroundColor: const Color(0xFFEF4444),
          elevation: 0,
          padding: const EdgeInsets.all(18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: BorderSide(color: const Color(0xFFEF4444).withOpacity(0.2)),
        ),
        onPressed: () =>
            Navigator.pushReplacementNamed(context, RotasApp.login),
        icon: const Icon(Icons.logout_rounded),
        label: const Text(
          "TERMINAR SESSÃO",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),
    );
  }
}
