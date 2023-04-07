import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import "routes_list_page.dart";
import "line-panel.dart";
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  const MapPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapboxMapController? mapController;
  String? lastInteractedStation;
  LinePanel? linePanel;
  
  BehaviorSubject<String> feedbackEventsStream = new BehaviorSubject<String>();
  BehaviorSubject<String> childEventsStream = new BehaviorSubject<String>();

  Offset dragCanceledAtOffset = Offset(20, 50);
  Offset originPositionOffset = Offset(50, 50);

  double iconWidth = 40;
  double iconHeight = 40;

  Widget? mapWidget;

  @override
  void initState() {
    super.initState();

    this.mapWidget = buildMap();
    this.linePanel = buildLinePanel();
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
      trackCameraPosition: true,
      initialCameraPosition: CameraPosition(
        zoom: 15.0,
        target: LatLng(19.432, -99.133),
      )
    );
  }

  List<Widget> stationWidgets = <Widget>[];

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
      child: Image.asset("assets/images/${name}-station.png")
    );
  }

  Positioned buildDraggableStation(String station, Offset position) {

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        data: 1,
        child: StreamBuilder(
          initialData: "show",
          stream: childEventsStream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            String shouldPresent = snapshot.data ?? "show";
            if (shouldPresent == "show") {
              return Opacity(child: buildStationWidget(station), opacity: 1);
            } else {
              return Opacity(child: buildStationWidget(station), opacity: 0);
            }
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
          // TODO: Remove symbol from map when starting dragging map marker
          this.mapController?.removeSymbol();
        },
        onDragCompleted: (){
          if(lastInteractedStation != null) {
            this.availableStations[lastInteractedStation!] = null;
          }

          setState(() { });
        },
        onDragEnd: (details){ 
          this.childEventsStream.add("show");
        },
        onDraggableCanceled: (Velocity velocity, Offset offset){
          // TODO: Animate back

          this.childEventsStream.add("hide");

        },
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    List<Widget> widgets = <Widget>[
      Container(
        color: Colors.blue,
        child: mapWidget
      ),
      Positioned(
        left: 20,
        top: 60, 
        child: GestureDetector(
          onTap: (){
            this.addStations();
          },
          child: Container(
            width: 20,
            height: 20,
            color: Colors.white
          )
        )
      )
    ];

    stationWidgets.forEach((widget) {
      widgets.add(widget);
    });

    if(linePanel != null) {
      widgets.add(linePanel!);
    }
    
    return Stack(children: widgets);
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

  Map<String, SymbolOptions?>  availableStations = {
    "zocalo": SymbolOptions(
      iconSize: 0.7,
      geometry: LatLng(19.432, -99.133),
      iconImage: "assets/images/zocalo-station.png",
    ),
    "cuauhtemoc": SymbolOptions(
      iconSize: 0.7,
      geometry: LatLng(19.425862, -99.154701),
      iconImage: "assets/images/cuauhtemoc-station.png",
    ),
    "juanacatlan": SymbolOptions(
      iconSize: 0.7,
      geometry: LatLng(19.41289, -99.182167),
      iconImage: "assets/images/juanacatlan-station.png",
    ),
    "balderas": SymbolOptions(
      iconSize: 0.7,
      geometry: LatLng(19.42744, -99.149036),
      iconImage: "assets/images/balderas-station.png",
    )
  };

  void addStations() {
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