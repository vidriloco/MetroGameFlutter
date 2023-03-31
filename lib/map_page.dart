import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import "routes_list_page.dart";
import "line-panel.dart";
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapboxMapController? mapController;
  String? selectedStation;
  LinePanel? linePanel;
  
  BehaviorSubject<String> feedbackEventsStream = new BehaviorSubject<String>();
  BehaviorSubject<String> childEventsStream = new BehaviorSubject<String>();

  Offset dragCanceledAtOffset = Offset(20, 50);
  Offset originPositionOffset = Offset(50, 50);
  bool dragEventCanceled = false;

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
        this.mapController?.onSymbolTapped.add((symbol) async {
          mapController?.removeSymbol(symbol);
          var location = await mapController?.getSymbolLatLng(symbol);
          var locationOffset = await mapController?.toScreenLocation(location!);

          var dx = locationOffset?.x.toDouble() ?? 0;
          var dy = locationOffset?.y.toDouble() ?? 0;

          setState(() {
            originPositionOffset = Offset(dx-30, dy-30);
            selectedStation = "${symbol.data?["name"]}-station";
          });
        });

        this.mapController?.addListener(() {
          if(selectedStation != null) {
            this.addStation(selectedStation!);
          }

          setState(() {
            selectedStation = null;
          });
        });
      },
      trackCameraPosition: true,
      initialCameraPosition: CameraPosition(
        zoom: 15.0,
        target: LatLng(19.432, -99.133),
      )
    );
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
      width: 60,
      height: 60,
      child: Image.asset("assets/images/${name}.png")
    );
  }

  Positioned buildDraggableStation(String station) {
    Widget stationChildBox = buildStationWidget(station);
    Widget stationFeedbackBox = Opacity(child: buildStationWidget(station), opacity: 0.8);

    return Positioned(
      left: originPositionOffset.dx,
      top: originPositionOffset.dy,
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
        },
        onDragCompleted: (){
          setState(() {
            selectedStation = null;
          });
        },
        onDragEnd: (details){ 
          this.childEventsStream.add("show");
        },
        onDraggableCanceled: (Velocity velocity, Offset offset){
          this.childEventsStream.add("hide");

          setState(() {
              dragEventCanceled = true;
              dragCanceledAtOffset = offset;
          });

          Future.delayed(const Duration(milliseconds: 20), () {
            setState(() {
              dragCanceledAtOffset = originPositionOffset;
            });
          });
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

    if(linePanel != null) {
      widgets.add(linePanel!);
    }

    if(selectedStation != null) {
      widgets.add(buildDraggableStation(selectedStation!));
    }

    if(dragEventCanceled && selectedStation != null) {
      widgets.add(buildAnimatedDraggableStation());
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
      child: buildStationWidget(selectedStation!),
      onEnd: () {
        this.childEventsStream.add("show");
        setState(() {
          dragEventCanceled = false;
        });
      }
    );
  }

  void addStation(String stationName) {
    mapController?.addSymbol(
      SymbolOptions(
        iconSize: 0.8,
        geometry: LatLng(19.432, -99.133),
        iconImage: "assets/images/${stationName}.png",
      ),
      { "name": "zocalo" }
    );
  }

  void addStations() {
    mapController?.addSymbol(
      SymbolOptions(
        iconSize: 0.8,
        geometry: LatLng(19.432, -99.133),
        iconImage: "assets/images/zocalo-station.png",
      ),
      { "name": "zocalo" }
    );

    mapController?.addSymbol(
      SymbolOptions(
        iconSize: 0.8,
        geometry: LatLng(19.425862, -99.154701),
        iconImage: "assets/images/cuauhtemoc-station.png",
      ),
      { "name": "cuauhtemoc" }
    );

    mapController?.addSymbol(
      SymbolOptions(
        iconSize: 0.8,
        geometry: LatLng(19.41289, -99.182167),
        iconImage: "assets/images/juanacatlan-station.png",
      ),
      { "name": "juanacatlan" }
    );

    mapController?.addSymbol(
      SymbolOptions(
        iconSize: 0.8,
        geometry: LatLng(19.42744, -99.149036),
        iconImage: "assets/images/balderas-station.png",
      ),
      { "name": "balderas" }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context)
    );
  }
}