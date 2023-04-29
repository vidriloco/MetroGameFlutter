import 'package:mapbox_gl/mapbox_gl.dart';

Map<String, SymbolOptions?> STATIONS = {
    // Linea 1
    "observatorio": SymbolOptions(geometry: LatLng(19.398237, -99.200363), iconImage: "assets/images/observatorio.png", iconSize: 0.15),
    "tacubaya": SymbolOptions(geometry: LatLng(19.403439, -99.187102), iconImage: "assets/images/tacubaya.png", iconSize: 0.15),
    "juanacatlan": SymbolOptions(geometry: LatLng(19.41289, -99.182167), iconImage: "assets/images/juanacatlan.png", iconSize: 0.15),
    "chapultepec": SymbolOptions(geometry: LatLng(19.420783, -99.176288), iconImage: "assets/images/chapultepec.png", iconSize: 0.15),
    "sevilla": SymbolOptions(geometry: LatLng(19.421916, -99.17058), iconImage: "assets/images/sevilla.png", iconSize: 0.15),
    "insurgentes": SymbolOptions(geometry: LatLng(19.423292, -99.163177), iconImage: "assets/images/insurgentes.png", iconSize: 0.15),
    "cuauhtemoc": SymbolOptions(geometry: LatLng(19.425862, -99.154701), iconImage: "assets/images/cuauhtemoc.png", iconSize: 0.15),
    "balderas": SymbolOptions(geometry: LatLng(19.432066, -99.149936), iconImage: "assets/images/balderas.png", iconSize: 0.15),
    "saltodelagua": SymbolOptions(geometry: LatLng(19.426813, -99.142213), iconImage: "assets/images/saltodelagua.png", iconSize: 0.15),
    "isabellacatolica": SymbolOptions(geometry: LatLng(19.426732, -99.137685), iconImage: "assets/images/isabellacatolica.png", iconSize: 0.15),
    "pinosuarez": SymbolOptions(geometry: LatLng(19.425336, -99.132943), iconImage: "assets/images/pinosuarez.png", iconSize: 0.15),
    "merced": SymbolOptions(geometry: LatLng(19.425558, -99.124639), iconImage: "assets/images/merced.png", iconSize: 0.15),
    "candelaria": SymbolOptions(geometry: LatLng(19.428837, -99.119511), iconImage: "assets/images/candelaria.png", iconSize: 0.15),
    "sanlazaro": SymbolOptions(geometry: LatLng(19.430213, -99.114833), iconImage: "assets/images/sanlazaro.png", iconSize: 0.15),
    "moctezuma": SymbolOptions(geometry: LatLng(19.427218, -99.110305), iconImage: "assets/images/moctezuma.png", iconSize: 0.15),
    "balbuena": SymbolOptions(geometry: LatLng(19.423231, -99.102302), iconImage: "assets/images/balbuena.png", iconSize: 0.15),
    "boulevard": SymbolOptions(geometry: LatLng(19.41967, -99.09595), iconImage: "assets/images/boulevard.png", iconSize: 0.15),
    "pantitlan": SymbolOptions(geometry: LatLng(19.415359, -99.072132), iconImage: "assets/images/pantitlan.png", iconSize: 0.15),
    "zaragoza": SymbolOptions(geometry: LatLng(19.412344, -99.08241), iconImage: "assets/images/zaragoza.png", iconSize: 0.15),
    "gomezfarias": SymbolOptions(geometry: LatLng(19.416472, -99.09035), iconImage: "assets/images/gomezfarias.png", iconSize: 0.15),
    // Linea 2
    "tasquena": SymbolOptions(geometry: LatLng(19.343757098277699, -99.1395327763843), iconImage: "assets/images/tasquena.png", iconSize: 0.15),
    "generalanaya": SymbolOptions(geometry: LatLng(19.353235914861202, -99.145006362954504), iconImage: "assets/images/generalanaya.png", iconSize: 0.15),
    "ermita": SymbolOptions(geometry: LatLng(19.359823503023801, -99.141631363054401), iconImage: "assets/images/ermita.png", iconSize: 0.8),
    "portales": SymbolOptions(geometry: LatLng(19.369924838667998, -99.141573554914402), iconImage: "assets/images/portales.png", iconSize: 0.15),
    "nativitas": SymbolOptions(geometry: LatLng(19.379532760913602, -99.140187889707605), iconImage: "assets/images/nativitas.png", iconSize: 0.15),
    "villadecortes": SymbolOptions(geometry: LatLng(19.387581775826, -99.138959166221198), iconImage: "assets/images/villadecortes.png", iconSize: 0.15),
    "xola": SymbolOptions(geometry: LatLng(19.395210509950399, -99.137808179321098), iconImage: "assets/images/xola.png", iconSize: 0.15),
    "viaducto": SymbolOptions(geometry: LatLng(19.400868658019, -99.136899592488405), iconImage: "assets/images/viaducto.png", iconSize: 0.15),
    "chabacano": SymbolOptions(geometry: LatLng(19.409179869277601, -99.135618117252704), iconImage: "assets/images/chabacano.png", iconSize: 0.15),
    "sanantonioabad": SymbolOptions(geometry: LatLng(19.416021647069101, -99.134539874156701), iconImage: "assets/images/sanantonioabad.png", iconSize: 0.15),
    "zocalo": SymbolOptions(geometry: LatLng(19.432501910975901, -99.1322510732777), iconImage: "assets/images/zocalo.png", iconSize: 0.15),
    "allende": SymbolOptions(geometry: LatLng(19.435558003271201, -99.136867840237002), iconImage: "assets/images/allende.png", iconSize: 0.15),
    "bellasartes": SymbolOptions(geometry: LatLng(19.436377755896, -99.141613637371194), iconImage: "assets/images/bellasartes.png", iconSize: 0.15),
    "revolucion": SymbolOptions(geometry: LatLng(19.439227179139699, -99.154227825713406), iconImage: "assets/images/revolucion.png", iconSize: 0.15),
    "sancosme": SymbolOptions(geometry: LatLng(19.4419042544265, -99.160662072806801), iconImage: "assets/images/sancosme.png", iconSize: 0.15),
    "normal": SymbolOptions(geometry: LatLng(19.444557705524598, -99.167274037410493), iconImage: "assets/images/normal.png", iconSize: 0.15),
    "colegiomilitar": SymbolOptions(geometry: LatLng(19.449273554997198, -99.171779233316798), iconImage: "assets/images/colegiomilitar.png", iconSize: 0.15),
    "popotla": SymbolOptions(geometry: LatLng(19.452909219801601, -99.175493814341195), iconImage: "assets/images/popotla.png", iconSize: 0.15),
    "cuitlahuac": SymbolOptions(geometry: LatLng(19.457253889739199, -99.181495767912196), iconImage: "assets/images/cuitlahuac.png", iconSize: 0.15),
    "tacuba": SymbolOptions(geometry: LatLng(19.459376010718699, -99.188230934414094), iconImage: "assets/images/tacuba.png", iconSize: 0.15),
    "panteones": SymbolOptions(geometry: LatLng(19.458638560770101, -99.202949129527198), iconImage: "assets/images/panteones.png", iconSize: 0.15),
    "cuatrocaminos": SymbolOptions(geometry: LatLng(19.459593208492102, -99.215842489696797), iconImage: "assets/images/cuatrocaminos.png", iconSize: 0.15),
    // Linea 3
    "indiosverdes": SymbolOptions(geometry: LatLng(19.495337618645699, -99.119509938259199), iconImage: "assets/images/indiosverdes.png", iconSize: 0.15),
    "deportivo18marzo": SymbolOptions(geometry: LatLng(19.485114151342501, -99.125497917124605), iconImage: "assets/images/deportivo18marzo.png", iconSize: 0.15),
    "potrero": SymbolOptions(geometry: LatLng(19.4771920114807, -99.132013682994), iconImage: "assets/images/potrero.png", iconSize: 0.15),
    "laraza": SymbolOptions(geometry: LatLng(19.468880133789, -99.139506230224697), iconImage: "assets/images/laraza.png", iconSize: 0.15),
    "tlatelolco": SymbolOptions(geometry: LatLng(19.455058142803701, -99.143133084134107), iconImage: "assets/images/tlatelolco.png", iconSize: 0.15),
    "guerrero": SymbolOptions(geometry: LatLng(19.444726334828399, -99.145193344069796), iconImage: "assets/images/guerrero.png", iconSize: 0.15),
    "hidalgo": SymbolOptions(geometry: LatLng(19.437382392262599, -99.146782721336905), iconImage: "assets/images/hidalgo.png", iconSize: 0.15),
    "juarez": SymbolOptions(geometry: LatLng(19.4332503464504, -99.147683305763195), iconImage: "assets/images/juarez.png", iconSize: 0.15),
    "balderas": SymbolOptions(geometry: LatLng(19.427381, -99.149808), iconImage: "assets/images/balderas.png", iconSize: 0.15),
    "ninosheroes": SymbolOptions(geometry: LatLng(19.419508, -99.150581), iconImage: "assets/images/ninosheroes.png", iconSize: 0.18),
    "hospitalgeneral": SymbolOptions(geometry: LatLng(19.413758753579401, -99.153245361779), iconImage: "assets/images/hospitalgeneral.png", iconSize: 0.15),
    "centromedico": SymbolOptions(geometry: LatLng(19.4074531474438, -99.155134689523706), iconImage: "assets/images/centromedico.png", iconSize: 0.15),
    "etiopia": SymbolOptions(geometry: LatLng(19.395920531617399, -99.156031415349304), iconImage: "assets/images/etiopia.png", iconSize: 0.15),
    "eugenia": SymbolOptions(geometry: LatLng(19.386168518115401, -99.157204597566107), iconImage: "assets/images/eugenia.png", iconSize: 0.15),
    "divisiondelnorte": SymbolOptions(geometry: LatLng(19.379184435402301, -99.159479165804697), iconImage: "assets/images/divisiondelnorte.png", iconSize: 0.15),
    "zapata": SymbolOptions(geometry: LatLng(19.371191786554402, -99.164510297655696), iconImage: "assets/images/zapata.png", iconSize: 0.15),
    "coyoacan": SymbolOptions(geometry: LatLng(19.361359077350102, -99.170861527342893), iconImage: "assets/images/coyoacan.png", iconSize: 0.15),
    "viveros": SymbolOptions(geometry: LatLng(19.3534590245247, -99.176001086063806), iconImage: "assets/images/viveros.png", iconSize: 0.15),
    "maquevedo": SymbolOptions(geometry: LatLng(19.346251833085901, -99.180756655644103), iconImage: "assets/images/maquevedo.png", iconSize: 0.15),
    "copilco": SymbolOptions(geometry: LatLng(19.336099274803299, -99.176973595215998), iconImage: "assets/images/copilco.png", iconSize: 0.15),
    "universidad": SymbolOptions(geometry: LatLng(19.324353482894299, -99.173938455589493), iconImage: "assets/images/universidad.png", iconSize: 0.15)
};