import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import "stations_list.dart";
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';
import 'dart:async';
import 'challenges_menu.dart';
import "levels_list.dart";
import "scenarios_list.dart";
import "challenge_dialog.dart";
import "completed_menu.dart";
import "game_screen.dart";

enum GameMode { menu, playing, start, paused, help, completed }

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key, required this.levelSelected});
  
  final int levelSelected;

  Widget buildMap() {
    final String token = 'pk.eyJ1Ijoidmlkcmlsb2NvIiwiYSI6Ik1QRzIwZmcifQ.BzdjvFURAZ8uJ6kNovrrDA';
    final String style = 'mapbox://styles/vidriloco/ckw460ag81rxb15o4cbwyvq1s';

    return MapboxMap(
      accessToken: token,
      styleString: style,
      minMaxZoomPreference: MinMaxZoomPreference(15, 18),
      trackCameraPosition: true,
      initialCameraPosition: CameraPosition(
        zoom: 15.0,
        target: LatLng(19.432, -99.133)
      )
    );
  }

  Widget buildBody(BuildContext context) {
    List<Widget> widgets = <Widget>[
      Container(
        color: Colors.blue,
        child: buildMap()
      )
    ];

    widgets.add(buildChallengeMenu(context));

    return Stack(children: widgets);
  }

  Widget buildChallengeMenu(BuildContext context) {
    return ChallengesMenu(
        title: "🚇 Todos los retos", 
        levelSelected: this.levelSelected, 
        levelAndScenarioSelected: ((level, scenario) {
          Navigator.push(context, PageRouteBuilder(
            pageBuilder: (_, __, ___) => GameScreen(levelSelected: level, scenarioSelected: scenario, mode: GameMode.start),
            transitionDuration: Duration(seconds: 0),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)));
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context)
    );
  }
}