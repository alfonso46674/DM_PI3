import 'package:equatable/equatable.dart';

import 'source.dart';

import 'package:hive/hive.dart';
part 'new.g.dart'; // flutter pub run build_runner build

@HiveType(typeId: 1, adapterName: 'NewAdapter')
class New extends Equatable {
  // @HiveField(0)
  final Source source;
  @HiveField(0)
  final String author;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String url;
  @HiveField(4)
  final String urlToImage;
  // @HiveField(4)
  final DateTime publishedAt;
  // @HiveField(7)
  final String content;

   New({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  @override
  String toString() {
    return 'New(source: $source, author: $author, title: $title, description: $description, url: $url, urlToImage: $urlToImage, publishedAt: $publishedAt, content: $content)';
  }

  factory New.fromJson(Map<String, dynamic> json) {
    return New(
      source: json['source'] == null
          ? null
          : Source.fromJson(json['source'] as Map<String, dynamic>),
      author: json['author'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      urlToImage:
          json['urlToImage'] == null ? null : json['urlToImage'] as String,
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source?.toJson(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt?.toIso8601String(),
      'content': content,
    };
  }

  New copyWith({
    Source source,
    String author,
    String title,
    String description,
    String url,
    String urlToImage,
    DateTime publishedAt,
    String content,
  }) {
    return New(
      source: source ?? this.source,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
    );
  }

  @override
  List<Object> get props {
    return [
      source,
      author,
      title,
      description,
      url,
      urlToImage,
      publishedAt,
      content,
    ];
  }
}
