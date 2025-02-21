import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiUrl = "https://fakestoreapi.com/products";

class ApiService {
  static Future<List<dynamic>> fetchProducts() async{
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200){
      return jsonDecode(response.body);

    }
    else{
      throw Exception("Failed to load products");
    }
  }
}