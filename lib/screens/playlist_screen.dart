import 'package:luca_play/core/service/chromecast_service.dart';
import 'package:luca_play/routes.dart';
import 'package:luca_play/widgets/custom_appbar.dart';
import 'package:luca_play/widgets/custom_button.dart';
import 'package:luca_play/widgets/custom_loading.dart';
import 'package:luca_play/widgets/custom_typography.dart';
import 'package:luca_play/models/playlist.dart';
import 'package:luca_play/widgets/modals/upsert_playlist_modal.dart';
import 'package:luca_play/widgets/modals/upsert_video_modal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PlaylistScreen extends StatelessWidget {
  final Box<Playlist> playlistBox;
  final Playlist playlist;

  PlaylistScreen({
    Key? key,
    required this.playlistBox,
    required this.playlist,
  }) : super(key: key);

  Future<void> handlePlayAll() async {
    var videos = playlist.videos ?? [];

    videos.shuffle();

    ChromecastService().loadVideosOnQueue(
      playlist,
      videos,
    );
  }

  Widget _buildBody(BuildContext context) {
    if ((playlist.videos?.length ?? 0) == 0) {
      return Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(40),
              child: CustomTypography(
                text: "Sem Vídeos",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.fromLTRB(32, 16, 24, 16),
          child: CustomButton(
            onPressed: this.handlePlayAll,
            icon: Icons.play_arrow,
            iconPosition: IconPosition.leading,
            buttonText: 'Reproduzir Todos',
          ),
        ),
        SizedBox(height: 16),
        ...(playlist.videos ?? [])
            .map<List<Widget>>((video) {
              return [
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: video.image != null
                        ? CachedNetworkImage(
                            width: 120,
                            height: 44,
                            imageUrl: video.image!,
                            placeholder: (context, url) => CustomLoading(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          )
                        : null,
                  ),
                  title: CustomTypography(
                    text: video.title,
                    textAlign: TextAlign.start,
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: () {},
                ),
                SizedBox(
                  height: 5,
                )
              ];
            })
            .expand((e) => e)
            .toList(),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      appBar: CustomAppBar(
        title: 'LUCA PLAY - ' + playlist.name,
        withLogo: false,
      ),
      body: ListView(
        children: [
          this._buildBody(context),
          Container(
            padding: EdgeInsets.fromLTRB(32, 16, 24, 16),
            child: Column(children: [
              SizedBox(height: 16),
              CustomButton(
                onPressed: () async {
                  showModalBottomSheet<void>(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: UpsertPlaylistModal(
                          playlistBox: playlistBox,
                          playlist: playlist,
                        ),
                      );
                    },
                  );
                },
                icon: Icons.edit,
                iconPosition: IconPosition.leading,
                buttonText: 'Editar',
              ),
              SizedBox(height: 16),
              CustomButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirmação"),
                        content: Text(
                          "Tem certeza que deseja apagar essa playlist?",
                        ),
                        actions: [
                          FlatButton(
                            child: Text("Não"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("Sim"),
                            onPressed: () async {
                              await playlist.delete();

                              router.navigateTo(
                                context,
                                "/",
                                transition: TransitionType.inFromLeft,
                              );
                            },
                          ),
                        ],
                      );
                      ;
                    },
                  );
                },
                backgroundColor: Colors.red,
                icon: Icons.delete,
                iconPosition: IconPosition.leading,
                buttonText: 'Apagar',
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: UpsertVideoModal(
                  playlistBox: playlistBox,
                  playlist: playlist,
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
