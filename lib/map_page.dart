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

enum GameMode { menu, playing, start, paused, help }

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

  Map<String, SymbolOptions?> availableStations = STATIONS;

  BehaviorSubject<String> feedbackEventsStream = new BehaviorSubject<String>();
  BehaviorSubject<String> childEventsStream = new BehaviorSubject<String>();

  Offset dragCanceledAtOffset = Offset(20, 50);
  Offset originPositionOffset = Offset(50, 50);

  double iconWidth = 40;
  double iconHeight = 40;

  Widget? mapWidget;

  GameMode currentMode = GameMode.menu;
  Level? levelSelected;
  Scenario? scenarioSelected;
  int totalSeconds = 0;

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

  LinePanel? buildLinePanel() {

    if(this.scenarioSelected == null) {
      return null;
    }

    return LinePanel(
      title: 'Linea 1',
      scenario: this.scenarioSelected!,
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
      }
    );
  }

  Widget buildStationWidget(String name) {
    return Container(
      width: this.iconWidth,
      height: this.iconHeight,
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
            return Opacity(child: buildStationWidget(station), opacity: 0);
          },
        ),
        feedback: StreamBuilder(
          initialData: "nada",
          stream: feedbackEventsStream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            String shouldPresent = snapshot.data ?? "nada";
            
            if (shouldPresent == "will-accept") {
              return Opacity(child: buildStationWidget(station), opacity: 1);
            } else {
              return Opacity(child: buildStationWidget(station), opacity: 0.5);
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
      if(this.scenarioSelected != null) {
        
        var firstStation = this.scenarioSelected!.enabledStations.first;
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
        
        widgets.add(buildChallengeDialog());
      }
    } else {
      widgets.add(buildChallengeMenu());
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

  Widget buildChallengeDialog() {
    return ChallengeDialog(
      mainActionTitle: this.currentMode == GameMode.start  ? "Empezar" : "Continuar",
      scenario: this.scenarioSelected!, 
      onTapReturn: (() {
        setState(() {
          totalSeconds = 0;
          currentMode = GameMode.menu;
        });
      }),
      onTapStart: (() {
        setState(() {
          currentMode = GameMode.playing;
        });
      })
    );
  }

  Widget buildChallengeMenu() {
    return ChallengesMenu(
        title: "🚇 Todos los retos", 
        levelSelected: this.levelSelected?.id, 
        levelAndScenarioSelected: ((level, scenario) {
          setState(() {
            levelSelected = level;
            scenarioSelected = scenario;
            currentMode = GameMode.start;
          });
          this.addStations();
          print("Level: ${level.title} on scenario: ${scenario.title}");
        }
      )
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
      child: buildStationWidget(lastInteractedStation!),
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