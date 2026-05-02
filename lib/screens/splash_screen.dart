import 'package:flutter/material.dart';

import '../widgets/auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _mainController;
  late AnimationController _buttonController;

  late Animation<double> _topFade;
  late Animation<Offset>  _topSlide;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset>  _textSlide;
  late Animation<double> _buttonFade;
  late Animation<Offset>  _buttonSlide;

  bool _showButton = false;

  
  static const _darkBrown  = Color(0xFF3B1A0D);
  static const _midBrown   = Color(0xFF5D3A1A);
  static const _cream      = Color(0xFFF5ECD7);
  static const _accentGold = Color(0xFFD7A86E);
  static const _textBrown  = Color(0xFF4A2C1A);
  static const _rustOrange = Color(0xFFD2691E);

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _topFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController,
          curve: const Interval(0.0, 0.4, curve: Curves.easeOut)));

    _topSlide = Tween<Offset>(
      begin: const Offset(0, -0.3), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut)));

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _mainController,
          curve: const Interval(0.3, 0.75, curve: Curves.elasticOut)));

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController,
          curve: const Interval(0.3, 0.6, curve: Curves.easeIn)));

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController,
          curve: const Interval(0.65, 0.95, curve: Curves.easeIn)));

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _mainController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOut)));

    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(_buttonController);
    _buttonSlide = Tween<Offset>(
      begin: const Offset(0, 0.6), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _buttonController, curve: Curves.easeOut));

    _mainController.forward().then((_) {
      if (mounted) {
        setState(() => _showButton = true);
        _buttonController.forward();
      }
    });
  }

  void _navigate() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AuthGate(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    
    const double logoRadius   = 80.0;
    const double logoDiameter = logoRadius * 2;
    final double waveTopY     = size.height * 0.42;

    return Scaffold(
      backgroundColor: _cream,
      body: Column(
        children: [

          
          SizedBox(
            height: waveTopY + logoRadius,
            child: Stack(
              clipBehavior: Clip.none,
              children: [

                
                AnimatedBuilder(
                  animation: _mainController,
                  builder: (_, __) => FadeTransition(
                    opacity: _topFade,
                    child: SlideTransition(
                      position: _topSlide,
                      child: ClipPath(
                        clipper: _WaveClipper(),
                        child: Container(
                          width: double.infinity,
                          height: waveTopY + logoRadius,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_darkBrown, _midBrown],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(top: 50,  right: 55,  child: _dot(55, const Color(0xFF6B3A1F).withOpacity(0.5))),
                              Positioned(top: 85,  left: 28,   child: _dot(35, const Color(0xFF8B4E2A).withOpacity(0.4))),
                              Positioned(top: 18,  left: 125,  child: _dot(18, _rustOrange.withOpacity(0.5))),
                              Positioned(top: 105, right: 95,  child: _dot(12, _rustOrange.withOpacity(0.4))),
                              Positioned(top: 42,  left: 62,   child: _dot(10, _accentGold.withOpacity(0.3))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _mainController,
                    builder: (_, __) => FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Center(
                          child: Container(
                            width: logoDiameter,
                            height: logoDiameter,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _cream,
                              border: Border.all(color: _accentGold, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: _darkBrown.withOpacity(0.22),
                                  blurRadius: 20,
                                  spreadRadius: 3,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                           
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [

                  const SizedBox(height: 24),

                  
                  AnimatedBuilder(
                    animation: _mainController,
                    builder: (_, __) => FadeTransition(
                      opacity: _textFade,
                      child: SlideTransition(
                        position: _textSlide,
                        child: const Text(
                          "Your favorite coffee, delivered to you!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: _rustOrange,
                            letterSpacing: 0.3,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  
                  const Spacer(),

                  
                  if (_showButton)
                    AnimatedBuilder(
                      animation: _buttonController,
                      builder: (_, __) => FadeTransition(
                        opacity: _buttonFade,
                        child: SlideTransition(
                          position: _buttonSlide,
                          child: GestureDetector(
                            onTap: _navigate,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: _cream,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(
                                  color: _textBrown.withOpacity(0.28),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _textBrown.withOpacity(0.12),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Text(
                                "GET STARTED",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _textBrown,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 52),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _dot(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}


class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.72);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.94,
      size.width * 0.50, size.height * 0.78,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.62,
      size.width,        size.height * 0.80,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveClipper old) => false;
}