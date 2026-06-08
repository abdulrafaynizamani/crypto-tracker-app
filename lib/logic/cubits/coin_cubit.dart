import 'package:crypto_tracker/data/models/coin_model.dart';
import 'package:crypto_tracker/data/repositories/coin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_tracker/logic/cubits/coin_state.dart';
import 'package:hive/hive.dart';

class CoinCubit extends Cubit<CoinState> {
  CoinCubit() : super(CoinInitial()) {
    fetchCoins();
  }

  Future<void> fetchCoins() async {
    try {
      final box = Hive.box('coinsBox');

      // await box.clear();

      if (box.isNotEmpty) {
        final cachedCoins = box.values.cast<CoinModel>().toList();
        emit(CoinLoaded(cachedCoins));
      } else {
        emit(CoinLoading());
      }

      final coins = await CoinRepository.getCoins();

      await box.clear();
      await box.addAll(coins);
      emit(CoinLoaded(coins));
    } catch (e) {
      if (state is! CoinLoaded) {
        emit(CoinError(e.toString()));
      }
    }
  }
}
