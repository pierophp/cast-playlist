import 'package:LucaPlay/routes.dart';
import 'package:LucaPlay/widgets/custom_button.dart';
import 'package:LucaPlay/widgets/custom_loading.dart';
import 'package:LucaPlay/widgets/custom_typography.dart';
import 'package:LucaPlay/models/playlist.dart';
import 'package:LucaPlay/widgets/modals/upsert_playlist_modal.dart';
import 'package:LucaPlay/widgets/modals/upsert_video_modal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PlaylistScreen extends StatelessWidget {
  Box<Playlist> playlistBox;
  Playlist playlist;

  PlaylistScreen({
    Key key,
    @required Box<Playlist> this.playlistBox,
    @required Playlist this.playlist,
  }) : super(key: key);

  Widget _buildBody(BuildContext context) {
    if (playlist.videos == null || playlist.videos.length == 0) {
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
        ...playlist.videos.map<Widget>((video) {
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: CachedNetworkImage(
                width: 120,
                height: 44,
                imageUrl: video.image,
                placeholder: (context, url) => CustomLoading(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            title: CustomTypography(
              text: video.title,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.bold,
            ),
            onTap: () {},
          );
        }).toList(),
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          this._buildBody(context),
          Container(
            padding: EdgeInsets.fromLTRB(32, 16, 24, 16),
            child: Column(children: [
              SizedBox(height: 16),
              CustomButton(
                onPressed: () async {
                  router.navigateTo(
                    context,
                    "/",
                    transition: TransitionType.inFromLeft,
                  );
                },
                icon: Icons.arrow_back,
                iconPosition: IconPosition.leading,
                buttonText: 'Voltar',
              ),
              SizedBox(height: 16),
              CustomButton(
                onPressed: () async {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
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
                  await playlist.delete();

                  router.navigateTo(
                    context,
                    "/",
                    transition: TransitionType.inFromLeft,
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
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
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
