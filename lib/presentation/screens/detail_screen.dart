import 'package:crypto_tracker/data/models/coin_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DetailScreen extends StatelessWidget {
  final CoinModel coinModel;
  const DetailScreen({required this.coinModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(coinModel.imageUrl, height: 70, width: 70),
            SizedBox(height: 15),
            Text(
              '${coinModel.name} (${coinModel.symbol})',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '\$${coinModel.currentPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  coinModel.priceChange24h >= 0
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  color: coinModel.priceChange24h >= 0
                      ? Colors.green
                      : Colors.red,
                ),
                SizedBox(width: 5),
                Text(
                  '${coinModel.priceChange24h.toStringAsFixed(2)}% (24h)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: coinModel.priceChange24h >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            const Text(
              '7-day Sparkline',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          coinModel.sparkline.length,
                          (index) => FlSpot(
                            index.toDouble(),
                            coinModel.sparkline[index],
                          ),
                        ),
                        isCurved: true,
                        color: coinModel.priceChange24h >= 0
                            ? Colors.green
                            : Colors.red,
                        barWidth: 2,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          gradient: LinearGradient(
                            colors: [
                              (coinModel.priceChange24h >= 0
                                      ? Colors.green
                                      : Colors.red)
                                  .withValues(alpha: 0.2),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          show: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Market Cap',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatCompactNumber(coinModel.marketCap),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(height: 40, width: 1, color: Colors.grey[300]),
                  Column(
                    children: [
                      const Text(
                        'Volume (24h)',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatCompactNumber(coinModel.volume24h),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatCompactNumber(double number) {
    if (number >= 100000000) {
      return '\$${(number / 100000000).toStringAsFixed(2)}B';
    } else if (number >= 1000000) {
      return '\$${(number / 1000000).toStringAsFixed(2)}M';
    } else {
      return '\$${number.toStringAsFixed(2)}';
    }
  }
}
