import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:wash_wow/src/service/booking_screen.dart';
import 'package:wash_wow/src/utility/fetch_service.dart';

class ServicesScreen extends StatefulWidget {
  final String serviceName;
  const ServicesScreen({super.key, required this.serviceName});
  static const RoundedRectangleBorder roundedRectangleBorder =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)));

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String locationName = "Getting location...";
  List<dynamic> laundryShops = []; // List to store the fetched shops

  @override
  void initState() {
    super.initState();
    _getLocationAndAddress();
    _fetchLaundryShops(); // Fetch laundry shops when the screen loads
  }

  // Function to fetch laundry shops
  Future<void> _fetchLaundryShops() async {
    try {
      var shops = await fetchLaundryShops(1, 10);
      setState(() {
        laundryShops = shops; // Assuming 'value' holds the shop list
      });
    } catch (e) {
      print("Error fetching laundry shops: $e");
    }
  }

  Future<void> _getLocationAndAddress() async {
    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        locationName = "${place.street}, ${place.administrativeArea}";
      });
      print(locationName);
    } catch (e) {
      print(e);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: buildLocation("Store near you", MdiIcons.map),
          ),
          Expanded(
            child: buildLaundryShopList(), // ListView for displaying shops
          ),
        ],
      ),
    );
  }

  // Widget to build the app bar
  PreferredSizeWidget buildAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          title: Text(
            widget.serviceName,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          shape: ServicesScreen.roundedRectangleBorder,
          iconTheme: IconThemeData(color: Colors.white),
        ));
  }

  // ListView builder for laundry shops
  Widget buildLaundryShopList() {
    return ListView.builder(
      itemCount: laundryShops.length,
      itemBuilder: (context, index) {
        var shop = laundryShops[index];
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: Icon(MdiIcons.washingMachine,
                color: Theme.of(context).primaryColor),
            title: Text(shop['name']),
            subtitle: Text(shop['address']),
            trailing: Text(shop['status']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookingScreen(
                          serviceId: widget.serviceName,
                          laundryShopId: shop['id'].toString(),
                        )),
              );
              // print('Selected Shop: ${shop['id']}');
            },
          ),
        );
      },
    );
  }

  Widget buildLocation(String title, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    print('Xem thêm clicked');
                  },
                  child: Row(
                    children: [
                      Text(
                        "More",
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87,
                        ),
                      ),
                      Transform.rotate(
                        angle: 270 * math.pi / 180, // Rotating icon
                        child: const Icon(
                          Icons.expand_more,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Location",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    MdiIcons.mapMarker,
                    size: 16,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    locationName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
