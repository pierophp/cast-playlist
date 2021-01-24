import 'package:LucaPlay/models/video.dart';
import 'package:hive/hive.dart';
part 'playlist.g.dart';

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
