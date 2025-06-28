import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/mdi_light.dart';
import 'package:navy_admin/modal/user.dart';
import 'package:navy_admin/service_locator.dart';
import 'package:navy_admin/services/token_service.dart';
import 'package:navy_admin/services/user_service.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/pepicons.dart';
import 'package:provider/provider.dart';
import 'package:navy_admin/provider/auth_provider.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String? title;
  final FloatingActionButton? floatingActionButton;

  const MainLayout({
    this.title,
    required this.child,
    this.floatingActionButton,
    Key? key,
  }) : super(key: key);

  Future<User?> fetchUser() async {
    final userId = await locator<TokenService>().getUserId();
    if (userId != null) {
      return await locator<UserService>().GetUserById(userId);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          title ?? "",
          style: const TextStyle(fontSize: 23.0, color: Color(0xFF3535B5)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF3535B5)),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // Topo vermelho com logo e menu
            Container(
              color: const Color(0xFFE74C3C),
              padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'images/admin_logo.png', // Substitua pelo seu asset
                        height: 36,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<User?>(
                    future: fetchUser(),
                    builder: (context, snapshot) {
                      final user = snapshot.data;
                      final userProfile = user?.userProfile;
                      ImageProvider? profileImage;
                      if (userProfile?.foto != null && userProfile!.foto!.isNotEmpty) {
                        profileImage = NetworkImage(userProfile.foto!);
                      } else {
                        profileImage = null;
                      }
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: profileImage,
                            backgroundColor: Colors.white24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userProfile?.name ?? user?.email ?? 'Usuário',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                               // const Text(
                               //   'Meu Perfil',
                               //   style: TextStyle(
                                //    color: Colors.white70,
                               //     fontSize: 13,
                                //    decoration: TextDecoration.underline,
                                //  ),
                                //),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.logout, color: Colors.white, size: 20),
                                onPressed: () async {
                                  // Faz logout e navega para a tela de login removendo todas as rotas anteriores
                                  await Provider.of<AuthProvider>(context, listen: false).logout();
                                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                                },
                                tooltip: 'Sair',
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24), // <-- Espaçamento adicionado aqui
                  // Campo de pesquisa (se houver)
                ],
              ),
            ),
            // Menu lateral azul
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF393ab6),  // Set the desired background color
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // HOME
                    Container(
                      decoration: BoxDecoration(
                        color: ModalRoute.of(context)?.settings.name == '/home'
                            ? Color(0xFFFFF1F0)
                            : const Color(0xFF3535B5),  // Set the desired background color
                      ),
                      child: ListTile(

                        shape: ModalRoute.of(context)?.settings.name == '/home'
                            ? const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                          ),
                        )
                            : null,
                        leading: Container(
                          decoration: BoxDecoration(
                            color: ModalRoute.of(context)?.settings.name == '/home'
                                ? const Color(0xFFC4BCDC)
                                : const Color(0xFF3535B5),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ModalRoute.of(context)?.settings.name == '/home'
                                  ? const Color(0xFF3535B5)
                                  : Colors.white,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Iconify(
                            Pepicons.house,
                            color: ModalRoute.of(context)?.settings.name == '/home'
                                ? const Color(0xFF3535B5)
                                : Colors.white,
                            size: 32,
                          ),
                        ),
                        title: Text(
                          'Home',
                          style: TextStyle(
                            color: ModalRoute.of(context)?.settings.name == '/home'
                                ? const Color(0xFF3535B5)
                                : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'DoppioOne',
                          ),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/home');
                        },
                      ),

                    ),
                    // FORMULÁRIOS DE CADASTROS (com dropdown)
                    ExpansionTile(

                      collapsedBackgroundColor: Colors.transparent,
                      leading: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF3535B5),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Iconify(
                          Pepicons.clipboard,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      title: Text(
                        "Formulários de Cadastros",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'DoppioOne',
                        ),
                      ),
                      iconColor: Colors.white, // seta branca quando aberto
                      collapsedIconColor: Colors.white, // seta branca quando fechado
                      children: [
                        ListTile(
                          leading: const Icon(Icons.chevron_right, color: Colors.white), // ícone ">"
                          title: const Text(
                            "Novo Carro",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/cars/form');
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.chevron_right, color: Colors.white), // ícone ">"
                          title: const Text(
                            "Novo Usuário",
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/users/form');
                          },
                        ),
                      ],
                    ),
                    // LISTA DE CADASTROS (com dropdown)
                    ExpansionTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Iconify(
                          Pepicons.file,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      title: const Text(
                        "Lista de Cadastros",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'DoppioOne',
                        ),
                      ),
                      iconColor: Colors.white,
                      collapsedIconColor: Colors.white,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.chevron_right, color: Colors.white),
                          title: const Text("Carros", style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.pushNamed(context, '/cars');
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.chevron_right, color: Colors.white),
                          title: const Text("Usuários", style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.pushNamed(context, '/users');
                          },
                        ),
                      ],
                    ),
                    // Exemplo para os itens do menu, estático igual à imagem:





                    // Lista de Cadastros

                    // ...continue com os demais itens do menu normalmente...
                  ],
                ),

              )
            ),
          ],
        ),
      ),
      body: child,
      floatingActionButton: floatingActionButton,
    );
  }
}