import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../nucleo/constantes/constantes_rotas.dart';

class TelaSplash extends StatefulWidget {
  const TelaSplash({super.key});

  @override
  State<TelaSplash> createState() => _TelaSplashState();
}

class _TelaSplashState extends State<TelaSplash> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Navegação após a animação (4.5 segundos)
    Timer(const Duration(milliseconds: 4500), () {
      if (mounted) Navigator.pushReplacementNamed(context, RotasApp.login);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001122),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. RADAR TECNOLÓGICO DE FUNDO
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: RadarPainter(_controller.value),
                child: Container(),
              );
            },
          ),

          // 2. CONTEÚDO CENTRAL (Logo e Texto)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder(
                duration: const Duration(seconds: 2),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.8 + (value * 0.2),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF137FEC).withOpacity(0.5),
                              blurRadius: 40 * value,
                              spreadRadius: 10 * value,
                            )
                          ],
                        ),
                        child: Image.asset(
                          'assets/imagens/logo.png',
                          width: 110,
                          height: 110,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              const Text(
                "SISTEMA INTELIGENTE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "LOGÍSTICA & STOCK",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// DESENHADOR DO RADAR (CORRIGIDO)
class RadarPainter extends CustomPainter {
  final double animationValue;
  RadarPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.height / 2);
    
    // 1. Círculos concêntricos (Ondas)
    var wavePaint = Paint()
      ..color = const Color(0xFF137FEC).withOpacity(1.0 - animationValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      double radius = (size.width * 0.7) * ((animationValue + i / 3) % 1);
      canvas.drawCircle(center, radius, wavePaint);
    }

    // 2. Efeito de Varredura (Scanner)
    var scanPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          Colors.transparent,
          const Color(0xFF137FEC).withOpacity(0.4),
        ],
        stops: const [0.75, 1.0],
        transform: GradientRotation(animationValue * 2 * math.pi),
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.4));

    canvas.drawCircle(center, size.width * 0.4, scanPaint);
  }

  @override
  bool shouldRepaint(RadarPainter oldDelegate) => true;
}