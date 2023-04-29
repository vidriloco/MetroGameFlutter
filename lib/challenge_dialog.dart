import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import "levels_list.dart";
import "scenarios_list.dart";

class ChallengeDialog extends StatefulWidget {
  const ChallengeDialog({Key? key, required this.scenario, required this.onTapStart, required this.onTapReturn }) : super(key: key);

    final Scenario scenario;
    final Function onTapStart;
    final Function onTapReturn;

    @override
    State<ChallengeDialog> createState() => _ChallengeDialog();
}

class _ChallengeDialog extends State<ChallengeDialog> {

    var isBackButtonPressed = false;
    var isStartButtonPressed = false;

    @override
    void initState() {
        super.initState();
    }

    @override
    void dispose() {
        super.dispose();
    }

    ListTile buildTextContent() {
        return ListTile(
            contentPadding: EdgeInsets.only(left: 20, right: 0.0),
            leading: Text(widget.scenario.icon, style: TextStyle(fontSize: 40)),
            title: Text(widget.scenario.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Futura', color: Colors.black)
            )
        );
    }

    Widget buildOriginDestination() {
        return Padding(
            padding: EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Expanded(child: Image.asset("assets/images/${widget.scenario.enabledStations.first}.png")),
                    SizedBox(width: 20),
                    Expanded(child: Image.asset("assets/images/intra-station-icon.jpg")),
                    SizedBox(width: 20),
                    Expanded(child: Image.asset("assets/images/${widget.scenario.enabledStations.last}.png"))
                ]
            )
        );
    }

    InkWell backButton() {
        var backgroundColor = isBackButtonPressed ? Colors.grey : Color.fromRGBO(38, 124, 232, 1);

        var container = AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            onEnd: () {
                setState((){
                    isBackButtonPressed = false;
                    this.widget.onTapReturn();
                });
            },
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
                padding: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
                child: Text("Regresar",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Futura', fontSize: 15, color: Colors.white)
                )
            ),
        );

        return InkWell(
            onTap: () {
                setState((){
                    isBackButtonPressed = true;
                });
            },
            child: container
        );
    }

    InkWell startButton() {
        var backgroundColor = isStartButtonPressed ? Colors.grey : Color(0xFFFF7A00);

        var container = AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            onEnd: () {
                setState((){
                    isStartButtonPressed = false;
                    this.widget.onTapStart();
                });
            },
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
                padding: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
                child: Text("Empezar",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Futura', fontSize: 15, color: Colors.white)
                )
            ),
        );

        return InkWell(
            onTap: () {
                setState((){
                    isStartButtonPressed = true;
                });
            },
            child: container
        );
    }

    @override
    Widget build(BuildContext context) {
        var container = Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                        ),
                        width: 300,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                                children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                            children: [
                                                SizedBox(height: 10),
                                                buildTextContent(),
                                                buildOriginDestination(),
                                            ]
                                        )
                                    ),
                                    SizedBox(height: 10),
                                    startButton(),
                                    SizedBox(height: 10),
                                    backButton()
                                ]
                            )
                        )
                    )
                ]
            )
        );
        
        return container;
    }
}