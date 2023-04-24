import 'package:flutter/material.dart';
import 'package:pulsefeed/utils/app_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class NewsCard extends StatefulWidget {
  const NewsCard({Key? key}) : super(key: key);

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {

  List<dynamic> _newsArticles = [];

  @override
  void initState() {
    super.initState();
    fetchNewsArticles().then((newsArticles) {
      setState(() {
        _newsArticles = newsArticles;
      });
    });
  }

  Future<List<dynamic>> fetchNewsArticles() async {
    const String apiUrl =
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=f38b26e86acb46c29058439829075408";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['articles'];
    } else {
      throw Exception('Failed to load news articles');
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: _newsArticles.length > 5 ? 5 : _newsArticles.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final article = _newsArticles[index];
          return GestureDetector(
            onTap: () {},
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0, top:8.0, bottom:6.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: article['urlToImage'] ?? '',
                          placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator(strokeWidth: 2.0,)),
                          errorWidget: (context, url, error) => Text(
                            'Unable To Fetch Image\nDue To Internal Error',
                            style: GoogleFonts.getFont(
                              'Poppins',
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppStyle.text,
                              ),
                            ),
                          ),
                          height: 200.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      article['title'] ?? '',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppStyle.text,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      article['description'] ?? '',
                      style: GoogleFonts.getFont(
                        'Poppins',
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: AppStyle.text,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index){
           return const SizedBox(height:10);
       },
    );
  }
}
