class Car {
  final String id;
  final String operationType;
  final double pricePerHour;
  final String licensePlate;
  final String status;
  final DateTime? rentedAt;
  final DateTime? soldAt;
  final String rentedBy;
  final String soldTo;
  final String shortDescription;
  final int mileage;
  final Address? address;
  final String ownerId;
  final String model;
  final String brand;
  final int year;
  final String color;
  final String fuelType;
  final String transmission;
  final Object photo;
  final String? photoUrl; // Ajustado para ser String? (pode ser nulo)

  Car({
    required this.id,
    required this.operationType,
    required this.pricePerHour,
    required this.licensePlate,
    required this.status,
    this.rentedAt,
    this.soldAt,
    required this.rentedBy,
    required this.soldTo,
    required this.shortDescription,
    required this.mileage,
    this.address,
    required this.ownerId,
    required this.model,
    required this.brand,
    required this.year,
    required this.color,
    required this.fuelType,
    required this.transmission,
    required this.photo,
    this.photoUrl, // Ajustado para ser String? (pode ser nulo)
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['_id'] ?? '',
      operationType: json['operationType'] ?? '',
      pricePerHour: (json['price_per_hour'] as num?)?.toDouble() ?? 0.0,
      licensePlate: json['license_plate'] ?? '',
      status: json['status'] ?? '',
      rentedAt: json['rented_at'] != null ? DateTime.tryParse(json['rented_at']) : null,
      soldAt: json['sold_at'] != null ? DateTime.tryParse(json['sold_at']) : null,
      rentedBy: json['rented_by'] ?? '',
      soldTo: json['sold_to'] ?? '',
      shortDescription: json['short_description'] ?? '',
      mileage: json['mileage'] ?? 0,
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      ownerId: json['owner_id'] ?? '',
      model: json['model'] ?? '',
      brand: json['brand'] ?? '',
      year: json['year'] ?? 0,
      color: json['color'] ?? '',
      fuelType: json['fuel_type'] ?? '',
      transmission: json['transmission'] ?? '',
      photo: json['photo'] ?? '',
      photoUrl: json['photo_url'], // Pode ser nulo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'operationType': operationType,
      'price_per_hour': pricePerHour,
      'license_plate': licensePlate,
      'status': status,
      'rented_at': rentedAt?.toIso8601String(),
      'sold_at': soldAt?.toIso8601String(),
      'rented_by': rentedBy,
      'sold_to': soldTo,
      'short_description': shortDescription,
      'mileage': mileage,
      'address': address?.toJson(),
      'owner_id': ownerId,
      'model': model,
      'brand': brand,
      'year': year,
      'color': color,
      'fuel_type': fuelType,
      'transmission': transmission,
      'photo': photo,
      'photo_url': photoUrl, // Pode ser nulo
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
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
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
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}