import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import "routes_list_page.dart";
import "line-panel.dart";
import "stations_list.dart";
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';
import 'dart:async';
import 'challenges_menu.dart';
import "levels_list.dart";
import "scenarios_list.dart";
import "challenge_dialog.dart";
import "timer_dialog.dart";
import "completed_menu.dart";
import "game_page.dart";

enum GameMode { menu, playing, start, paused, help, completed }

class MapPage extends StatefulWidget {
  const MapPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapboxMapController? mapController;
  String? lastInteractedStation;
  
  List<Widget> stationWidgets = <Widget>[];

  Map<String, SymbolOptions?> availableStations = new Map<String, SymbolOptions?>.from(STATIONS);

  BehaviorSubject<String> feedbackEventsStream = new BehaviorSubject<String>();
  BehaviorSubject<String> childEventsStream = new BehaviorSubject<String>();

  Offset dragCanceledAtOffset = Offset(20, 50);
  Offset originPositionOffset = Offset(50, 50);

  double iconWidth = 40;
  double iconHeight = 40;

  Widget? mapWidget;

  GameMode currentMode = GameMode.menu;
  Level? levelSelected;

  @override
  void initState() {
    super.initState();
    this.mapWidget = buildMap();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  Widget buildMap() {
    final String token = 'pk.eyJ1Ijoidmlkcmlsb2NvIiwiYSI6Ik1QRzIwZmcifQ.BzdjvFURAZ8uJ6kNovrrDA';
    final String style = 'mapbox://styles/vidriloco/ckw460ag81rxb15o4cbwyvq1s';

    return MapboxMap(
      accessToken: token,
      styleString: style,
      onMapCreated: (controller) async {
        this.mapController = controller;
      },
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
        child: mapWidget
      )
    ];

    widgets.add(buildChallengeMenu());

    return Stack(children: widgets);
  }

  Widget buildChallengeMenu() {
    return ChallengesMenu(
        title: "🚇 Todos los retos", 
        levelSelected: this.levelSelected?.id, 
        levelAndScenarioSelected: ((level, scenario) {
          Navigator.push(context, PageRouteBuilder(
            pageBuilder: (_, __, ___) => GamePage(levelSelected: level, scenarioSelected: scenario, mode: GameMode.start),
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