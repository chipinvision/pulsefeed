import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pulsefeed/models/quote_model.dart';

class QuoteService {
  static const _baseUrl = 'https://zenquotes.io/api/random';

  static Future<QuoteModel> fetchQuote() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)[0];
      return QuoteModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch quote');
    }
  }
}

