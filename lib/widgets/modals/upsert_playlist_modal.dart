import 'package:LucaPlay/helpers/snackbar_helper.dart';
import 'package:LucaPlay/models/playlist.dart';
import 'package:LucaPlay/widgets/custom_button.dart';
import 'package:LucaPlay/widgets/custom_typography.dart';
import 'package:LucaPlay/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UpsertPlaylistModal extends StatefulWidget {
  Box<Playlist> playlistBox;
  Playlist? playlist;

  UpsertPlaylistModal({
    Key? key,
    required this.playlistBox,
    this.playlist,
  }) : super(key: key);

  @override
  createState() => UpsertPlaylistModalState();
}

class UpsertPlaylistModalState extends State<UpsertPlaylistModal> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController? _nameController;

  bool _buttonLoading = false;

  UpsertPlaylistModalState();

  initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.playlist?.name ?? "",
    );
  }

  onPressed() async {
    try {
      setState(() {
        _buttonLoading = true;
      });

      final form = _formKey.currentState!;
      if (!form.validate()) {
        return;
      }

      if (this.widget.playlist == null) {
        await this.widget.playlistBox.add(
              Playlist(
                name: this._nameController!.text,
              ),
            );

        SnackbarHelper.show(
          context: context,
          text: 'Playlist criada com sucesso!',
        );
      } else {
        final playlist = this.widget.playlist!;
        playlist.name = this._nameController!.text;
        await playlist.save();

        SnackbarHelper.show(
          context: context,
          text: 'Playlist atualizada com sucesso!',
        );
      }

      Navigator.pop(context);
    } catch (e) {
      print(e);
    } finally {
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
              text: widget.playlist == null
                  ? "CRIAR PLAYLIST"
                  : "EDITAR PLAYLIST",
              fontFamily: FontFamily.barlow_condensed,
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Colors.black,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Input(
              labelText: "Nome",
              controller: _nameController!,
              hintText: "Preencha o nome da playlist",
              inputType: TextInputType.text,
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
              buttonText: widget.playlist == null ? "Criar" : "Salvar",
              loading: _buttonLoading,
              onPressed: this.onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
