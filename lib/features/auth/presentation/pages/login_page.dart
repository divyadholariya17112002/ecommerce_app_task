import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../products/presentation/pages/product_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController =
  TextEditingController();

  final _passwordController =
  TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
      LoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 450,
              ),
              child: Form(
                key: _formKey,
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state.status ==
                        AuthStatus.authenticated) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const ProductPage(),
                        ),
                      );
                    }

                    if (state.status ==
                        AuthStatus.failure) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content:
                          Text(state.errorMessage),
                        ),
                      );
                    }
                  },
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.shopping_bag,
                        size: 80,
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Welcome Back',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Login to continue shopping',
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      TextFormField(
                        controller:
                        _emailController,
                        keyboardType:
                        TextInputType.emailAddress,
                        decoration:
                        const InputDecoration(
                          labelText: 'Email',
                          prefixIcon:
                          Icon(Icons.email),
                          border:
                          OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Enter email';
                          }

                          if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller:
                        _passwordController,
                        obscureText:
                        _obscurePassword,
                        decoration:
                        InputDecoration(
                          labelText: 'Password',
                          prefixIcon:
                          const Icon(
                            Icons.lock,
                          ),
                          suffixIcon:
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword =
                                !_obscurePassword;
                              });
                            },

                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          border:
                          const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Enter password';
                          }

                          if (value.length < 6) {
                            return 'Minimum 6 characters';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      BlocBuilder<AuthBloc, AuthState>(
                        builder:
                            (context, state) {
                          final loading =
                              state.status ==
                                  AuthStatus.loading;

                          return SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                              loading
                                  ? null
                                  : _login,
                              child: loading
                                  ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text(
                                'Login',
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'Demo: test@gmail.com / 123456',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}