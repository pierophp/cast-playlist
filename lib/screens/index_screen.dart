import 'package:LucaPlay/routes.dart';
import 'package:LucaPlay/widgets/custom_typography.dart';
import 'package:LucaPlay/models/playlist.dart';
import 'package:LucaPlay/widgets/device_list.dart';
import 'package:LucaPlay/widgets/modals/add_playlist_modal.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class IndexScreen extends StatelessWidget {
  Box<Playlist> playlistBox;

  IndexScreen({
    Key key,
    Box<Playlist> this.playlistBox,
  }) : super(key: key);

  Widget _buildBody(BuildContext context) {
    if (playlistBox.isEmpty) {
      return Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(40),
              child: CustomTypography(
                text: "Sem Playlist",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: playlistBox.values.map<Widget>((playlist) {
        return ListTile(
          title: CustomTypography(
            text: playlist.name,
            textAlign: TextAlign.start,
          ),
          onTap: () {
            router.navigateTo(
              context,
              "/playlist/${playlist.key}",
              transition: TransitionType.inFromRight,
            );
          },
        );
      }).toList(),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      //body: DeviceList(),
      body: this._buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: AddPlaylistModal(
                  playlistBox: playlistBox,
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
