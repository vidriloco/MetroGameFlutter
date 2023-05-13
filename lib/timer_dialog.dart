import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import "levels_list.dart";
import "scenarios_list.dart";
import 'dart:async';

typedef TimerPausedCallback = void Function(int seconds);
class TimerDialog extends StatefulWidget {
  const TimerDialog({Key? key, required this.seconds, required this.onTapPaused}) : super(key: key);

    final TimerPausedCallback onTapPaused;
    final int seconds;

    @override
    State<TimerDialog> createState() => _TimerDialog();
}

class _TimerDialog extends State<TimerDialog> {
    Timer? timer;
    int ellapsedSeconds = 0;

    @override
    void initState() {
        super.initState();
        timer = Timer.periodic(Duration(seconds: 1), (_) => setCountUp());
        ellapsedSeconds = this.widget.seconds;
    }

    @override
    void dispose() {
        super.dispose();
        timer?.cancel();
    }

    void setCountUp() {
        final reduceSecondsBy = 1;

        setState(() { 
            ellapsedSeconds += reduceSecondsBy;
        });
    }

    String secondsToElapsedTime(int value) {
        int h, m, s;

        h = value ~/ 3600;
        m = ((value - h * 3600)) ~/ 60;
        s = value - (h * 3600) - (m * 60);

        var seconds = "$s";
        if(s < 10) {
        seconds = "0$s";
        }

        var minutes = "$m";
        if(m < 10) {
        minutes = "0$m";
        }

        return "${minutes}m : ${seconds}s";
    }

    Container timerWidget() {

        return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
                padding: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
                child: Text("${secondsToElapsedTime(ellapsedSeconds)}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Futura', fontSize: 15, color: Colors.black)
                )
            ),
        );
    }

    var isPauseButtonPressed = false;

    InkWell pauseButton() {
        var backgroundColor = isPauseButtonPressed ? Colors.grey : Colors.orange;

        var container = AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            onEnd: () {
                setState((){
                    isPauseButtonPressed = false;
                    this.widget.onTapPaused(ellapsedSeconds);
                });
            },
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset("assets/images/pause-icon.png")
            ),
        );

        return InkWell(
            onTap: () {
                setState((){
                    isPauseButtonPressed = true;
                });
            },
            child: container
        );
    }

    @override
    Widget build(BuildContext context) {
        return Center(
            child: Container(
            margin: const EdgeInsets.only(top: 50.0),
            width: 200,
            height: double.infinity,
            child: Column(
                children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                                children: [
                                SizedBox(width: 40, child: pauseButton()),
                                SizedBox(width: 10),
                                Expanded(child: timerWidget())
                                ]
                            )
                        )
                    )
                ]
            )
            )
        );
    }

}
