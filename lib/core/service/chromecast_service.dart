import 'dart:async';

import 'package:LucaPlay/models/playlist.dart';
import 'package:LucaPlay/models/video.dart';
import 'package:cast/cast.dart';

// DOCS
// https://developers.google.com/cast/docs/reference/messages

class MediaStatus {
  int mediaSessionId;
  String playerState;
  double currentTime;
  double duration;
  double volumeLevel;

  MediaStatus({
    required this.mediaSessionId,
    required this.playerState,
    required this.currentTime,
    required this.duration,
    required this.volumeLevel,
  });
}

class ChromecastService {
  static CastSession? session;
  static CastDevice? connectedDevice;
  static bool connected = false;
  int _requestId = 1000;

  bool listenMediaStatusRunning = false;

  Future<CastSession> connect(CastDevice device) async {
    ChromecastService.session = await CastSessionManager().startSession(device);
    ChromecastService.session?.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        ChromecastService.session?.messageStream.listen((message) {
          if (message["type"] == 'RECEIVER_STATUS') {
            ChromecastService.connected = true;
            ChromecastService.connectedDevice = device;
          }
        });
      }
    });

    ChromecastService.session?.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': '639B1660',
    });

    return ChromecastService.session!;
  }

  void loadVideosOnQueue(
    Playlist playlist,
    List<Video> videos,
  ) {
    final request = {
      'requestId': 0, // A lib sobrescreve isso
      'type': 'LOAD',
      'queueData': {
        'name': playlist.name,
        'items': videos.map((video) {
          return {
            'media': {
              'contentId': video.url,
              'contentType': 'video/mp4',
              'streamType': 'BUFFERED',
              'autoplay': true,
              'metadata': {
                'type': 0,
                'metadataType': 0,
                'title': video.title,
                'images': [
                  {
                    'url': video.image,
                  }
                ]
              }
            },
          };
        }).toList(),
      },
    };

    ChromecastService.session?.sendMessage(
      CastSession.kNamespaceMedia,
      request,
    );
  }

  Future<MediaStatus?> getMediaInfo() async {
    final scopedRequestId = _requestId++;

    final request = {
      'requestId': scopedRequestId,
      'type': 'GET_STATUS',
    };

    final completer = Completer<MediaStatus?>();

    ChromecastService.session?.sendMessage(
      CastSession.kNamespaceMedia,
      request,
    );

    final listen = ChromecastService.session?.messageStream.listen((message) {
      if (message["requestId"] == scopedRequestId) {
        if (message["status"].length == 0) {
          completer.complete();
          return;
        }

        final status = message["status"][0];

        final mediaStatus = MediaStatus(
          mediaSessionId: status["mediaSessionId"],
          playerState: status["playerState"],
          currentTime: status["currentTime"].toDouble(),
          duration: status["duration"],
          volumeLevel: status["volume"]["level"].toDouble(),
        );

        completer.complete(mediaStatus);
      }
    });

    if (listen != null) {
      final response = await completer.future;

      listen.cancel();

      return response;
    }
  }

  Future<void> changeVolume(
    MediaStatus? mediaStatus,
    double level,
  ) async {
    if (mediaStatus == null) {
      return;
    }

    final scopedRequestId = _requestId++;

    final request = {
      'requestId': scopedRequestId, // A lib sobrescreve isso
      'mediaSessionId': mediaStatus.mediaSessionId,
      'type': 'SET_VOLUME',
      'volume': {
        'level': (level / 100).toStringAsFixed(2),
      },
    };

    final completer = Completer<void>();

    print(request);

    ChromecastService.session?.sendMessage(
      CastSession.kNamespaceReceiver,
      request,
    );

    final listen = ChromecastService.session?.messageStream.listen((message) {
      if (message["type"] == "INVALID_REQUEST") {
        completer.complete();
        return;
      }
      if (message["requestId"] == scopedRequestId) {
        if (message["status"].length == 0) {
          completer.complete();
          return;
        }

        final status = message["status"][0];

        final mediaStatus = MediaStatus(
          mediaSessionId: status["mediaSessionId"],
          playerState: status["playerState"],
          currentTime: status["currentTime"].toDouble(),
          duration: status["duration"],
          volumeLevel: status["volume"]["level"].toDouble(),
        );

        completer.complete(mediaStatus);
      }
    });

    if (listen != null) {
      await completer.future;

      listen.cancel();
    }
  }

  Stream<MediaStatus?> listenMediaStatus() {
    StreamController<MediaStatus?>? controller;

    Future<void> tick() async {
      final mediaStatus = await this.getMediaInfo();

      controller!.add(mediaStatus);

      if (this.listenMediaStatusRunning) {
        Future.delayed(Duration(seconds: 1), () {
          tick();
        });
      }
    }

    void startController() {
      this.listenMediaStatusRunning = true;
      tick();
    }

    void stopController() {
      this.listenMediaStatusRunning = false;
    }

    controller = StreamController<MediaStatus?>(
      onListen: startController,
      onPause: stopController,
      onResume: startController,
      onCancel: stopController,
    );

    return controller.stream;
  }
}
