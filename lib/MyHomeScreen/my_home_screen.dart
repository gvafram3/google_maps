// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps/directions_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../directions.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(6.671936297679118, -1.572416063635944),
    zoom: 11.5,
  );

  late GoogleMapController _googleMapController;
  Marker? _origin;
  Marker? _destination;
  // Directions? _info;

  @override
  void dispose() {
    // TODO: implement dispose
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Google Maps'),
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position,
                    zoom: 14.5,
                    tilt: 50,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ORIGIN'),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination!.position,
                    zoom: 14.5,
                    tilt: 50,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('DEST'),
            ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_origin != null) _origin!,
              if (_destination != null) _destination!,
            },
            // polylines: {
            //   if (_info != null)
            //     Polyline(
            //       polylineId: const PolylineId('overview_polyline'),
            //       color: Colors.red,
            //       width: 5,
            //       points: _info!.polylinePoints
            //           .map((e) => LatLng(e.latitude, e.longitude))
            //           .toList(),
            //     ),
            // },
            onLongPress: _addMarker,
          ),
          //   if (_info != null)
          //     Positioned(
          //       top: 20.0,
          //       child: Container(
          //         padding:
          //             const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
          //         decoration: BoxDecoration(
          //           color: Colors.yellowAccent,
          //           borderRadius: BorderRadius.circular(20.0),
          //           boxShadow: const [
          //             BoxShadow(
          //               color: Colors.black26,
          //               offset: Offset(0, 2),
          //               blurRadius: 6.0,
          //             ),
          //           ],
          //         ),
          //         child: Text(
          //           '${_info!.totalDistance}, ${_info!.totalDuration}',
          //           style: const TextStyle(
          //             fontSize: 18.0,
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //       ),
          //     ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: () => _googleMapController.animateCamera(
          // _info != null
          //     ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
          // :
          CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || _origin == null && _destination == null) {
      // Origin is not set OR Origin/Destination are both not set
      // Set Origin
      setState(
        () {
          _origin = Marker(
            markerId: const MarkerId('origin'),
            infoWindow: const InfoWindow(title: 'origin'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: pos,
          );
          // Reset destination
          _destination = null;

          // Reset _info
          // _info = null;
        },
      );
    } else {
      // Origin is already set
      // Set destination
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Get directions
      // final directions = await DirectionsRepository().getDirections(
      //     origin: _origin!.position, destination: _destination!.position);
      // setState(() => _info = directions);
    }
  }
}
