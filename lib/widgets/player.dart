import 'package:luca_play/core/service/chromecast_service.dart';
import 'package:luca_play/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  double progressBarWidth = 5;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaStatus?>(
        stream: ChromecastService().listenMediaStatus(),
        builder: (context, snapshot) {
          return Column(
            children: [
              SleekCircularSlider(
                min: 0,
                max: 100,
                initialValue: 100,
                appearance: CircularSliderAppearance(
                  size: 300,
                  animationEnabled: false,
                  customWidths: CustomSliderWidths(
                    progressBarWidth: progressBarWidth,
                    handlerSize: 10,
                  ),
                  customColors: CustomSliderColors(
                    trackColor: Colors.yellow,
                    progressBarColors: [
                      Colors.yellow[200]!,
                      Colors.yellow[600]!,
                      Colors.yellow[700]!,
                    ],
                    dotColor: Colors.yellow[800]!,
                    hideShadow: true,
                  ),
                ),
                onChangeStart: (double value) {
                  setState(() {
                    progressBarWidth = 5;
                  });
                },
                onChangeEnd: (double value) {
                  setState(() {
                    progressBarWidth = 10;
                  });

                  ChromecastService().changeVolume(snapshot.data, value);
                },
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    child: CustomButton(
                      fontSize: 30,
                      icon: Icons.skip_previous,
                      iconPosition: IconPosition.leading,
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      fontSize: 30,
                      icon: Icons.play_arrow,
                      iconPosition: IconPosition.leading,
                      onPressed: () {},
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      fontSize: 30,
                      icon: Icons.skip_next,
                      iconPosition: IconPosition.leading,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
