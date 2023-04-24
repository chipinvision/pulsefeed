import 'package:flutter/material.dart';
import 'package:pulsefeed/utils/app_style.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/quote_model.dart';
import '../services/api_services.dart';
import '../widgets/stock_carousel.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  late Future<QuoteModel> quoteFuture = QuoteService.fetchQuote();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left:15, right:15, top:10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<QuoteModel>(
                future: quoteFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 300,
                        width: double.infinity,
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: AppStyle.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data!.text,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.getFont(
                                'Poppins',
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: AppStyle.text,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '- ${snapshot.data!.author}',
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppStyle.text,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}',
                      style: const TextStyle(
                        fontSize: 24,
                        color: AppStyle.text,
                      ),
                    );
                  }
                  return Container(
                    height: 300,
                    width: double.infinity,
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: AppStyle.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(child: CircularProgressIndicator(color: AppStyle.accent,)),
                  );
                },
              ),
              const SizedBox(height:15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Trending Stocks 🔥',
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
              const SizedBox(height:15),
              const SizedBox(
                height: 230,
                child: StockCarousel(tickers: [
                  'AAPL',
                  'MSFT',
                  'GOOGL',
                  'AMZN',
                ],),
              ),
              const SizedBox(height:15),
            ],
          ),
        ),
      ),
    );
  }
}