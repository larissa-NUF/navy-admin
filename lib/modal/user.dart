import 'dart:io';

import 'package:dio/dio.dart';

class User {
  final String id;
  final String email;
  final String role;
  final String userType;
  final bool active;
  final UserProfile? userProfile;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.userType,
    required this.active,
    this.userProfile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      userType: json['userType'] ?? '',
      active: json['active'] ?? false,
      userProfile: json['user_profile'] != null
          ? UserProfile.fromJson(json['user_profile'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'role': role,
      'userType': userType,
      'active': active,
      'user_profile': userProfile?.toJson(),
    };
  }
}

class UserProfile {
  final String? rg;
  final String? cpf;
  final String? cnh;
  final String? foto;
  final String? document;
  final String? gender;
  final String? phone;
  final String? name;
  final Address? address;

  UserProfile({
    this.rg,
    this.cpf,
    this.cnh,
    this.foto,
    this.document,
    this.gender,
    this.phone,
    this.name,
    this.address,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      rg: json['rg'],
      cpf: json['cpf'],
      cnh: json['cnh'],
      foto: json['foto'],
      document: json['document'],
      gender: json['gender'],
      phone: json['phone'],
      name: json['name'],
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rg': rg,
      'cpf': cpf,
      'cnh': cnh,
      'foto': foto,
      'document': document,
      'gender': gender,
      'phone': phone,
      'name': name,
      'address': address?.toJson(),
    };
  }
}

class Address {
  final String? cep;
  final String? rua;
  final String? numero;
  final String? logradouro;
  final String? estado;
  final String? municipio;
  final Location? location;

  Address({
    this.cep,
    this.rua,
    this.numero,
    this.logradouro,
    this.estado,
    this.municipio,
    this.location,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      cep: json['cep'],
      rua: json['rua'],
      numero: json['numero'],
      logradouro: json['logradouro'],
      estado: json['estado'],
      municipio: json['municipio'],
      location: json['location'] != null
          ? Location.fromJson(json['location'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'rua': rua,
      'numero': numero,
      'logradouro': logradouro,
      'estado': estado,
      'municipio': municipio,
      'location': location?.toJson(),
    };
  }
}

class Location {
  final double? latitude;
  final double? longitude;

  Location({this.latitude, this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] is num) ? (json['latitude'] as num).toDouble() : null,
      longitude: (json['longitude'] is num) ? (json['longitude'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
