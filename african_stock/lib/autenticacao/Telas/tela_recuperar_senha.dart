import 'package:african_stock/nucleo/componentes/auth_layout_base.dart';
import 'package:flutter/material.dart';
import '../../nucleo/componentes/botao_padrao.dart';
import '../../nucleo/constantes/constantes_cores.dart';

class TelaRecuperarSenha extends StatelessWidget {
  const TelaRecuperarSenha({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayoutBase(
      slides: const [
        {
          "titulo": "Segurança de Dados",
          "sub": "A sua conta é protegida por criptografia bancária.",
          "img": "assets/imagens/criptografia.png",
        },
        {
          "titulo": "Recuperação Rápida",
          "sub": "Enviaremos um código de acesso para o seu email.",
          "img": "assets/imagens/verificacao.png",
        },
      ],
      formulario: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Text(
              "INFORME O SEU EMAIL",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildInput("Email Profissional", Icons.email_outlined),
            const SizedBox(height: 24),
            BotaoPadrao(texto: "ENVIAR INSTRUÇÕES", onPressed: () {}),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Voltar ao Login"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 20, color: CoresApp.primaria),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }
}
