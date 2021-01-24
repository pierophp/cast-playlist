import 'package:LucaPlay/models/playlist.dart';
import 'package:LucaPlay/widgets/custom_button.dart';
import 'package:LucaPlay/widgets/custom_typography.dart';
import 'package:LucaPlay/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddVideoModal extends StatefulWidget {
  Box<Playlist> playlistBox;
  Playlist playlist;

  AddVideoModal({
    Key key,
    @required this.playlistBox,
    @required this.playlist,
  }) : super(key: key);

  @override
  createState() => AddVideoModalState();
}

class AddVideoModalState extends State<AddVideoModal> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController(text: "");
  final _imageController = TextEditingController(text: "");
  final _urlController = TextEditingController(text: "");

  bool _buttonLoading = false;

  AddVideoModalState();

  onPressed() async {
    try {
      setState(() {
        _buttonLoading = true;
      });

      final form = _formKey.currentState;
      if (!form.validate()) {
        return;
      }

      if (this.widget.playlist.videos == null) {
        this.widget.playlist.videos = [];
      }

      this.widget.playlist.videos.add(Video(
            title: this._titleController.text,
            url: this._urlController.text,
            image: this._imageController.text,
          ));

      await this.widget.playlist.save();

      Navigator.pop(context);
    } catch (e) {} finally {
      setState(() {
        _buttonLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 32, 24, 24),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTypography(
              text: "ADICIONAR VÍDEO",
              fontFamily: FontFamily.barlow_condensed,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Colors.black,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Input(
              labelText: "Título",
              controller: _titleController,
              hintText: "Preencha o título",
              inputType: TextInputType.text,
              state: InputState.normal,
              validator: (val) {
                if (val == "") {
                  return "Preencha o título";
                }

                return null;
              },
            ),
            SizedBox(height: 24.0),
            Input(
              labelText: "URL",
              controller: _urlController,
              hintText: "Preencha a URL",
              inputType: TextInputType.text,
              state: InputState.normal,
              validator: (val) {
                if (val == "") {
                  return "Preencha a URL";
                }

                return null;
              },
            ),
            SizedBox(height: 24.0),
            Input(
              labelText: "Imagem",
              controller: _imageController,
              hintText: "Preencha a imagem",
              inputType: TextInputType.text,
              state: InputState.normal,
              validator: (val) {
                return null;
              },
            ),
            SizedBox(height: 24.0),
            CustomButton(
              icon: Icons.save,
              iconPosition: IconPosition.leading,
              buttonText: "Adicionar",
              loading: _buttonLoading,
              onPressed: this.onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
