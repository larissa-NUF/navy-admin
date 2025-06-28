import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:navy_admin/viewmodels/Login_viewmodel.dart';
import 'package:provider/provider.dart';

@RoutePage()
class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    final List<Color> gradientColors = [
      const Color(0xFFDEB8C1), // Parada 1: DEB8C1, 100%
      const Color(0x42BF454E), // Parada 2: BF454E, 26% (0x42 é ~26% de FF)
      const Color(0x669B3857), // Parada 3: 9B3857, 40% (0x66 é ~40% de FF)
      const Color(0xFF00007E), // Parada 4: 00007E, 100%
    ];

    final List<double> gradientStops = [
      0.00, // 1%
      0, // 15%
      0.2, // 28%
      0.88, // 88%
    ];

    return Scaffold(
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
            stops: gradientStops, // Aplicando as paradas do gradiente
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),

                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10.0,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: loginViewModel.emailController,
                        decoration: const InputDecoration(
                          hintText: 'Usuário',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      TextField(
                        controller: loginViewModel.passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Senha',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                        ),
                      ),
                      const SizedBox(height: 30.0),

                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () {
                            loginViewModel.login(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEC6B56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 5.0,
                          ),
                          child: const Text(
                            'ENTRAR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100),

                const Image(image: AssetImage('images/admin_logo.png'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}