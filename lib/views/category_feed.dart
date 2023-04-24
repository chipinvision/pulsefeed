import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../utils/app_style.dart';
import 'article_view.dart';

class CategoryFeed extends StatefulWidget {

  final String category;
  final String displayTitle;
  const CategoryFeed({Key? key, required this.category, required this.displayTitle}) : super(key: key);

  @override
  State<CategoryFeed> createState() => _CategoryFeedState();
}

class _CategoryFeedState extends State<CategoryFeed> {

  List<dynamic> _newsList = [];

  @override
  void initState() {
    super.initState();
    fetchNews(widget.category).then((newsList) {
      setState(() {
        _newsList = newsList;
      });
    });
  }

  Future<List<dynamic>> fetchNews(String category) async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=f38b26e86acb46c29058439829075408'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return json['articles'];
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: AppStyle.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.displayTitle,
          style: GoogleFonts.getFont(
            'Poppins',
            textStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppStyle.text,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left:15, right:15, top:3),
          child: _newsList == null
          ? const Center(child: CircularProgressIndicator(color: AppStyle.accent,))
          : ListView.separated(
              itemBuilder: (BuildContext context, int index){
                final news = _newsList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleView(
                          url: news['url'] ?? '',
                        ),
                      ),
                    );
                  },
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
                                imageUrl: news['urlToImage'] ?? '',
                                placeholder: (context, url) =>
                                const Center(child: CircularProgressIndicator(strokeWidth: 2.0,)),
                                errorWidget: (context, url, error) => Center(
                                  child: Text(
                                    'Unable To Fetch Image\nDue To Internal Error',
                                    textAlign: TextAlign.center,
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
                            news['title'] ?? '',
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
                            news['description'] ?? '',
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
              itemCount: _newsList != null ? _newsList.length : 0,
          ),
        ),
      ),
    );
  }
}
