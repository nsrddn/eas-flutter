import 'package:dio/dio.dart';

class ProductServices {
  final dio = Dio();

  Future<List> getProducts() async {
    final response = await dio.get('https://fakestoreapi.com/products');

    if (response.statusCode == 200) {
      return response.data;
    }
    return [];
  }

  Future<Map<String, dynamic>> getProductByid(int id) async {
    final response = await dio.get('https://fakestoreapi.com/products/$id');

    if (response.statusCode == 200) {
      return response.data;
    }

    return {};
  }
}
