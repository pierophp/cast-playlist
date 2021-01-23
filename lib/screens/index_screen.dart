import 'package:cast/cast.dart';
import 'package:cast/device.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndexScreen extends StatelessWidget {
  CastSession session;
  IndexScreen({
    Key key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: StreamBuilder<List<CastDevice>>(
          stream: CastDiscoveryService().stream,
          initialData: CastDiscoveryService().devices,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.length == 0) {
              return Text("Carregando");
            }

            return Column(
              children: [
                ...snapshot.data.map((device) {
                  return ListTile(
                    title: Text(device.name),
                    onTap: () {
                      _connect(context, device);
                    },
                  );
                }).toList(),
                ElevatedButton(
                  child: Text("PLAY"),
                  onPressed: () {
                    print("Play");

                    session.sendMessage(CastSession.kNamespaceMedia, {
                      'requestId': 2,
                      'type': 'LOAD',
                      'media': {
                        'contentId':
                            'http://commondatastorage.googleapis.com/gtv-videos-bucket/big_buck_bunny_1080p.mp4',
                        'contentType': 'video/mp4',
                        'streamType': 'BUFFERED',
                        'autoplay': true,
                        'metadata': {
                          'type': 0,
                          'metadataType': 0,
                          'title': "Big Buck Bunny",
                          'images': [
                            {
                              'url':
                                  'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg'
                            }
                          ]
                        }
                      },
                    });
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _connect(BuildContext context, CastDevice object) async {
    session = await CastSessionManager().startSession(object);

    session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        // _sendMessage(session);

        session.messageStream.listen((message) {
          print('receive message: $message');
          print('type ${message["type"]}');

          if (message["type"] == 'RECEIVER_STATUS') {
            print("Connected");
          }
        });
      }
    });

    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      // 'appId': '639B1660',
      'appId': 'CC1AD845',
    });
  }
}
