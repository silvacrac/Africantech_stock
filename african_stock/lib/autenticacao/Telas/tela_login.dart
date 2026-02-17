import 'package:african_stock/autenticacao/controllers/controlador_autenticacao.dart';
import 'package:african_stock/nucleo/componentes/auth_layout_base.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../nucleo/constantes/constantes_rotas.dart';
import '../../nucleo/componentes/botao_padrao.dart';
import '../../nucleo/constantes/constantes_cores.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final LocalAuthentication _auth = LocalAuthentication();
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _tentarAutoLoginBiometrico();
  }

  // Lógica para lembrar o último utilizador e preencher o campo
  Future<void> _tentarAutoLoginBiometrico() async {
    String? emailSalvo = await _storage.read(key: 'email_logado');
    if (emailSalvo != null) {
      setState(() {
        _emailController.text = emailSalvo;
      });
    }
  }


void _executarLoginReal(String email, String senha) async {
  // VALIDAÇÃO LOCAL ANTES DE IR AO BACKEND
  if (email.isEmpty || senha.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Erro: Introduza o email e a palavra-passe"), backgroundColor: Colors.orange),
    );
    return;
  }

  setState(() => _carregando = true);

  try {
    // Agora passamos a senha real para o controlador
    bool sucesso = await ControladorAutenticacao.instancia.login(email, senha);

    if (sucesso) {
      await _storage.write(key: 'email_logado', value: email);
      // Opcional: só guarde a senha se a biometria estiver ativa
      await _storage.write(key: 'senha_logada', value: senha); 

      if (mounted) Navigator.pushReplacementNamed(context, RotasApp.dashboard);
    } else {
      throw "Credenciais inválidas";
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  } finally {
    if (mounted) setState(() => _carregando = false);
  }
}

  // Lógica de Biometria (Lê do cofre e loga)
  Future<void> _autenticarBiometria() async {
    try {
      final bool podeAutenticar = await _auth.canCheckBiometrics || await _auth.isDeviceSupported(); 
      if (!podeAutenticar) return;

      final bool sucesso = await _auth.authenticate(
        localizedReason: 'Aceda à sua conta African Stock',
        options: const AuthenticationOptions(stickyAuth: true, biometricOnly: false),
      );

      if (sucesso) {
        String? email = await _storage.read(key: 'email_logado');
        String? senha = await _storage.read(key: 'senha_logada');

        if (email != null && senha != null) {
          _executarLoginReal(email, senha);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Faça o primeiro login manual para ativar a biometria")),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Erro biometria: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayoutBase(
      slides: const [
        {
          "titulo": "Segurança no Trabalho",
          "sub": "É obrigatório o uso de EPI para garantir a segurança de todos os colaboradores.",
          "img": "assets/imagens/slide1.jpg",
        },
        {
          "titulo": "Nossa Localização",
          "sub": "Sede na cidade da Beira, ao lado da Escola Primária dos Pioneiros.",
          "img": "assets/imagens/slide2.jpg",
        },
        {
          "titulo": "Materiais Petrolíferos",
          "sub": "Fornecimento com qualidade e compromisso no abastecimento.",
          "img": "assets/imagens/slide3.jpg",
        },
      ],
      formulario: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput("Utilizador", _emailController, Icons.person_outline),
              const SizedBox(height: 16),
              _buildInput("Palavra Passe", _senhaController, Icons.lock_outline, obscure: true),
              const SizedBox(height: 24),
              BotaoPadrao(
                texto: "ENTRAR NO PORTAL",
                carregando: _carregando,
                onPressed: () => _executarLoginReal(_emailController.text, _senhaController.text),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, RotasApp.recuperarSenha),
                child: const Text("Recuperar acesso?",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
      widgetAdicional: Column(
        children: [
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _autenticarBiometria,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      color: Colors.white),
                  child: const Icon(Icons.face, size: 35, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text("ACESSO BIOMÉTRICO",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String hint, TextEditingController ctrl, IconData icon, {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(8)),
      child: TextFormField(
        controller: ctrl,
        obscureText: obscure,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20, color: CoresApp.primaria),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15)),
      ),
    );
  }
}