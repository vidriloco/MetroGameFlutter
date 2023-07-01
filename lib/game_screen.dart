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
import "menu_screen.dart";

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key, required this.levelSelected, required this.scenarioSelected, required this.mode}) : super(key: key);

  final Level levelSelected;
  final Scenario scenarioSelected;
  final GameMode mode;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  
  MapboxMapController? mapController;
  String? lastInteractedStation;
  
  List<Widget> stationWidgets = <Widget>[];

  Map<String, SymbolOptions?> availableStations = new Map<String, SymbolOptions?>.from(STATIONS);

  BehaviorSubject<String> feedbackEventsStream = new BehaviorSubject<String>();
  BehaviorSubject<String> childEventsStream = new BehaviorSubject<String>();

  Offset dragCanceledAtOffset = Offset(20, 50);
  Offset originPositionOffset = Offset(50, 50);

  Widget? mapWidget;
  
  int scenarioIndex = 0;
  int totalSeconds = 0;

  double iconWidth = 40;
  double iconHeight = 40;


  GameMode currentMode = GameMode.playing;

  @override
  void initState() {
    super.initState();
    this.mapWidget = buildMap();
    this.scenarioIndex = this.widget.scenarioSelected.id;
    this.currentMode = this.widget.mode;
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
        this.mapController?.addListener(() {
          if(!this.mapController!.isCameraMoving) {
            this.buildVisibleStations();
          }
        });
      },
      minMaxZoomPreference: MinMaxZoomPreference(15, 18),
      trackCameraPosition: true,
      initialCameraPosition: CameraPosition(
        zoom: 15.0,
        target: LatLng(19.432, -99.133)
      )
    );
  }

  void buildVisibleStations() {
    setState(() {
      stationWidgets = <Widget>[];
    });
    
    this.mapController?.symbols.forEach((symbol) async {
      List<Widget> stations = this.stationWidgets;
      
      var location = await mapController?.getSymbolLatLng(symbol);
      LatLngBounds visibleRegion = await this.mapController!.getVisibleRegion();

      if(isLatLngWithinBounds(location!, visibleRegion.southwest, visibleRegion.northeast)) {
        var screenPoint = await mapController?.toScreenLocation(location);
        var offset = Offset(screenPoint!.x.toDouble()-iconWidth/2, screenPoint.y.toDouble()-iconHeight/2);
        stations.add(this.buildDraggableStation(symbol.data?["name"], offset));
        setState(() {
          stationWidgets = stations;
        });
      }
    });
  }

  bool isLatLngWithinBounds(LatLng point, LatLng sw, LatLng ne) {
    // Check if the point is within the bounding box defined by the southwest
    // and northeast corners
    return point.latitude >= sw.latitude &&
      point.latitude <= ne.latitude &&
      point.longitude >= sw.longitude &&
      point.longitude <= ne.longitude;
  }

  LinePanel buildLinePanel() {

    return LinePanel(
      title: 'Linea 1',
      scenario: this.widget.scenarioSelected,
      onDropWillAccept: (data) {
        this.feedbackEventsStream.add("will-accept");
      },
      onDropAccept: (data) {
        this.feedbackEventsStream.add("did-accept");
        this.childEventsStream.add("hide");
      },
      onDropLeave: (data) {
        this.feedbackEventsStream.add("leave");
        this.childEventsStream.add("hide");
      },
      onCompleted: () {
        this.currentMode = GameMode.completed;
      }
    );
  }

  Widget buildStationWidget(String name, double dimension) {
    return Container(
      width: dimension,
      height: dimension,
      child: Image.asset("assets/images/${name}.png")
    );
  }

  Positioned buildDraggableStation(String station, Offset position) {

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        data: station,
        child: StreamBuilder(
          initialData: "show",
          stream: childEventsStream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return Opacity(child: buildStationWidget(station, 40), opacity: 0);
          },
        ),
        feedback: StreamBuilder(
          initialData: "nada",
          stream: feedbackEventsStream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            String shouldPresent = snapshot.data ?? "nada";
            
            if (shouldPresent == "will-accept") {
              return Opacity(child: buildStationWidget(station, 100), opacity: 1);
            } else {
              return Opacity(child: buildStationWidget(station, 70), opacity: 0.5);
            }
          },
        ),
        onDragStarted: (){ 
          this.childEventsStream.add("hide");
          this.lastInteractedStation = station;
        },
        onDragCompleted: (){
          this.removeLastInteractedStation();
          setState(() { });
        },
        onDragEnd: (details){ 
          this.childEventsStream.add("show");
        },
        onDraggableCanceled: (Velocity velocity, Offset offset){
          this.childEventsStream.add("hide");
        },
      ),
    );
  }

  void removeLastInteractedStation() {
    if(lastInteractedStation != null) {
      this.availableStations[lastInteractedStation!] = null;
    }

    this.mapController?.symbols.forEach((symbol) async {
      var symbolName = symbol.data?["name"];
      if(symbolName == lastInteractedStation) {
        this.mapController?.removeSymbol(symbol);
      }
    });
  }

  Widget buildBody(BuildContext context) {
    List<Widget> widgets = <Widget>[
      Container(
        color: Colors.blue,
        child: mapWidget
      )
    ];

    if(this.currentMode == GameMode.playing) {
      var linePanel = buildLinePanel();
      if(linePanel == null) {
        return Stack(children: widgets);
      }

      widgets.add(linePanel);

      stationWidgets.forEach((widget) {
        widgets.add(widget);
      });

      widgets.add(buildTimerWidget());

    } else if(this.currentMode == GameMode.paused || this.currentMode == GameMode.start) {
      if(this.widget.scenarioSelected != null) {
        
        widgets.add(buildChallengeDialog());
      }
    } else if(this.currentMode == GameMode.completed) {      
      widgets.add(buildCompletedLevelMenu());
    } 

    return Stack(children: widgets);
  }

  Widget buildTimerWidget() {
    return TimerDialog(
      seconds: totalSeconds,
      onTapPaused: ((seconds) {
        setState(() {
          currentMode = GameMode.paused;
          totalSeconds = totalSeconds + seconds;
        });
      })
    );
  }

  Widget buildCompletedLevelMenu() {

    return CompletedMenu(
      onTapRestart: () {
        Navigator.push(context, PageRouteBuilder(
            pageBuilder: (_, __, ___) => GameScreen(levelSelected: this.widget.levelSelected, scenarioSelected: this.widget.scenarioSelected, mode: GameMode.start),
            transitionDuration: Duration(seconds: 0),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)));
      }, 
      
      onTapReturn: () {
        setState(() {
          currentMode = GameMode.menu;
        });
      }, 
      onTapNext: () {
        var currentScenario = this.widget.scenarioSelected;
        var nextScenario = SCENARIOS.where((i) => i.id == currentScenario.id+1).toList().first;
        Navigator.push(context, PageRouteBuilder(
            pageBuilder: (_, __, ___) => GameScreen(levelSelected: this.widget.levelSelected, scenarioSelected: nextScenario, mode: GameMode.start),
            transitionDuration: Duration(seconds: 0),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)));
      });
  }

  Widget buildChallengeDialog() {
    var firstStation = this.widget.scenarioSelected.enabledStations.first;
    var stationData = this.availableStations[firstStation];

    if(stationData?.geometry != null) {
      var coordinate = (stationData?.geometry)!;
      var cameraPosition = CameraPosition(
        target: coordinate,
        zoom: 14,
      );

      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition)
      );
    }

    return ChallengeDialog(
      mainActionTitle: this.currentMode == GameMode.start  ? "Empezar" : "Continuar",
      scenario: this.widget.scenarioSelected, 
      onTapReturn: (() {
        Navigator.push(context, PageRouteBuilder(
            pageBuilder: (_, __, ___) => MenuScreen(levelSelected: 1),
            transitionDuration: Duration(seconds: 0),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c)));
      }),
      onTapStart: (() {
        this.addStations();
        setState(() {
          currentMode = GameMode.playing;
        });
      })
    );
  }

  AnimatedPositioned buildAnimatedDraggableStation() {
    return AnimatedPositioned(
      width: 50.0,
      height: 50.0,
      left: dragCanceledAtOffset.dx,
      top: dragCanceledAtOffset.dy,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      child: buildStationWidget(lastInteractedStation!, 50),
      onEnd: () {
        this.childEventsStream.add("show");
      }
    );
  }

  void addStations() {
    mapController?.setSymbolIconAllowOverlap(true);
    availableStations.forEach((name, symbolOptions) {
      if(symbolOptions != null) {
        mapController?.addSymbol(
          symbolOptions,
          { "name": name }
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context)
    );
  }

}