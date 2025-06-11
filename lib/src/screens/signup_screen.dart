import 'package:aquaday/src/screens/home_screen.dart';
import 'package:aquaday/utils/routes.dart';
import 'package:aquaday/widgets/custom_input_field.dart';
import 'package:flutter/material.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos una referencia al TextTheme
    final TextTheme textTheme = Theme.of(context).textTheme;
    // Obtenemos una referencia a ColorScheme si la necesitamos para otros elementos
    final ColorScheme colorScheme = Theme.of(context).colorScheme;


    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0,50, 0, 20),
        child: Center( 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Text(
                'Sign Up',
                style: textTheme.titleLarge,
              ),

              const SizedBox(height: 80),

                  // Username
                  const CustomInputField(
                    label: 'Username',
                    hintText: 'Enter your username',
                    icon: Icons.person,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  // Email
                  const CustomInputField(
                    label: 'Email',
                    hintText: 'Enter your email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const CustomInputField(
                    label: 'Phone Number',
                    hintText: 'Enter your phone number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone
                  ),

                  // Password
                  const CustomInputField(
                    label: 'Password',
                    hintText: 'Enter your password',
                    icon: Icons.lock,
                    isPassword: true,
                  ),

                  // Confirm Password
                  const CustomInputField(
                    label: 'Confirm Password',
                    hintText: 'Confirm your password',
                    icon: Icons.lock,
                    isPassword: true,
                  ),

              const SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.homeRoute);
                        },
                style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                child: const Text('Continue', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800 , color: Colors.white)),
              ),

              const SizedBox(height: 34),

              Text('By registering you agree to',style: TextStyle( fontWeight: FontWeight.w800 , color: Colors.blueGrey)),
              
              TextButton(
                onPressed: () {
                  
                },
                child: const Text('Terms of services and Privacy Policy'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}