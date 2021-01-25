import 'package:cast/cast.dart';

class ChromecastService {
  static CastSession session;
  static bool connected = false;

  Future<CastSession> connect(CastDevice device) async {
    ChromecastService.session = await CastSessionManager().startSession(device);
    ChromecastService.session.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        // _sendMessage(session);

        session.messageStream.listen((message) {
          print('receive message: $message');
          print('type ${message["type"]}');

          if (message["type"] == 'RECEIVER_STATUS') {
            print("Connected");
            ChromecastService.connected = true;
          }
        });
      }
    });

    ChromecastService.session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      // 'appId': '639B1660',
      'appId': 'CC1AD845',
    });

    return ChromecastService.session;
  }
}
