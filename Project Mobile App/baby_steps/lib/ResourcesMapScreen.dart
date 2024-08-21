import 'dart:async';

import 'package:baby_steps/LoadingScreen.dart';
import 'package:baby_steps/components/CustomCarousel_Fb2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ResourcesMapScreen extends StatefulWidget {
  const ResourcesMapScreen({Key? key}) : super(key: key);

  @override
  State<ResourcesMapScreen> createState() => _ResourcesMapScreenState();
}

class _ResourcesMapScreenState extends State<ResourcesMapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> _markers = {};

  final LatLng _center = const LatLng(39.952305, -75.193703);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("locations").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          // Clear existing markers
          _markers.clear();

          // Add markers from Firestore documents
          snapshot.data!.docs.forEach((DocumentSnapshot doc) {
            Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>;
            double latitude = double.parse(data['lati']);
            double longitude = double.parse(data['longi']);
            String markerId = doc.id;

            _markers.add(
              Marker(
                markerId: MarkerId(markerId),
                position: LatLng(latitude, longitude),
                // You can customize markers further here
                infoWindow: InfoWindow(
                  title: data['name'] + " | " + data['category'],
                ),
              ),
            );
          });

          return Scaffold(
            appBar: AppBar(
              title: Text("Find Resources", style: TextStyle(color: Colors.white),),
              backgroundColor: Color.fromRGBO(110, 172, 255, 1),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Stack(
              children: [
                GoogleMap(
                  zoomGesturesEnabled: true,
                  tiltGesturesEnabled: false,
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 15.0,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 230, 
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),// Adjust height as needed
                    child: CustomCarouselFB2(
                      mapController: _controller,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
