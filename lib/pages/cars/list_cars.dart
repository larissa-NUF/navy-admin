import 'package:flutter/material.dart';
import 'package:navy_admin/components/GenericListPage.dart';
import 'package:navy_admin/modal/car.dart';
import 'package:navy_admin/service_locator.dart';
import 'package:navy_admin/services/car_service.dart';

class ListarCarros extends StatelessWidget {
  const ListarCarros({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericListPage<Car>(
      title: 'Lista de Carros',
      fetchAll: () => locator<CarService>().GetAll(),
      fetchByFilter: (field, value) => locator<CarService>().GetByFilter({field: value}),
      onDelete: (car) async {
        final result = await locator<CarService>().Delete(car.id);
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Carro removido com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao remover carro!')),
          );
        }
      },
      onEdit: (car) {
        Navigator.pushNamed(context, '/cars/form', arguments: car.id);
      },
      onAdd: () {
        Navigator.pushNamed(context, '/cars/form');
      },
      getName: (car) => '${car.brand} ${car.model}',
      getEmail: (car) => car.licensePlate,
      getImageUrl: (car) => car.photoUrl ?? "",
      filterFields: const ['model', 'brand', 'license_plate', 'color'],
      getFilterLabel: (field) {
        switch (field) {
          case 'model':
            return 'Modelo';
          case 'brand':
            return 'Marca';
          case 'license_plate':
            return 'Placa';
          case 'color':
            return 'Cor';
          default:
            return field;
        }
      },
      defaultFilterField: 'model',
    );
  }
}