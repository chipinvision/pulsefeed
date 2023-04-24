import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'article_view.dart';
import '../utils/app_style.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final TextEditingController searchController = TextEditingController();

  List<dynamic> _news = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNewsArticles(searchController.text).then((news) {
      setState(() {
        isLoading = false;
        _news = news;
      });
    });
  }

  Future<List<dynamic>> fetchNewsArticles(String query) async {
    String apiUrl =
        "https://newsapi.org/v2/top-headlines?country=in&q=$query&apiKey=f38b26e86acb46c29058439829075408";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Number of articles found: ${responseBody['articles'].length}');
      return responseBody['articles'];
    } else {
      throw Exception('Failed to load news articles');
    }
  }

  void _searchNews(String query) {
    setState(() {
      isLoading = true;
    });
    fetchNewsArticles(query).then((news) {
      setState(() {
        isLoading = false;
        _news = news;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          controller: searchController,
          onSubmitted: (String value){
            _searchNews(value);
          },
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: AppStyle.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [
          SizedBox(width:10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left:15, right:15, top:3,),
        child: isLoading
            ? const Center(child: Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(),
            ))
            : Expanded(
            child: ListView.separated(
        itemCount: _news.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final article = _news[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleView(
                    url: article['url'] ?? '',
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
                          imageUrl: article['urlToImage'] ?? '',
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
          ),
        ),
      ),
    );
  }
}
