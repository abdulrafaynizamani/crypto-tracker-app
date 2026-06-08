import 'package:crypto_tracker/data/models/coin_model.dart';

class CoinState {}

class CoinInitial extends CoinState {}

class CoinLoading extends CoinState {}

class CoinLoaded extends CoinState {
  final List<CoinModel> coins;

  CoinLoaded(this.coins);
}

class CoinError extends CoinState {
  final String message;

  CoinError(this.message);
}
