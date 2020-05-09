import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/tab/empresas_tab.dart';
import 'package:compreaidelivery/telas/paginaEmpresa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:scoped_model/scoped_model.dart';

class GeolocalizacaoUsuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MyMapPage(title: ''));
  }
}

class MyMapPage extends StatefulWidget {
  final _formKeyGeolocalizacao = GlobalKey<FormState>();

  MyMapPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyMapPageState createState() => _MyMapPageState();
}

class _MyMapPageState extends State<MyMapPage> {
  final _formKeyGeolocalizacao = GlobalKey<FormState>();

  final _formKey = GlobalKey<FormState>();

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  String cidadeEstado;
  String endereco;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/gps_i.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("Onde eu estou"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) async {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);

          LocationData myLocation;
          String error;
          Location location = new Location();
          final coordinates =
              new Coordinates(newLocalData.latitude, newLocalData.longitude);
          var addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);
          var first = addresses.first;
          endereco = first.addressLine;
          String cidade = first.subAdminArea;
          String estado = first.adminArea;
          cidadeEstado = cidade + "-" + first.adminArea;
          print(cidadeEstado);

          DocumentReference documentReference = Firestore.instance
              .collection("ConsumidorFinal")
              .document("FiW9trcBVbZsAJfuJF4WEi5xVj62");
          Firestore.instance.runTransaction((transaction) async {
            await transaction
                .update(documentReference, {"cidade": cidadeEstado});
            await transaction.update(documentReference, {"endereco": endereco});
            await transaction
                .update(documentReference, {"latitude": newLocalData.latitude});
            await transaction.update(
                documentReference, {"longitude": newLocalData.longitude});
          });
          FutureBuilder(
            future: FirebaseAuth.instance.currentUser(),
            builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.hasData) {
                return StreamBuilder(
                  stream: Firestore.instance
                      .collection("ConsumidorFinal")
                      .document(snapshot.data.uid)
                      .snapshots(),
                  builder: (context, snapshot2) {
                    Future<FirebaseUser> user =
                        FirebaseAuth.instance.currentUser();

                    if (!snapshot2.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot2.hasData) {}
                    return Column(
                      children: <Widget>[
                        Text(
                          "Seja bem-vindo(a) ${snapshot2.data["apelido"]}",
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      print("Cliquei");
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
        title: Text("Onde eu estou"),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialLocation,
            markers: Set.of((marker != null) ? [marker] : []),
            circles: Set.of((circle != null) ? [circle] : []),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: Center(
              child: Card(
                  color: Colors.white70,
                  elevation: 40,
                  child: OutlineButton(
                    onPressed: () {
                      if (marker != null) {
                        print(cidadeEstado);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EmpresasTab(
                                  cidade: cidadeEstado,
                                  endereco: endereco,
                                )));
                      } else {
                        snackBar();
                      }
                    },
                    color: Colors.white,
                    highlightColor: Colors.white10,
                    highlightedBorderColor: Colors.white10,
                    highlightElevation: 50,
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Confirmo minha localidade",
                          style: TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.normal,
                              fontFamily: "assets/fonts/ProductSans-Bold.ttf",
                              color: Colors.black87),
                        ),
                        IconButton(
                          icon: Icon(Icons.map),
                          color: Colors.green,
                          onPressed: () {},
                        )
                      ],
                    ),
                  )),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Container(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.location_searching,
                  color: Colors.greenAccent,
                ),
                Text(
                  "Buscar",
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
          onPressed: () {
            getCurrentLocation();
          }),
    );
  }

  updateLocaleUsuario(String lat, long) async {
    FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          return StreamBuilder(
            stream: Firestore.instance
                .collection("ConsumidorFinal")
                .document(snapshot.data.uid)
                .snapshots(),
            builder: (context, snapshot2) {
              Future<FirebaseUser> user = FirebaseAuth.instance.currentUser();

              if (!snapshot2.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                print(snapshot2);
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  snackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content:
          Text("É necessário definir a sua localização antes de continuar."),
      backgroundColor: Colors.blueGrey,
      duration: Duration(seconds: 2),
    ));
  }
}
