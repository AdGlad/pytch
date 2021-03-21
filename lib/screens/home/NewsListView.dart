import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';


  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }


class News {

  final String status;
  final int totalResults;
  final List<Article> articles;

  News({this.status, this.totalResults, this.articles});

  factory News.fromJson(Map<String, dynamic> json) {

    var list = json['articles'] as List;
    print(list.runtimeType);
    List<Article> articlesList = list.map((i) => Article.fromJson(i)).toList();

    return News(
      status:json['status'],
      totalResults:json['totalResults'],     
      articles:articlesList

    );
  }

}

class Article {
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Article({this.author, this.title, this.description, this.url, this.urlToImage, this.publishedAt, this.content});
  
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      author:json['author'],
      title:json['title'],
      description:json['description'],
      url:json['url'],
      urlToImage:json['urlToImage'],
      publishedAt:json['publishedAt'],
      content:json['content'],
    );
  }
}






class NewsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: _fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Article> data = snapshot.data;
          return _newsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Article>> _fetchNews() async {

   // final newsListAPIUrl = 'https://newsapi.org/v2/everything?qInTitle=(+vaping AND +health)&apiKey=e902985b45cf4d72a4a2f8bb2dc2ae19';
    final newsListAPIUrl = 'https://newsapi.org/v2/everything?qInTitle=(+vaping)&apiKey=e902985b45cf4d72a4a2f8bb2dc2ae19';
    final response = await http.get(newsListAPIUrl);

    if (response.statusCode == 200) {
      Map jsonResponse = json.decode(response.body);
      News news = new News.fromJson(jsonResponse);
      return news.articles;
      //return jsonResponse.map((news) => new News().fromJson(news))
    } else {
      throw Exception('Failed to load news from API');
    }
  }

  ListView _newsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        itemCount: data.length,
        itemBuilder: (context, index) {
          //return _tile(data[index].title, data[index].content,data[index].urlToImage, Icons.work
          return _card(data[index].title, data[index].description, data[index].content, data[index].urlToImage, data[index].url, data[index].publishedAt,Icons.work
          );
        });
  }

  ListTile _tile(String title, String description,  String subtitle, String urlToImage, String url, IconData icon) => ListTile(
        title: Text(title, 
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 10,
            )),
        subtitle: Text(subtitle, 
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 10,
            )),
        leading: Image.network(urlToImage),
     //   leading: Icon(
     //     icon,
     //     color: Colors.blue[500],
     //   ),
      //  trailing: Image.network(urlToImage),
      );

  Card _card(String title, String description, String subtitle, String urlToImage, String url, String publishedAt, IconData icon) => Card(
          color: Colors.white,
        child: Column(
          children: [
            //new Container( margin: const EdgeInsets.all(10.0), width: 350.0, padding: const EdgeInsets.all(8.0), child: Text(title)),
            new Container(
              margin: const EdgeInsets.all(10.0),
              width: 350.0,
              //height: 350.0,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container( child: Text(title, style: new TextStyle(fontWeight: FontWeight.bold) ), margin: const EdgeInsets.all(10.0), width: 350.0, padding: const EdgeInsets.all(8.0)),
                  Container( child: Image.network(urlToImage), width: 350.0, padding: const EdgeInsets.all(8.0) ),
                  Container( child: Text(description, style: TextStyle(color: Colors.black.withOpacity(0.5))),padding: const EdgeInsets.all(10.0)),
                  //Container( child: Text(DateTime.parse(publishedAt).toLocal., style: TextStyle(color: Colors.black.withOpacity(0.5))),padding: const EdgeInsets.all(10.0)),
                  //Container( child: Text(publishedAt, style: TextStyle(color: Colors.black.withOpacity(0.5))),padding: const EdgeInsets.all(10.0)),
                  Container( child: Linkify(onOpen: _onOpen,text: url)),
                //  Container( child:Text(url, style: TextStyle(color: Colors.black.withOpacity(0.5))),padding: const EdgeInsets.all(10.0)),
                ],
              ),
            )
          ],
         //crossAxisAlignment: CrossAxisAlignment.start,
        ));
}
