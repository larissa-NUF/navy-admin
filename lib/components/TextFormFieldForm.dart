import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFormFieldForm extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText; // Adicionado

  const TextFormFieldForm({
    Key? key,
    required this.controller,
    this.hintText,
    required this.labelText,
    this.validator,
    this.keyboardType,
    this.obscureText = false, // Adicionado valor padrão
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget> [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            labelText,
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
          child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            obscureText: obscureText, // Adicionado
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
          ),
        )
      ],
    );
  }
}

