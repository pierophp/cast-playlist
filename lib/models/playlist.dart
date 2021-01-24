import 'package:hive/hive.dart';
part 'playlist.g.dart';

@HiveType(typeId: 0)
class Playlist {
  @HiveField(0)
  String name;
}
