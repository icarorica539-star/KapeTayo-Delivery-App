import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordHidden = true;
  bool isConfirmHidden = true;

  String? errorText;

  void handleRegister() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    
    if (email.isEmpty || !email.contains("@")) {
      setState(() => errorText = "Enter a valid email");
      return;
    }

    if (password.length < 6) {
      setState(() => errorText = "Password must be at least 6 characters");
      return;
    }

    if (password != confirm) {
      setState(() => errorText = "Passwords do not match");
      return;
    }

    setState(() {
      isLoading = true;
      errorText = null;
    });

    final auth = Provider.of<AuthProvider>(context, listen: false);

    final error = await auth.register(email, password);

    if (!mounted) return;

    setState(() => isLoading = false);

    if (error != null) {
      setState(() => errorText = error);
    } else {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created! Please login ☕"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      Navigator.pop(context); 
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF2E1F1A);
    const primaryColor = Color(0xFF6F4E37);
    const accentColor = Color(0xFFD7A86E);
    const textColor = Color(0xFFF5E6D3);

    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              const Icon(Icons.coffee, color: accentColor, size: 60),

              const SizedBox(height: 10),

              const Text(
                "Join the Brew ☕",
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
                  filled: true,
                  fillColor: primaryColor.withOpacity(0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              
              TextField(
                controller: passwordController,
                obscureText: isPasswordHidden,
                style: const TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: primaryColor.withOpacity(0.4),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: accentColor,
                    ),
                    onPressed: () =>
                        setState(() => isPasswordHidden = !isPasswordHidden),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              
              TextField(
                controller: confirmPasswordController,
                obscureText: isConfirmHidden,
                style: const TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: primaryColor.withOpacity(0.4),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: accentColor,
                    ),
                    onPressed: () =>
                        setState(() => isConfirmHidden = !isConfirmHidden),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              
              if (errorText != null)
                Text(
                  errorText!,
                  style: const TextStyle(color: Colors.redAccent),
                ),

              const SizedBox(height: 25),

              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          "Register",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(color: accentColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}