import 'package:equatable/equatable.dart';

import 'source.dart';

class NewFirebase extends Equatable {
  final String author;
  final String title;
  final String description;
  final String urlToImage;

  const NewFirebase({
    this.author,
    this.title,
    this.description,
    this.urlToImage,
  });

  @override
  String toString() {
    return 'New( author: $author, title: $title, description: $description,  urlToImage: $urlToImage)';
  }

  factory NewFirebase.fromJson(Map<String, dynamic> json) {
    return NewFirebase(
      author: json['author'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      urlToImage: json['urlToImage'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
    };
  }

  NewFirebase copyWith({
    String author,
    String title,
    String description,
    String urlToImage,
  }) {
    return NewFirebase(
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      urlToImage: urlToImage ?? this.urlToImage,
    );
  }

  @override
  List<Object> get props {
    return [
      author,
      title,
      description,
      urlToImage,
    ];
  }
}
