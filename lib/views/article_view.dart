import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/app_style.dart';

class ArticleView extends StatefulWidget {

  final String url;

  const ArticleView({Key? key, required this.url}) : super(key: key);

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: AppStyle.text),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

