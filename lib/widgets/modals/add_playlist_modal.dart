import 'package:LucaPlay/models/playlist.dart';
import 'package:LucaPlay/widgets/custom_button.dart';
import 'package:LucaPlay/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddPlaylistModal extends StatefulWidget {
  Box<Playlist> playlistBox;

  AddPlaylistModal({
    Key key,
    @required this.playlistBox,
  }) : super(key: key);

  @override
  createState() => AddPlaylistModalState();
}

class AddPlaylistModalState extends State<AddPlaylistModal> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: "");

  bool _buttonLoading = false;

  AddPlaylistModalState();

  onPressed() async {
    try {
      setState(() {
        _buttonLoading = true;
      });

      final form = _formKey.currentState;
      if (!form.validate()) {
        return;
      }

      await this.widget.playlistBox.add(
            Playlist(
              name: this._nameController.text,
            ),
          );

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
            Input(
              labelText: "Nome",
              controller: _nameController,
              hintText: "Preencha o nome da playlist",
              inputType: TextInputType.emailAddress,
              state: InputState.normal,
              validator: (val) {
                if (val == "") {
                  return "Preencha o nome";
                }

                return null;
              },
            ),
            SizedBox(height: 24.0),
            CustomButton(
              icon: Icons.save,
              iconPosition: IconPosition.leading,
              buttonText: "Criar",
              loading: _buttonLoading,
              onPressed: this.onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
