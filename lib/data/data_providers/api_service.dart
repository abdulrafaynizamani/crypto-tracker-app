import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const URL =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=true';

  static Future<List<dynamic>> getRawCoinsData() async {
    try {
      final response = await http.get(Uri.parse(URL));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Api failed. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
