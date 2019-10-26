
import 'dart:convert';

Client clientFromJson(String str) => Client.fromMap(json.decode(str));

String clientToJson(Client data) => json.encode(data.toMap());

class Client {
  int id;
  String title;
  String image;
  String url;

  Client({
    this.id,
    this.title,
    this.image,
    this.url,
  });

  factory Client.fromMap(Map<String, dynamic> json) => new Client(
    id: json["id"],
    title: json["title"],
    image: json["urlToImage"],
    url: json["url"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "image": image,
    "url": url,
  };
}
