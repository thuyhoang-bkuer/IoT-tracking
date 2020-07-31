import 'dart:convert';
import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

class Place {
  static Map<String, dynamic> districts = {
    'district1': 'Quận 1, TP.HCM',
    'district2': 'Quận 2, TP.HCM',
    'district3': 'Quận 3, TP.HCM',
    'district4': 'Quận 4, TP.HCM',
    'district5': 'Quận 5, TP.HCM',
    'district6': 'Quận 6, TP.HCM',
    'district7': 'Quận 7, TP.HCM',
    'district8': 'Quận 8, TP.HCM',
    'district9': 'Quận 9, TP.HCM',
    'district10': 'Quận 10, TP.HCM',
    'district11': 'Quận 11, TP.HCM',
    'district12': 'Quận 12, TP.HCM',
    'thuduc': 'Thủ Đức, TP.HCM',
    'binhthanh': 'Bình Thạnh, TP.HCM',
    'tanbinh': 'Tân Bình, TP.HCM',
    'govap': 'Gò Vấp, TP.HCM',
    'phunhuan': 'Phú Nhuận, TP.HCM',
    'tanphu': 'Tân Phú, TP.HCM',
    'binhtan': 'Bình Tân, TP.HCM',
    'dalat': 'TP. Đà Lạt'
  };

  static Future<List<dynamic>> getPoints(String district) async {
    if (districts.containsKey(district)) {
      final jsonData = await rootBundle.loadString('assets/storage/${district.toLowerCase()}.json');
      final jsonMap = json.decode(jsonData);

      return jsonMap['points'];
    } else {
      throw new Error();
    }
  }
}
