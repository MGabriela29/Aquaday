import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/widgets/custom_input_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> _signup() async {
    if (passwordController.text != confirmPasswordController.text) {
      _showError("Las contraseñas no coinciden");
      return;
    }

    setState(() => isLoading = true);

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user;

      if (user != null) {
        final uid = user.uid;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Registro exitoso!')),
      );

        // Ir al login después del registro
        Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'El correo ya está registrado.';
          break;
        case 'invalid-email':
          message = 'Correo electrónico inválido.';
          break;
        case 'weak-password':
          message = 'La contraseña es muy débil.';
          break;
        case 'operation-not-allowed':
          message = 'El método de registro no está habilitado.';
          break;
        default:
          message = 'Error: ${e.message}';
      }
      _showError(message);
    } catch (e) {
      _showError('Ocurrió un error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

void _showError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
        child: Center(
          child: Column(
            children: [
              Text('Sign Up', style: textTheme.titleLarge),
              const SizedBox(height: 60),
              CustomInputField(
                label: 'Username',
                hintText: 'Enter your username',
                icon: Icons.person,
                controller: usernameController,
              ),
              CustomInputField(
                label: 'Email',
                hintText: 'Enter your email',
                icon: Icons.email,
                controller: emailController,
              ),
              CustomInputField(
                label: 'Phone Number',
                hintText: 'Enter your phone number',
                icon: Icons.phone,
                controller: phoneController,
              ),
              CustomInputField(
                label: 'Password',
                hintText: 'Enter your password',
                icon: Icons.lock,
                controller: passwordController,
                isPassword: true,
              ),
              CustomInputField(
                label: 'Confirm Password',
                hintText: 'Confirm your password',
                icon: Icons.lock,
                controller: confirmPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 40),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
              const SizedBox(height: 24),
              const Text('By registering you agree to'),
              TextButton(
                onPressed: () {},
                child: const Text('Terms of services and Privacy Policy'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
