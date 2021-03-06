import 'dart:convert';
import 'dart:io';

import 'package:luca_play/helpers/snackbar_helper.dart';
import 'package:luca_play/models/video.dart';
import 'package:luca_play/routes.dart';
import 'package:luca_play/widgets/custom_appbar.dart';
import 'package:luca_play/widgets/custom_button.dart';
import 'package:luca_play/widgets/custom_typography.dart';
import 'package:luca_play/models/playlist.dart';
import 'package:luca_play/widgets/modals/upsert_playlist_modal.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class IndexScreen extends StatefulWidget {
  final Box<Playlist> playlistBox;

  IndexScreen({
    Key? key,
    required this.playlistBox,
  }) : super(key: key);

  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  bool _buttonImportLoading = false;

  Future<void> handleImportFile() async {
    setState(() {
      _buttonImportLoading = true;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result?.files.single.path != null) {
        File file = File(result!.files.single.path!);

        final importedObject = jsonDecode(await file.readAsString());

        final List<Video> videos = [];
        for (var videoObject in importedObject["videos"] ?? []) {
          videos.add(Video(
            title: videoObject["title"],
            url: videoObject["url"],
            image: videoObject["image"],
          ));
        }

        final playlist = Playlist(
          name: importedObject["name"],
          videos: videos,
        );

        await this.widget.playlistBox.add(
              playlist,
            );

        SnackbarHelper.show(
          context: context,
          text: 'Playlist importada com sucesso!',
        );
      }
    } catch (e) {
      throw e;
    } finally {
      setState(() {
        _buttonImportLoading = false;
      });
    }
  }

  Widget _buildBody(BuildContext context) {
    if (widget.playlistBox.isEmpty) {
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
      ...widget.playlistBox.values.map<Widget>((playlist) {
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
      backgroundColor: const Color(0xffF8F8F8),
      appBar: CustomAppBar(
        title: 'LUCA PLAY',
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
                onPressed: this.handleImportFile,
                icon: Icons.file_upload,
                iconPosition: IconPosition.leading,
                buttonText: 'Importar Arquivo',
                loading: _buttonImportLoading,
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
                child: UpsertPlaylistModal(
                  playlistBox: widget.playlistBox,
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
