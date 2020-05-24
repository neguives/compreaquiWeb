import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compreaidelivery/tab/empresas_tab.dart';
import 'package:compreaidelivery/telas/paginaEmpresa.dart';
import 'package:compreaidelivery/telas/tela_selecao_categoria.dart';
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
  double latitudeAtualizada, logintudeAtualizada;

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  String cidadeEstado;
  String endereco;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(-18.1644818, -47.961643),
    zoom: 5,
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
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser;
    Future<Null> _loadCurrentUser(double latitude, logintude) async {
      if (firebaseUser == null) firebaseUser = await _auth.currentUser();
      if (firebaseUser != null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("ConsumidorFinal")
            .document(firebaseUser.uid)
            .get();

        DocumentReference documentReference = Firestore.instance
            .collection("ConsumidorFinal")
            .document(firebaseUser.uid);

        Firestore.instance.runTransaction((transaction) async {
          await transaction.update(documentReference, {"cidade": cidadeEstado});
          await transaction.update(documentReference, {"endereco": endereco});
          await transaction.update(documentReference, {"latitude": latitude});
          await transaction.update(documentReference, {"longitude": logintude});
        });
      }
    }

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
          latitudeAtualizada = newLocalData.latitude;
          logintudeAtualizada = newLocalData.longitude;
          endereco = first.addressLine;
          String cidade = first.subAdminArea;
          String estado = first.adminArea;
          cidadeEstado = cidade + "-" + first.adminArea;

          double latitude = newLocalData.latitude;
          double logintude = newLocalData.longitude;
          _loadCurrentUser(latitude, logintude);
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
        backgroundColor: Colors.white,
        title: Text(
          "Onde eu estou",
          style: TextStyle(color: Colors.black87),
        ),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.all(50),
                child: RaisedButton(
                  onPressed: marker == null
                      ? () {
                          if (marker != null && endereco != null) {
                            print(cidadeEstado);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TelaSelecaoCategoria(
                                      cidadeEstado: cidadeEstado,
                                      endereco: endereco,
                                      latitude: latitudeAtualizada,
                                      longitude: logintudeAtualizada,
                                    )));
                          } else {
                            snackBar();
                            getCurrentLocation();
                          }
                        }
                      : marker != null && endereco != null
                          ? () {
                              if (marker != null && endereco != null) {
                                print(cidadeEstado);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TelaSelecaoCategoria(
                                          cidadeEstado: cidadeEstado,
                                          endereco: endereco,
                                          latitude: latitudeAtualizada,
                                          longitude: logintudeAtualizada,
                                        )));
                              } else {
                                snackBar();
                                getCurrentLocation();
                              }
                            }
                          : null,
                  color: Colors.white,
                  highlightColor: Colors.white10,
                  highlightElevation: 50,
                  child: Text(
                    marker != null
                        ? "Confirmar minha localização"
                        : "Buscar minha localização",
                    style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.normal,
                        fontFamily: "assets/fonts/ProductSans-Bold.ttf",
                        color: Colors.black87),
                  ),
                )),
          )
        ],
      ),
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
