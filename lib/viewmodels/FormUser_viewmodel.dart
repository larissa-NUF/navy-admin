import 'dart:io';
import 'package:navy_admin/components/SuccessDialogScreen.dart';
import 'package:path/path.dart' as path;
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:navy_admin/modal/user.dart';
import 'package:navy_admin/provider/auth_provider.dart';
import 'package:navy_admin/service_locator.dart';
import 'package:navy_admin/services/user_service.dart';
import 'package:provider/provider.dart';

class FormUserViewmodel extends ChangeNotifier {


  // Controladores para cada campo
  final TextEditingController tipoUsuarioController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sexoController = TextEditingController();
  final TextEditingController rgController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController cnhController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController municipioController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController logradouroController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();


  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> Add(MultipartFile fotoFile, MultipartFile documentFile) async {
  final user = FormData.fromMap({
    "email": emailController.text,
    "password": senhaController.text,
    "name": nomeController.text,
    "phone": telefoneController.text,
    "rg": rgController.text,
    "cpf": cpfController.text,
    "gender": sexoController.text,
    "cep": cepController.text,
    "rua": ruaController.text,
    "numero": numeroController.text,
    "cnh": cnhController.text,
    "logradouro": logradouroController.text,
    "estado": estadoController.text,
    "municipio": municipioController.text,
    "latitude": 0,
    "longitude": 0,
    "foto": fotoFile,
    "document": documentFile,
  });


  return await locator<UserService>().Add(user);
}

  void limparCampos() {
    tipoUsuarioController.clear();
    nomeController.clear();
    sexoController.clear();
    rgController.clear();
    cpfController.clear();
    cepController.clear();
    cnhController.clear();
    estadoController.clear();
    municipioController.clear();
    ruaController.clear();
    numeroController.clear();
    logradouroController.clear();
    emailController.clear();
    senhaController.clear();
    telefoneController.clear();
    // Limpar também a URL da imagem se for gerenciada aqui
    //profileImageUrl = null;
    //notifyListeners(); // Notifica os ouvintes que os campos foram limpos
  }

  Future<void> validarEditarOuSalvar(String? id) async {
  if (id == null || id.isEmpty) return;

  final user = await locator<UserService>().GetUserById(id);
  if (user == null) return;

  // Preenche os controllers com os valores do usuário retornado
  emailController.text = user.email;
  tipoUsuarioController.text = user.role;
  nomeController.text = user.userProfile?.name ?? '';
  telefoneController.text = user.userProfile?.phone ?? '';
  rgController.text = user.userProfile?.rg ?? '';
  cpfController.text = user.userProfile?.cpf ?? '';
  cnhController.text = user.userProfile?.cnh ?? '';
  sexoController.text = user.userProfile?.gender ?? '';
  cepController.text = user.userProfile?.address?.cep ?? '';
  ruaController.text = user.userProfile?.address?.rua ?? '';
  numeroController.text = user.userProfile?.address?.numero ?? '';
  logradouroController.text = user.userProfile?.address?.logradouro ?? '';
  estadoController.text = user.userProfile?.address?.estado ?? '';
  municipioController.text = user.userProfile?.address?.municipio ?? '';
  // senhaController.text = ''; // Não preencha senha por questões de segurança
}

  Future<void> salvarOuAtualizarUsuario({
  required MultipartFile fotoFile,
  required MultipartFile documentFile,
  required BuildContext context,
  String? id,
}) async {
  setLoading(true);

  final user = FormData.fromMap({
    "email": emailController.text,
    "password": senhaController.text,
    "name": nomeController.text,
    "phone": telefoneController.text,
    "rg": rgController.text,
    "cpf": cpfController.text,
    "gender": sexoController.text,
    "cep": cepController.text,
    "rua": ruaController.text,
    "numero": numeroController.text,
    "cnh": cnhController.text,
    "logradouro": logradouroController.text,
    "estado": estadoController.text,
    "municipio": municipioController.text,
    "latitude": 0,
    "longitude": 0,
    "foto": fotoFile,
    "document": documentFile,
  });

  bool result;
  if (id == null || id.isEmpty) {
    result = await locator<UserService>().Add(user);
    if (result) {
      limparCampos();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SuccessDialogScreen(
            title: "Sucesso",
            message: 'Usuário adicionado!',
            buttonLabel: 'Voltar',
            onPressed: () {
              Navigator.pushNamed(context, '/users');
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cadastrar usuário!')),
      );
    }
  } else {
    result = await locator<UserService>().Update(id, user);
    if (result) {
      limparCampos();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SuccessDialogScreen(
            title: "Sucesso",
            message: 'Usuário atualizado!',
            buttonLabel: 'Voltar',
            onPressed: () {
              Navigator.pushNamed(context, '/users');
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar usuário!')),
      );
    }
  }

  setLoading(false);
}

  void dispose() {
    tipoUsuarioController.dispose();
    nomeController.dispose();
    sexoController.dispose();
    rgController.dispose();
    cpfController.dispose();
    cepController.dispose();
    cnhController.dispose();
    estadoController.dispose();
    municipioController.dispose();
    ruaController.dispose();
    numeroController.dispose();
    logradouroController.dispose();
    emailController.dispose();
    senhaController.dispose();
    telefoneController.dispose();
    super.dispose();
  }
}