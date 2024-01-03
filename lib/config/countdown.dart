import 'package:bidhub/config/colors.dart';
import 'package:flutter/material.dart';

class Countdown extends StatefulWidget {
  final DateTime endDate;
  const Countdown(
      {super.key, required this.endDate});

  @override
  CountdownState createState() => CountdownState();
}

class CountdownState extends State<Countdown> {
  Stream<int> _timerStream(DateTime endTime) async* {
    while (true) {
      yield endTime.difference(DateTime.now()).inSeconds;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  String _formatTime(int totalSeconds) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    int days = totalSeconds ~/ 86400;
    int hours = (totalSeconds % 86400) ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return (days > 0)
        ? '$days:${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}'
        : '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    DateTime endTime = widget.endDate;
    return StreamBuilder<int>(
      stream: _timerStream(endTime),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
        
          return Text(
            '00:00:00',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: secondaryColor),
          );
        } else {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(snapshot.data ?? 0),
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor),
                  ),
                  Text('Time left...',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: textColorDark)),
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        }
      },
    );
  }

}
