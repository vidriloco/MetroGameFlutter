import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import "scenarios_list.dart";

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
        return buildBox("empty-station");
    }

    Container buildBox(String station) {
        return Container(
            height: 100,
            width: 100,
            color: Colors.white,
            child: Image.asset('assets/images/${station}.png')
        );
    }

    DragTarget dragTarget(String identifier) {
        return DragTarget(
            builder: (context, candidateData, rejectedData) {
                return this.buildEmptyBox();
            },
            onWillAccept: (data) {
                if(identifier == data) {
                    HapticFeedback.heavyImpact();
                    this.widget.onDropWillAccept(data);
                    return true;
                }
                return false;
            },
            onAccept: (data) {
                HapticFeedback.lightImpact();
                this.enabledStations.add(data as String);
                setState(() {});
                this.widget.onDropAccept(data);
            },
            onLeave: (data) {
                this.widget.onDropLeave(data);
            },
        );
    }

    var enabledStations = SCENARIOS[0].enabledStations;
    var availableStations = SCENARIOS[0].path;

    Container buildStationsContainer() {
        List<Widget> widgets = [];

        availableStations.asMap().forEach((index, station) {
            if(index > 0) {
                widgets.add(SizedBox(width: 50));
            }

            if(enabledStations.contains(station)) {
                widgets.add(buildBox(station));
            } else {
                widgets.add(dragTarget(station));
            }
        });

        return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.only(left: 100, top: 20, right: 100, bottom: 20),
            child: Row(children: widgets)
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