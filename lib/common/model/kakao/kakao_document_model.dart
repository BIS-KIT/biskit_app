// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class KakaoDocumentModel {
  final String id;
  final String category_name;
  final String category_group_code;
  final String category_group_name;
  final String address_name;
  final String road_address_name;
  final String eng_road_address_name;
  final String phone;
  final String place_name;
  final String place_url;
  final String distance;
  final String x;
  final String y;
  KakaoDocumentModel({
    required this.id,
    required this.category_name,
    required this.category_group_code,
    required this.category_group_name,
    required this.address_name,
    required this.road_address_name,
    required this.eng_road_address_name,
    required this.phone,
    required this.place_name,
    required this.place_url,
    required this.distance,
    required this.x,
    required this.y,
  });

  KakaoDocumentModel copyWith({
    String? id,
    String? category_name,
    String? category_group_code,
    String? category_group_name,
    String? address_name,
    String? road_address_name,
    String? eng_road_address_name,
    String? phone,
    String? place_name,
    String? place_url,
    String? distance,
    String? x,
    String? y,
  }) {
    return KakaoDocumentModel(
      id: id ?? this.id,
      category_name: category_name ?? this.category_name,
      category_group_code: category_group_code ?? this.category_group_code,
      category_group_name: category_group_name ?? this.category_group_name,
      address_name: address_name ?? this.address_name,
      road_address_name: road_address_name ?? this.road_address_name,
      eng_road_address_name:
          eng_road_address_name ?? this.eng_road_address_name,
      phone: phone ?? this.phone,
      place_name: place_name ?? this.place_name,
      place_url: place_url ?? this.place_url,
      distance: distance ?? this.distance,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_name': category_name,
      'category_group_code': category_group_code,
      'category_group_name': category_group_name,
      'address_name': address_name,
      'road_address_name': road_address_name,
      'eng_road_address_name': eng_road_address_name,
      'phone': phone,
      'place_name': place_name,
      'place_url': place_url,
      'distance': distance,
      'x': x,
      'y': y,
    };
  }

  factory KakaoDocumentModel.fromMap(Map<String, dynamic> map) {
    return KakaoDocumentModel(
      id: map['id'] ?? '',
      category_name: map['category_name'] ?? '',
      category_group_code: map['category_group_code'] ?? '',
      category_group_name: map['category_group_name'] ?? '',
      address_name: map['address_name'] ?? '',
      road_address_name: map['road_address_name'] ?? '',
      eng_road_address_name: map['eng_road_address_name'] ?? '',
      phone: map['phone'] ?? '',
      place_name: map['place_name'] ?? '',
      place_url: map['place_url'] ?? '',
      distance: map['distance'] ?? '',
      x: map['x'] ?? '',
      y: map['y'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory KakaoDocumentModel.fromJson(String source) =>
      KakaoDocumentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'KakaoDocumentModel(id: $id, category_name: $category_name, category_group_code: $category_group_code, category_group_name: $category_group_name, address_name: $address_name, road_address_name: $road_address_name, eng_road_address_name: $eng_road_address_name, phone: $phone, place_name: $place_name, place_url: $place_url, distance: $distance, x: $x, y: $y)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KakaoDocumentModel &&
        other.id == id &&
        other.category_name == category_name &&
        other.category_group_code == category_group_code &&
        other.category_group_name == category_group_name &&
        other.address_name == address_name &&
        other.road_address_name == road_address_name &&
        other.eng_road_address_name == eng_road_address_name &&
        other.phone == phone &&
        other.place_name == place_name &&
        other.place_url == place_url &&
        other.distance == distance &&
        other.x == x &&
        other.y == y;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        category_name.hashCode ^
        category_group_code.hashCode ^
        category_group_name.hashCode ^
        address_name.hashCode ^
        road_address_name.hashCode ^
        eng_road_address_name.hashCode ^
        phone.hashCode ^
        place_name.hashCode ^
        place_url.hashCode ^
        distance.hashCode ^
        x.hashCode ^
        y.hashCode;
  }
}
