import 'package:LucaPlay/core/service/chromecast_service.dart';
import 'package:LucaPlay/widgets/custom_loading.dart';
import 'package:LucaPlay/widgets/custom_typography.dart';
import 'package:cast/cast.dart';
import 'package:flutter/material.dart';

class CastDevicesModal extends StatefulWidget {
  CastDevicesModal({
    Key? key,
  }) : super(key: key);

  @override
  createState() => CastDevicesModalState();
}

class CastDevicesModalState extends State<CastDevicesModal> {
  CastDevicesModalState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: StreamBuilder<List<CastDevice>>(
        stream: CastDiscoveryService().stream,
        initialData: CastDiscoveryService().devices,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CustomLoading();
          }

          return Column(
            children: [
              CustomTypography(
                text: "DISPOSITIVOS",
                fontFamily: FontFamily.barlow_condensed,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors.black,
                textAlign: TextAlign.center,
              ),
              ...snapshot.data!.map((device) {
                return ListTile(
                  title: Text(device.name),
                  onTap: () async {
                    await ChromecastService().connect(device);

                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
