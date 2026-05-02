import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading       = false;
  bool isGoogleLoading = false;

  Future<void> handleLogin() async {
    setState(() => isLoading = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);

    final error = await auth.login(
      emailController.text,
      passwordController.text,
    );

    setState(() => isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
    
  }

  Future<void> handleGoogleLogin() async {
    setState(() => isGoogleLoading = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);

    await auth.signInWithGoogle();

    setState(() => isGoogleLoading = false);

    
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor     = Color(0xFF2E1F1A);
    const accentColor = Color(0xFFD7A86E);
    const textColor   = Color(0xFFF5E6D3);
    const cardColor   = Color(0xFF3B2318);

    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(Icons.coffee, color: accentColor, size: 60),

            const SizedBox(height: 10),

            const Text(
              "WELCOME! ☕",
              style: TextStyle(
                fontSize: 26,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            
            TextField(
              controller: emailController,
              style: const TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.email_outlined, color: accentColor),
                filled: true,
                fillColor: Colors.brown.withOpacity(0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: accentColor, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 15),

            
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.lock_outlined, color: accentColor),
                filled: true,
                fillColor: Colors.brown.withOpacity(0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: accentColor, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 25),

            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: accentColor.withOpacity(0.4),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            
            Row(
              children: [
                Expanded(
                  child: Divider(color: Colors.white.withOpacity(0.2), thickness: 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(color: Colors.white.withOpacity(0.2), thickness: 1),
                ),
              ],
            ),

            const SizedBox(height: 12),

            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isGoogleLoading ? null : handleGoogleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cardColor,
                  foregroundColor: textColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: accentColor.withOpacity(0.5),
                      width: 1.2,
                    ),
                  ),
                  elevation: 0,
                ),
                child: isGoogleLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: accentColor,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // ✅ Google "G" logo in brand colors
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: CustomPaint(
                              painter: _GoogleLogoPainter(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Continue with Google",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 20),

            
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text(
                "New here? Create account",
                style: TextStyle(color: accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r  = size.width / 2;

    
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()..color = Colors.white,
    );

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.72);

    
    canvas.drawArc(
      rect, -0.52, 2.10, false,
      Paint()
        ..color = const Color(0xFF4285F4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.28
        ..strokeCap = StrokeCap.butt,
    );

    
    canvas.drawArc(
      rect, 1.58, 1.05, false,
      Paint()
        ..color = const Color(0xFF34A853)
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.28
        ..strokeCap = StrokeCap.butt,
    );

    
    canvas.drawArc(
      rect, 2.63, 0.95, false,
      Paint()
        ..color = const Color(0xFFFBBC05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.28
        ..strokeCap = StrokeCap.butt,
    );

    
    canvas.drawArc(
      rect, 3.58, 1.24, false,
      Paint()
        ..color = const Color(0xFFEA4335)
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.28
        ..strokeCap = StrokeCap.butt,
    );

    
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = r * 0.28
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r * 0.72, cy),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(_GoogleLogoPainter old) => false;
}