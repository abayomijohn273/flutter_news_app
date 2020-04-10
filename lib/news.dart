import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'model/news_detail_model.dart';
import 'style.dart';
import 'newsInfo.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // this is where the lists data will be placed
  final List<NewsDetail> items = [];

  // declaring the getNews fetch
  void getNews() async {
    final http.Response response = await http.get(
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=03256d797c6f47719a901d69cf62debf");
    final Map<String, dynamic> responseData = json.decode(response.body);
    responseData['articles'].forEach((newDetail) {
      final NewsDetail news = NewsDetail(
        description: newDetail['description'],
        title: newDetail['title'],
        url: newDetail['urlToImage'],
      );
      setState(() {
        items.add(news);
      });
    });
  }

  void initState() {
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          "Latest News",
          style: Styles.navBarTitle,
        )),
        body: (items.length == 0)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: this.items.length,
                itemBuilder: _listViewItemBuilder,
              ));
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    var newsDetail = this.items[index];
    return ListTile(
      contentPadding: EdgeInsets.all(10.0),
      leading: _itemThumbnail(newsDetail),
      title: _itemTitle(newsDetail),
      onTap: () {
        _navigateToNewsDetail(context, newsDetail);
      },
    );
  }

  Widget _itemThumbnail(NewsDetail newsDetail) {
    return Container(
      constraints: BoxConstraints.tightFor(width: 100.0),
      child: newsDetail.url == null
          ? Image.asset(
              "assets/placeholder.png",
              fit: BoxFit.fitWidth,
            )
          : Image.network(newsDetail.url, fit: BoxFit.fitWidth),
    );
  }

  Widget _itemTitle(NewsDetail newsDetail) {
    return Text(newsDetail.title, style: Styles.textDefault);
  }

// navigate to the new page with the data fetch from the api already
  void _navigateToNewsDetail(BuildContext context, NewsDetail newsDetail) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NewsInfo(newsDetail);
    }));
  }
}
