import 'package:luca_play/core/service/chromecast_service.dart';
import 'package:luca_play/widgets/custom_typography.dart';
import 'package:luca_play/widgets/modals/cast_devices_modal.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? withLogo;
  final String? title;

  const CustomAppBar({
    Key? key,
    this.withLogo,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return AppBar(
      leading: canPop
          ? BackButton(
              color: Colors.black,
            )
          : null,
      title: getMain(
        this.withLogo,
        this.title,
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      actions: [
        Container(
          padding: const EdgeInsets.only(right: 5.0),
          child: IconButton(
            icon: const Icon(Icons.cast),
            color: Colors.black,
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
                    child: CastDevicesModal(),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

Widget getMain(withLogo, title) {
  if (withLogo == true) {
    return SizedBox(
      width: 32,
      height: 16,
      child: Icon(
        ChromecastService.connected ? Icons.cast_connected : Icons.cast,
        color: Colors.black,
      ),
    );
  } else if (title != null) {
    return CustomTypography(
      text: title,
      fontFamily: FontFamily.barlow_condensed,
      fontWeight: FontWeight.w600,
      fontSize: 16.0,
      color: Colors.black,
    );
  }

  return Text('Error');
}
