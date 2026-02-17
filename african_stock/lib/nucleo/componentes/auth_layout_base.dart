import 'dart:async';
import 'package:flutter/material.dart';
import '../constantes/constantes_cores.dart';

class AuthLayoutBase extends StatefulWidget {
  final Widget formulario;
  final Widget? widgetAdicional; // Aqui entra a Biometria
  final List<Map<String, String>> slides;

  const AuthLayoutBase({
    super.key,
    required this.formulario,
    this.widgetAdicional,
    required this.slides,
  });

  @override
  State<AuthLayoutBase> createState() => _AuthLayoutBaseState();
}

class _AuthLayoutBaseState extends State<AuthLayoutBase> {
  final PageController _pageController = PageController();
  int _paginaAtual = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      if (_pageController.hasClients) {
        if (_paginaAtual < widget.slides.length - 1) {
          _paginaAtual++;
        } else {
          _paginaAtual = 0;
        }
        _pageController.animateToPage(
          _paginaAtual,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF101922) : Colors.white,
      body: Column(
        children: [
          _buildHeader(isDark),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildSlideshow(),
                  widget.formulario,
                  if (widget.widgetAdicional != null) widget.widgetAdicional!,
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/imagens/logo.png',
                    height: 35,
                    errorBuilder: (c, e, s) => const Icon(
                      Icons.inventory_2,
                      color: CoresApp.primaria,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "PT",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _iconTop(Icons.lock_person_outlined, () {}),
              _iconTop(Icons.location_on_outlined, () {}),
              _iconTop(Icons.smartphone_outlined, () {}),
              _iconTop(Icons.swap_horiz_rounded, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconTop(IconData icon, VoidCallback tap) => IconButton(
    icon: Icon(icon, color: CoresApp.primaria, size: 28),
    onPressed: tap,
  );

  Widget _buildSlideshow() {
    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.slides.length,
            onPageChanged: (index) => setState(() => _paginaAtual = index),
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.slides[index]["img"]!,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        Container(color: CoresApp.primaria),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CoresApp.primaria.withOpacity(0.85),
                          Colors.transparent,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.slides[index]["titulo"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.slides[index]["sub"]!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 15,
            right: 20,
            child: Row(
              children: List.generate(
                widget.slides.length,
                (index) => Container(
                  margin: const EdgeInsets.only(left: 4),
                  width: _paginaAtual == index ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(
                      _paginaAtual == index ? 1 : 0.4,
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hub_outlined, size: 14, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                "REDE MULTI-PROVINCIAL",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            "v3.2.1-premium",
            style: TextStyle(fontSize: 8, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
