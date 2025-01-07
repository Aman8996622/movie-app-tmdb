import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/presentation/screen/login_screen%20/bloc/login_bloc.dart';
import 'package:movieapp/presentation/screen/login_screen%20/bloc/login_event.dart';
import 'package:movieapp/presentation/screen/login_screen%20/bloc/login_state.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/movie_list_screen.dart';
import 'package:movieapp/presentation/widget/keyboard_aware_widget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MovieListScreen(),
            ),
          );
        }
      },
      builder: (context, state) {
        return KeyboardAwareWidget(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade500,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo or Icon
                        const Icon(
                          Icons.movie,
                          size: 100,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 40),

                        // Welcome Text
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: const TextStyle(color: Colors.white70),
                            prefixIcon:
                                const Icon(Icons.email, color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  const BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        if (state is LoginError)
                          Container(
                            padding: EdgeInsets.only(
                              left: 20,
                              top: 8,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              state.emailError,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.white70),
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  const BorderSide(color: Colors.white70),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        if (state is LoginError)
                          Container(
                            padding: EdgeInsets.only(
                              left: 20,
                              top: 8,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              state.passwordError,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        const SizedBox(height: 30),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              {
                                final loginBloc =
                                    BlocProvider.of<LoginBloc>(context);
                                loginBloc.add(
                                  LoginButtonPressed(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );

                                // context
                                //     .read<LoginBloc>()
                                //     .add(LoginButtonPressed(
                                //       email: _emailController.text,
                                //       password: _passwordController.text,
                                //     ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade400,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: state is LoginLoading
                                ? CircularProgressIndicator(
                                    color: Colors.blue.shade900,
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Forgot Password
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ));
  }
}
