import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

typedef LinePanelStationDropWillAccept = void Function(Object? data);
typedef LinePanelStationDropAccept = void Function(Object? data);
typedef LinePanelStationDropLeave = void Function(Object? data);

class LinePanel extends StatefulWidget {
  const LinePanel({Key? key, 
    required this.title, 
    required this.onDropWillAccept, 
    required this.onDropAccept,
    required this.onDropLeave}) : super(key: key);

  final String title;
  final LinePanelStationDropWillAccept onDropWillAccept;
  final LinePanelStationDropWillAccept onDropAccept;
  final LinePanelStationDropWillAccept onDropLeave;

  @override
  State<LinePanel> createState() => _LinePanelState();
}

class _LinePanelState extends State<LinePanel> {
    Container buildEmptyBox() {
        return Container(
            height: 80,
            width: 80,
            color: Colors.white,
            child: Image.asset('assets/images/empty-station.png')
        );
    }

    Container buildBox(String title, Color color) {
        return Container(
            width: 40,
            height: 40,
            color: color,
            child: Center(
                child: Text(title,
                    style: TextStyle(fontSize: 18, color: Colors.black)
                )
            )
        );
    }

    DragTarget dragTarget() {
        return DragTarget(
            builder: (context, candidateData, rejectedData) {
            return Container(
                height: 80,
                width: 80,
                color: Colors.white,
                child: Image.asset('assets/images/empty-station.png')
            );
            },
            onWillAccept: (data) {
                this.widget.onDropWillAccept(data);
                return true;
            },
            onAccept: (data) {
                this.widget.onDropAccept(data);
            },
            onLeave: (data) {
                this.widget.onDropLeave(data);
            },
        );
    }

    Container buildStationsContainer() {
        return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.only(left: 100, top: 20, right: 100, bottom: 20),
                child: Row(
                    children: <Widget>[
                    Container(
                        height: 80,
                        width: 80,
                        color: Colors.white,
                        child: Image.asset('assets/images/insurgentes-station.png')
                    ),
                    SizedBox(width: 50),
                    Container(
                        height: 80,
                        width: 80,
                        child: this.dragTarget()
                    ),
                    SizedBox(width: 50),
                    buildEmptyBox(),
                    SizedBox(width: 50),
                    buildEmptyBox(),
                    SizedBox(width: 50),
                    Container(
                        height: 80,
                        width: 80,
                        color: Colors.white,
                        child: Image.asset('assets/images/garibaldi-station.png')
                    )
                ]
            )
        );
    }

    @override
    Widget build(BuildContext context) {
        return Positioned(
            left: -50,
            right: -50,
            bottom: 50,
            child: Container(
                height: 150,
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: buildStationsContainer()
                )
            )
        );
    }
}