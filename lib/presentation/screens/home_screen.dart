import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_tracker/logic/cubits/coin_cubit.dart';
import 'package:crypto_tracker/logic/cubits/coin_state.dart';
import 'package:crypto_tracker/logic/cubits/theme_cubit.dart';
import 'package:crypto_tracker/presentation/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  String currentSortOption = 'All';

  Widget _buildFilterChip(String option) {
    return ChoiceChip(
      label: Text(option),
      selected: currentSortOption == option,
      onSelected: (selected) {
        setState(() {
          currentSortOption = option;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Tracker'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, stateTheme) {
              return IconButton(
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
                icon: Icon(
                  stateTheme == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CoinCubit, CoinState>(
        builder: (context, state) {
          if (state is CoinLoading) {
            return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Container(
                      width: double.infinity,
                      height: 15,
                      color: Colors.white,
                    ),
                    subtitle: Container(
                      width: 100,
                      height: 10,
                      margin: const EdgeInsets.only(top: 5),
                      color: Colors.white,
                    ),
                  ),
                );
              },
            );
          } else if (state is CoinLoaded) {
            final filteredCoins = state.coins.where((coin) {
              final nameMatch = coin.name.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );
              final symbolMatch = coin.symbol.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );
              return nameMatch || symbolMatch;
            }).toList();

            if (currentSortOption == 'Top Gainers') {
              filteredCoins.sort(
                (a, b) => b.priceChange24h.compareTo(a.priceChange24h),
              );
            } else if (currentSortOption == 'Top Losers') {
              filteredCoins.sort(
                (a, b) => a.priceChange24h.compareTo(b.priceChange24h),
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search coins..',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                setState(() {
                                  searchQuery = '';
                                });
                              },
                              icon: Icon(Icons.clear),
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Top Gainers'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Top Losers'),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await context.read<CoinCubit>().fetchCoins();
                    },
                    child: ListView.builder(
                      itemCount: filteredCoins.length,
                      itemBuilder: (context, index) {
                        final coin = filteredCoins[index];
                        return Card(
                          elevation: 2.0,
                          margin: EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: CachedNetworkImage(
                                imageUrl: coin.imageUrl,
                                width: 50,
                                height: 50,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                            title: Text(
                              coin.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(coin.symbol),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${coin.currentPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${coin.priceChange24h.toStringAsFixed(2)}%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: coin.priceChange24h >= 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen(coinModel: coin),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is CoinError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No data loaded yet'));
          }
        },
      ),
    );
  }
}
