import 'package:flutter/material.dart';
import 'package:navy_admin/components/main_layout.dart';
import 'package:navy_admin/components/GenericListPage.dart';
import 'package:navy_admin/modal/user.dart';
import 'package:navy_admin/service_locator.dart';
import '../../services/user_service.dart';

class ListarUsuarios extends StatelessWidget {
  const ListarUsuarios({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericListPage<User>(
      title: 'Lista Usuários',
      fetchAll: () => locator<UserService>().GetAll(),
      fetchByFilter: (field, value) => locator<UserService>().GetByFilter({field: value}),
      onDelete: (user) async {
        final result = await locator<UserService>().Delete(user.id);
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário desativado com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao desativar usuário!')),
          );
        }
      },
      onEdit: (user) {
        Navigator.pushNamed(context, '/users/form', arguments: user.id);
      },
      onAdd: () {
        Navigator.pushNamed(context, '/users/form');
      },
      getName: (user) => user.userProfile?.name ?? user.email,
      getEmail: (user) => user.email,
      getImageUrl: (user) => user.userProfile?.foto ?? "",
      filterFields: const ['user_profile.name', 'email'],
      getFilterLabel: (field) {
        switch (field) {
          case 'user_profile.name':
            return 'Nome';
          case 'email':
            return 'Email';
          default:
            return field;
        }
      },
      defaultFilterField: 'user_profile.name',
    );
  }
}