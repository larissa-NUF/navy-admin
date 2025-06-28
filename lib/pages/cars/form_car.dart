import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navy_admin/components/GenericFormField.dart';
import 'package:navy_admin/components/main_layout.dart';
import 'package:navy_admin/components/SuccessDialogScreen.dart';
import 'package:navy_admin/service_locator.dart';
import 'package:navy_admin/services/car_service.dart';
import 'package:navy_admin/services/user_service.dart';
import 'package:navy_admin/modal/user.dart';
import 'package:navy_admin/viewmodels/form_car_viewmodel.dart';
import 'package:path/path.dart' as path;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class FormCar extends StatelessWidget {
  const FormCar({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    return MainLayout(
      child: FormCarGeneric(routeArgs: args),
    );
  }
}

class FormCarGeneric extends StatefulWidget {
  final Object? routeArgs;
  const FormCarGeneric({super.key, this.routeArgs});

  @override
  State<FormCarGeneric> createState() => _FormCarGenericState();
}

class _FormCarGenericState extends State<FormCarGeneric> {
  File? fotoPreviewFile;
  MultipartFile? fotoFile;
  List<User> usuarios = [];
  bool isLoadingUsers = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final formCarViewModel = Provider.of<FormCarViewmodel>(context, listen: false);
      final carId = widget.routeArgs as String?;
      formCarViewModel.validarEditarOuSalvar(carId);
      await fetchUsuarios();
    });
  }

  Future<void> fetchUsuarios([String? filter]) async {
    setState(() {
      isLoadingUsers = true;
    });
    List<User> lista;
    if (filter != null && filter.isNotEmpty) {
      lista = await locator<UserService>().GetByFilter({'user_profile.name': filter});
    } else {
      lista = await locator<UserService>().GetAll();
    }
    setState(() {
      usuarios = lista;
      isLoadingUsers = false;
    });
  }

  Future<void> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      print('Nenhuma imagem selecionada.');
    } else {
      File originalFile = File(image.path);
      String originalFileName = path.basenameWithoutExtension(originalFile.path);
      String newPath = '${originalFile.parent.path}/$originalFileName.jpg';

      final compressedImageBytes = await FlutterImageCompress.compressWithFile(
        originalFile.path,
        minWidth: 1024,
        minHeight: 768,
        quality: 85,
        format: CompressFormat.jpeg,
      );

      if (compressedImageBytes != null) {
        File compressedFile = File(newPath);
        await compressedFile.writeAsBytes(compressedImageBytes);

        fotoFile = await MultipartFile.fromFile(
          compressedFile.path,
          filename: path.basename(compressedFile.path),
          contentType: MediaType('image', 'jpg'),
        );

        fotoPreviewFile = compressedFile;

        setState(() {});
        print('Imagem convertida para JPG e pronta para upload.');
      } else {
        print('Falha ao comprimir ou converter a imagem.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formCarViewModel = Provider.of<FormCarViewmodel>(context);

    // Verifica se está editando (tem id na rota)
    final bool isEdit = widget.routeArgs != null && (widget.routeArgs as String).isNotEmpty;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.14),
              offset: const Offset(4, 5),
              blurRadius: 4.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GenericForm(
              fields: [
                GenericFormField(
                  label: "Tipo de Operação:",
                  controller: formCarViewModel.operationTypeController,
                  customField: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Tipo de Operação:",
                          style: GoogleFonts.domine(
                            textStyle: const TextStyle(
                              color: Color(0xFF333333),
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.25),
                              offset: const Offset(1, 1),
                              blurRadius: 4.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          value: formCarViewModel.operationTypeController.text.isNotEmpty
                              ? formCarViewModel.operationTypeController.text
                              : null,
                          decoration: const InputDecoration(
                            hintText: "Selecione o tipo de operação",
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "sale",
                              child: Text("Venda"),
                            ),
                            DropdownMenuItem(
                              value: "rent",
                              child: Text("Alugar"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              formCarViewModel.operationTypeController.text = value ?? '';
                            });
                          },
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Selecione o tipo de operação' : null,
                        ),
                      ),
                    ],
                  ),
                ),
                GenericFormField(
                  label: "Proprietário:",
                  controller: formCarViewModel.ownerIdController,
                  customField: isLoadingUsers
                      ? const CircularProgressIndicator()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Proprietário:",
                                style: GoogleFonts.domine(
                                  textStyle: const TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromRGBO(0, 0, 0, 0.25),
                                    offset: const Offset(1, 1),
                                    blurRadius: 4.0,
                                    spreadRadius: 0.0,
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: usuarios.any((u) => u.id == formCarViewModel.ownerIdController.text)
                                    ? formCarViewModel.ownerIdController.text
                                    : null,
                                decoration: const InputDecoration(
                                  hintText: "Selecione o proprietário",
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                ),
                                items: usuarios
                                    .map((user) => DropdownMenuItem<String>(
                                          value: user.id,
                                          child: Text(user.userProfile?.name ?? user.email),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    formCarViewModel.ownerIdController.text = value ?? '';
                                  });
                                },
                                validator: (value) =>
                                    value == null || value.isEmpty ? 'Selecione o proprietário' : null,
                              ),
                            ),
                          ],
                        ),
                ),
                GenericFormField(
                  label: "Grupo:",
                  controller: formCarViewModel.grupoController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o grupo' : null,
                ),
                GenericFormField(
                  label: "Modelo:",
                  controller: formCarViewModel.modelController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o modelo' : null,
                ),
                GenericFormField(
                  label: "Marca:",
                  controller: formCarViewModel.brandController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe a marca' : null,
                ),
                GenericFormField(
                  label: "Ano:",
                  controller: formCarViewModel.yearController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o ano' : null,
                ),
                GenericFormField(
                  label: "Cor:",
                  controller: formCarViewModel.colorController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe a cor' : null,
                ),
                // Exibe apenas se for "Venda"
                if (formCarViewModel.operationTypeController.text == "sale")
                  GenericFormField(
                    label: "Preço:",
                    controller: formCarViewModel.priceController,
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Informe o preço' : null,
                  ),
                // Exibe apenas se for "Alugar"
                if (formCarViewModel.operationTypeController.text == "rent")
                  GenericFormField(
                    label: "Preço por hora:",
                    controller: formCarViewModel.pricePerHourController,
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty ? 'Informe o preço por hora' : null,
                  ),
                GenericFormField(
                  label: "Combustivel:",
                  controller: formCarViewModel.fuelTypeController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o combustível' : null,
                ),
                GenericFormField(
                  label: "Placa:",
                  controller: formCarViewModel.licensePlateController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe a placa' : null,
                ),
                Column(
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () async {
                              await getImage();
                            },
                            icon: Icon(Icons.cloud_upload_outlined),
                            label: Text("Upload de fotos"),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Foto
                              Container(
                                width: 70,
                                height: 70,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade200,
                                ),
                                child: fotoPreviewFile != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    fotoPreviewFile!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                    : Center(
                                  child: Text(
                                    "Sem foto",
                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
              onSubmit: () async {
                final formCarViewModel = Provider.of<FormCarViewmodel>(context, listen: false);
                await formCarViewModel.salvarOuAtualizarCar(
                  context: context,
                  id: widget.routeArgs as String?,
                  foto: fotoPreviewFile,
                );
              },
              submitLabel: isEdit ? "Editar" : "Cadastrar", // <-- Aqui muda dinamicamente
              isEdit: isEdit, // <-- Passa para o GenericForm para mudar o título também
              entityLabel: 'Carro',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}