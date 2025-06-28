import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navy_admin/components/TextFormFieldForm.dart';

class GenericFormField {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? customField; // Para campos especiais, como dropdown

  GenericFormField({
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.customField,
  });
}

class GenericForm extends StatelessWidget {
  final List<dynamic> fields; // Aceita GenericFormField ou Widget
  final VoidCallback onSubmit;
  final String? submitLabel;
  final bool isEdit; // true para editar, false para cadastrar
  final String entityLabel; // Ex: "Usuário", "Carro", "Frota"

  const GenericForm({
    Key? key,
    required this.fields,
    required this.onSubmit,
    this.submitLabel,
    this.isEdit = false,
    required this.entityLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título estilizado transferido do formulário
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: <Widget>[
                    Text(
                      isEdit ? "Editar" : "Cadastrar",
                      style: GoogleFonts.doppioOne(
                        textStyle: const TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      height: 5,
                      width: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3535B5),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    " $entityLabel",
                    style: GoogleFonts.doppioOne(
                      textStyle: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          ...fields.map((f) {
            if (f is GenericFormField) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: f.customField ??
                    TextFormFieldForm(
                      controller: f.controller,
                      labelText: f.label,
                      validator: f.validator,
                      keyboardType: f.keyboardType,
                      obscureText: f.obscureText,
                    ),
              );
            } else if (f is Widget) {
              return f;
            } else {
              return const SizedBox.shrink();
            }
          }),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: 200,
              height: 36,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3535B5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Color(0xFF6C6F82),
                      width: 1,
                    ),
                  ),
                  elevation: 2,
                  shadowColor: Colors.black12,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    onSubmit();
                  }
                },
                child: const Text(
                  "Finalizar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'DoppioOne',
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24), // Espaçamento extra abaixo do botão
        ],
      ),
    );
  }
}