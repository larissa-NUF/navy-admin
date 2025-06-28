import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:navy_admin/components/main_layout.dart';
import 'package:navy_admin/modal/user.dart';
import 'package:navy_admin/service_locator.dart';
import 'package:navy_admin/services/token_service.dart';
import 'package:navy_admin/services/user_service.dart';

@RoutePage()
class Home extends StatelessWidget {
  const Home({super.key});

  Future<User?> fetchUser() async {
    final userId = await locator<TokenService>().getUserId();
    if (userId != null) {
      return await locator<UserService>().GetUserById(userId);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "",
      child: Center(
        child: FutureBuilder<User?>(
          future: fetchUser(),
          builder: (context, snapshot) {
            final user = snapshot.data;
            final userName = user?.userProfile?.name ?? user?.email ?? 'Usuário';
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Bem vindo $userName!',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 450,
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Color(0xFF6C6F82),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                    ),
                    onPressed: () {
                      // Navegar para cadastro de carro
                    },
                    child: const Text(
                      'Cadastrar novo carro',
                      style: TextStyle(
                        color: Color(0xFF5B3FE2),
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'DoppioOne',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: 450,
                  height: 64,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Color(0xFF6C6F82),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                    ),
                    onPressed: () {
                      // Navegar para cadastro de usuário
                    },
                    child: const Text(
                      'Cadastrar novo usuário',
                      style: TextStyle(
                        color: Color(0xFF5B3FE2),
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'DoppioOne',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
