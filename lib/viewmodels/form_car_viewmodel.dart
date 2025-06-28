import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:navy_admin/components/SuccessDialogScreen.dart';
import 'package:navy_admin/modal/car.dart';
import 'package:navy_admin/service_locator.dart';
import 'package:navy_admin/services/car_service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class FormCarViewmodel extends ChangeNotifier {
  // Controladores para cada campo do formulário de carro
  final TextEditingController operationTypeController = TextEditingController();
  final TextEditingController ownerIdController = TextEditingController();
  final TextEditingController grupoController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController pricePerHourController = TextEditingController();
  final TextEditingController fuelTypeController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();

  // Para upload de foto (apenas 1 foto)
  File? fotoFile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void limparCampos() {
    operationTypeController.clear();
    ownerIdController.clear();
    grupoController.clear();
    modelController.clear();
    brandController.clear();
    yearController.clear();
    colorController.clear();
    priceController.clear();
    pricePerHourController.clear();
    fuelTypeController.clear();
    licensePlateController.clear();
    fotoFile = null;
    notifyListeners();
  }

  Future<void> validarEditarOuSalvar(String? id) async {
    if (id == null || id.isEmpty) return;

    final car = await locator<CarService>().GetCarById(id);
    if (car == null) return;

    operationTypeController.text = car.operationType;
    ownerIdController.text = car.ownerId;
    grupoController.text = ""; // Preencha se houver campo correspondente
    modelController.text = car.model;
    brandController.text = car.brand;
    yearController.text = car.year.toString();
    colorController.text = car.color;
    priceController.text = ""; // Preencha se houver campo correspondente
    pricePerHourController.text = car.pricePerHour.toString();
    fuelTypeController.text = car.fuelType;
    licensePlateController.text = car.licensePlate;
    // fotoFile: você pode carregar a foto se necessário
    notifyListeners();
  }

  Future<MultipartFile?> _prepareImageFile(File? file) async {
    if (file == null) return null;

    // Converte para JPG comprimido, igual ao usuário
    String originalFileName = path.basenameWithoutExtension(file.path);
    String newPath = '${file.parent.path}/$originalFileName.jpg';

    final compressedImageBytes = await FlutterImageCompress.compressWithFile(
      file.path,
      minWidth: 1024,
      minHeight: 768,
      quality: 85,
      format: CompressFormat.jpeg,
    );

    if (compressedImageBytes != null) {
      File compressedFile = File(newPath);
      await compressedFile.writeAsBytes(compressedImageBytes);

      return await MultipartFile.fromFile(
        compressedFile.path,
        filename: path.basename(compressedFile.path),
        contentType: MediaType('image', 'jpg'),
      );
    }
    return null;
  }

  Future<void> salvarOuAtualizarCar({
    required BuildContext context,
    String? id,
    File? foto,
  }) async {
    setLoading(true);

    MultipartFile? fotoMultipart;
    if (foto != null) {
      fotoMultipart = await _prepareImageFile(foto);
    }

    final carData = FormData.fromMap({
      "operationType": operationTypeController.text,
      "owner_id": ownerIdController.text,
      "model": modelController.text,
      "brand": brandController.text,
      "year": int.tryParse(yearController.text) ?? 0,
      "color": colorController.text,
      if (operationTypeController.text == "sale")
        "price": double.tryParse(priceController.text) ?? 0.0,
      if (operationTypeController.text == "rent")
        "price_per_hour": double.tryParse(pricePerHourController.text) ?? 0.0,
      "fuel_type": fuelTypeController.text,
      "license_plate": licensePlateController.text,
      if (fotoMultipart != null) "photo": fotoMultipart,
    });

    bool result;
    if (id == null || id.isEmpty) {
      result = await locator<CarService>().Add(carData);
      if (result) {
        limparCampos();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SuccessDialogScreen(
              title: "Sucesso",
              message: 'Carro adicionado!',
              buttonLabel: 'Voltar',
              onPressed: () {
                Navigator.pushNamed(context, '/cars');
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao cadastrar carro!')),
        );
      }
    } else {
      result = await locator<CarService>().Update(id, carData);
      if (result) {
        limparCampos();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SuccessDialogScreen(
              title: "Sucesso",
              message: 'Carro atualizado!',
              buttonLabel: 'Voltar',
              onPressed: () {
                Navigator.pushNamed(context, '/cars');
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar carro!')),
        );
      }
    }

    setLoading(false);
  }

  @override
  void dispose() {
    operationTypeController.dispose();
    ownerIdController.dispose();
    grupoController.dispose();
    modelController.dispose();
    brandController.dispose();
    yearController.dispose();
    colorController.dispose();
    priceController.dispose();
    pricePerHourController.dispose();
    fuelTypeController.dispose();
    licensePlateController.dispose();
    super.dispose();
  }
}