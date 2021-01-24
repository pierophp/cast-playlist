import 'package:LucaPlay/widgets/custom_typography.dart';
import 'package:LucaPlay/models/playlist.dart';
import 'package:LucaPlay/widgets/device_list.dart';
import 'package:LucaPlay/widgets/modals/add_playlist_modal.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class IndexScreen extends StatelessWidget {
  Box<Playlist> playlistBox;

  IndexScreen({
    Key key,
    Box<Playlist> this.playlistBox,
  }) : super(key: key);

  Widget build(BuildContext context) {
    if (playlistBox.isEmpty) {
      return Text("Sem Playlists");
    }

    return Scaffold(
      //body: DeviceList(),
      body: Column(
        children: playlistBox.values.map<Widget>((playlist) {
          return ListTile(
            title: CustomTypography(
              text: playlist.name,
              textAlign: TextAlign.start,
            ),
          );
        }).toList(),
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
