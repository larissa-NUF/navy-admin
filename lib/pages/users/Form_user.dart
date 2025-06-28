import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navy_admin/components/GenericFormField.dart';
import 'package:navy_admin/components/main_layout.dart';
import 'package:navy_admin/components/SuccessDialogScreen.dart';
import 'package:navy_admin/viewmodels/FormUser_viewmodel.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';

class FormUser extends StatelessWidget {
  const FormUser({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtendo os parâmetros da rota
    final args = ModalRoute.of(context)?.settings.arguments;

    return MainLayout(
      child: FormUserGeneric(routeArgs: args),
    );
  }
}

class FormUserGeneric extends StatefulWidget {
  final Object? routeArgs;
  const FormUserGeneric({super.key, this.routeArgs});

  @override
  State<FormUserGeneric> createState() => _FormUserGenericState();
}

class _FormUserGenericState extends State<FormUserGeneric> {
  MultipartFile? fotoFile;
  MultipartFile? documentFile;
  File? fotoPreviewFile;
  File? documentPreviewFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final formUserViewModel = Provider.of<FormUserViewmodel>(context, listen: false);
      final userId = widget.routeArgs as String?;
      formUserViewModel.validarEditarOuSalvar(userId);
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
        documentFile = await MultipartFile.fromFile(
          compressedFile.path,
          filename: path.basename(compressedFile.path),
          contentType: MediaType('image', 'jpg'),
        );

        // Salve o arquivo para preview
        fotoPreviewFile = compressedFile;
        documentPreviewFile = compressedFile;

        setState(() {});
        print('Imagem convertida para JPG e pronta para upload.');
      } else {
        print('Falha ao comprimir ou converter a imagem.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formUserViewModel = Provider.of<FormUserViewmodel>(context);

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
                  label: "Tipo de Usuário:",
                  controller: formUserViewModel.tipoUsuarioController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o tipo de usuário' : null,
                ),
                GenericFormField(
                  label: "Nome:",
                  controller: formUserViewModel.nomeController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
                ),
                GenericFormField(
                  label: "Sexo Biológico:",
                  controller: formUserViewModel.sexoController,
                  customField: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sexo Biológico:",
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Domine',
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
                          value: formUserViewModel.sexoController.text.isNotEmpty
                              ? formUserViewModel.sexoController.text
                              : null,
                          decoration: const InputDecoration(
                            hintText: "Selecione o sexo biológico",
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
                              value: "masculino",
                              child: Text("Masculino"),
                            ),
                            DropdownMenuItem(
                              value: "feminino",
                              child: Text("Feminino"),
                            ),
                            DropdownMenuItem(
                              value: "outro",
                              child: Text("Outro"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              formUserViewModel.sexoController.text = value ?? '';
                            });
                          },
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Selecione o sexo biológico' : null,
                        ),
                      ),
                    ],
                  ),
                ),
                GenericFormField(
                  label: "RG:",
                  controller: formUserViewModel.rgController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o RG' : null,
                ),
                GenericFormField(
                  label: "CPF:",
                  controller: formUserViewModel.cpfController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o CPF' : null,
                ),
                GenericFormField(
                  label: "CEP:",
                  controller: formUserViewModel.cepController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o CEP' : null,
                ),
                GenericFormField(
                  label: "CNH:",
                  controller: formUserViewModel.cnhController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe a CNH' : null,
                ),
                GenericFormField(
                  label: "Estado:",
                  controller: formUserViewModel.estadoController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o estado' : null,
                ),
                GenericFormField(
                  label: "Município:",
                  controller: formUserViewModel.municipioController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o município' : null,
                ),
                GenericFormField(
                  label: "Rua:",
                  controller: formUserViewModel.ruaController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe a rua' : null,
                ),
                GenericFormField(
                  label: "Numero:",
                  controller: formUserViewModel.numeroController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o número' : null,
                ),
                GenericFormField(
                  label: "Logradouro:",
                  controller: formUserViewModel.logradouroController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o logradouro' : null,
                ),
                GenericFormField(
                  label: "Telefone:",
                  controller: formUserViewModel.telefoneController,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o telefone' : null,
                ),
                GenericFormField(
                  label: "Email:",
                  controller: formUserViewModel.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value == null || value.isEmpty ? 'Informe o e-mail' : null,
                ),
                GenericFormField(
                  label: "Senha:",
                  controller: formUserViewModel.senhaController,
                  obscureText: true,
                  validator: (value) => value == null || value.isEmpty ? 'Informe a senha' : null,
                ),
                Column(
                  children: [
                    const SizedBox(height: 24),
                    // Upload de fotos (simulação)
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
                              // Documento
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                )
              ],
              onSubmit: () async {
                final formUserViewModel = Provider.of<FormUserViewmodel>(context, listen: false);
                await formUserViewModel.salvarOuAtualizarUsuario(
                  fotoFile: fotoFile!,
                  documentFile: documentFile!,
                  context: context,
                  id: widget.routeArgs as String?,
                );
              },
              submitLabel: "Finalizar Edição", entityLabel: 'Usuário',
            ),


          ],
        ),
      ),
    );
  }
}