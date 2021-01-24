import 'package:hive/hive.dart';
part 'video.g.dart';

@HiveType(typeId: 1)
class Video extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  String url;
  @HiveField(2)
  String image;

  Video({
    this.title,
    this.url,
    this.image,
  });
}
