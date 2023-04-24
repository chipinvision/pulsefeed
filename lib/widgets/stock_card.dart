import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pulsefeed/utils/app_style.dart';
import 'package:google_fonts/google_fonts.dart';

class StockCard extends StatefulWidget {

  final String ticker;
  const StockCard({super.key, required this.ticker});

  @override
  StockCardState createState() => StockCardState();
}

class StockCardState extends State<StockCard> {
  Map<String, dynamic> _stockData = {};
  bool _isLoading = true;

  Future<Map<String, dynamic>> fetchStockData() async {
    final response = await http.get(
      Uri.parse(
          'https://api.twelvedata.com/time_series?symbol=${widget.ticker}&interval=1day&outputsize=1&apikey=c4062f1f7148490cb486b214ffeefb32'),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['values'][0];
    } else {
      throw Exception('Failed to load stock data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStockData().then((stockData) {
      setState(() {
        _isLoading = false;
        _stockData = stockData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            padding: const EdgeInsets.only(left: 15.0, top:5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.ticker,
                  style: GoogleFonts.getFont(
                    'Poppins',
                    textStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppStyle.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
           ListTile(
            title: Text(
                'Current Price:',
              style: GoogleFonts.getFont(
                'Poppins',
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppStyle.text,
                ),
              ),
            ),
            trailing: Text(
              _stockData['high']?.toString() ?? '',
              style: GoogleFonts.getFont(
                'Poppins',
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.primary,
                ),
              ),
            ),
          ),
           ListTile(
            title: Text(
                'High:',
              style: GoogleFonts.getFont(
                'Poppins',
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppStyle.text,
                ),
              ),
            ),
            trailing: Text(
                _stockData['high']?.toString() ?? '',
              style: GoogleFonts.getFont(
                'Poppins',
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.secondary,
                ),
              ),
            ),
          ),
           ListTile(
            title: Text(
                'Low:',
              style: GoogleFonts.getFont(
                'Poppins',
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppStyle.text,
                ),
              ),
            ),
            trailing: Text(
                _stockData['low']?.toString() ?? '',
              style: GoogleFonts.getFont(
                'Poppins',
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.accent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

