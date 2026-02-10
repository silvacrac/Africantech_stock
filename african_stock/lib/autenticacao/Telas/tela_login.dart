import 'package:african_stock/nucleo/constantes/constantes_rotas.dart';
import 'package:flutter/material.dart';
import '../../nucleo/constantes/constantes_cores.dart';
import '../../nucleo/constantes/constantes_textos.dart';
import '../../nucleo/componentes/botao_padrao.dart';
import '../../nucleo/componentes/campo_texto_padrao.dart';
import '../../nucleo/utilitarios/validadores.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;

  void _fazerLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _carregando = true);
      
      // Simulação de delay de rede
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() => _carregando = false);
      
      // Aqui iremos navegar para o Dashboard na próxima etapa
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login efetuado com sucesso!')),
        
      );
      Navigator.pushReplacementNamed(context, RotasApp.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                
                // Espaço para Logo (Africantech)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: CoresApp.primaria,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: CoresApp.primaria.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: const Icon(Icons.inventory_2, size: 40, color: Colors.white),
                ),
                
                const SizedBox(height: 24),
                const Text(
                  TextosApp.nomeApp,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const Text(
                  TextosApp.loginBoasVindas,
                  style: TextStyle(color: CoresApp.textoSecundario),
                ),
                
                const SizedBox(height: 48),
                
                CampoTextoPadrao(
                  label: "Email Profissional",
                  hint: "operacoes@africantech.co.mz",
                  controller: _emailController,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                
                const SizedBox(height: 20),
                
                CampoTextoPadrao(
                  label: "Palavra-passe",
                  hint: "••••••••",
                  controller: _senhaController,
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                ),
                
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {}, // Tela de recuperar senha
                    child: const Text("Esqueceu-se da palavra-passe?"),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                BotaoPadrao(
                  texto: TextosApp.btnEntrar,
                  carregando: _carregando,
                  icone: Icons.login,
                  onPressed: _fazerLogin,
                ),
                
                const SizedBox(height: 40),
                
                // Footer
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.public, size: 14, color: CoresApp.textoSecundario),
                    SizedBox(width: 8),
                    Text(
                      "INFRAESTRUTURA MULTI-PROVINCIAL",
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                        color: CoresApp.textoSecundario,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}