import 'package:hive/hive.dart';
part 'playlist.g.dart';

class Video {
  String title;
  String url;
  String image;

  Video({
    this.title,
    this.url,
    this.image,
  });
}

@HiveType(typeId: 0)
class Playlist extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Video> videos;

  Playlist({
    this.name,
    this.videos,
  });
}
