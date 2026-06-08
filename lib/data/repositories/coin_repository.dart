import 'package:crypto_tracker/data/data_providers/api_service.dart';
import 'package:crypto_tracker/data/models/coin_model.dart';
// import '';

class CoinRepository {
  static Future<List<CoinModel>> getCoins() async {
    try {
      final data = await ApiService.getRawCoinsData();

      return data.map((json) => CoinModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
