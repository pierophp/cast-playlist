import 'package:LucaPlay/routes.dart';
import 'package:LucaPlay/widgets/custom_button.dart';
import 'package:LucaPlay/widgets/custom_typography.dart';
import 'package:LucaPlay/models/playlist.dart';
import 'package:LucaPlay/widgets/modals/upsert_playlist_modal.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class IndexScreen extends StatelessWidget {
  Box<Playlist> playlistBox;

  IndexScreen({
    Key key,
    Box<Playlist> this.playlistBox,
  }) : super(key: key);

  Future<void> handleImportFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
  }

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

    return Column(children: [
      ...playlistBox.values.map<Widget>((playlist) {
        return ListTile(
          title: CustomTypography(
            text: playlist.name,
            textAlign: TextAlign.start,
            fontWeight: FontWeight.bold,
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
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          this._buildBody(context),
          Container(
            padding: EdgeInsets.fromLTRB(32, 16, 24, 16),
            child: Column(children: [
              SizedBox(height: 16),
              CustomButton(
                onPressed: this.handleImportFile,
                icon: Icons.file_upload,
                iconPosition: IconPosition.leading,
                buttonText: 'Importar Arquivo',
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
                child: UpsertPlaylistModal(
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
