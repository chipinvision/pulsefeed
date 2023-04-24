import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/stock_card.dart';

class StockCarousel extends StatelessWidget {
  final List<String> tickers;

  const StockCarousel({super.key, required this.tickers});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 500,
        enableInfiniteScroll: false,
        viewportFraction: 0.8,
        aspectRatio: 16 / 9,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: tickers.map((ticker) => StockCard(ticker: ticker)).toList(),
    );
  }
}
