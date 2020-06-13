import 'dart:convert';
import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

class Place {
  static Map<String, dynamic> districts = {
    'District1': 'Quận 1, TP.HCM',
    'District2': 'Quận 2, TP.HCM',
    'District3': 'Quận 3, TP.HCM',
    'District4': 'Quận 4, TP.HCM',
    'District5': 'Quận 5, TP.HCM',
    'District6': 'Quận 6, TP.HCM',
    'District7': 'Quận 7, TP.HCM',
    'District8': 'Quận 8, TP.HCM',
    'District9': 'Quận 9, TP.HCM',
    'District10': 'Quận 10, TP.HCM',
    'District11': 'Quận 11, TP.HCM',
    'District12': 'Quận 12, TP.HCM',
    'ThuDuc': 'Thủ Đức, TP.HCM',
    'BinhThanh': 'Bình Thạnh, TP.HCM',
    'TanBinh': 'Tân Bình, TP.HCM',
    'GoVap': 'Gò Vấp, TP.HCM',
    'PhuNhuan': 'Phú Nhuận, TP.HCM',
    'TanPhu': 'Tân Phú, TP.HCM',
    'BinhTan': 'Bình Tân, TP.HCM',
  };

  static Future<List<List<double>>> getPoints(String district) async {
    if (districts.containsKey(district)) {
      final jsonData = await rootBundle.loadString('assets/storage/${district.toLowerCase()}.json');
      final jsonMap = json.decode(jsonData);

      return jsonMap['points'];
    } else {
      throw new Error();
    }
  }
}
