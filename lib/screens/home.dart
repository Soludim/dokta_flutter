import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../screens/chat.dart';
import '../services/places_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Icon(Icons.local_pharmacy_rounded,
                          color: Theme.of(context).primaryColor),
                      const Text(" Nearest Pharmacy")
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: [
                      Icon(Icons.local_hospital,
                          color: Theme.of(context).primaryColor),
                      const Text(" Nearest Hospital")
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      Icon(Icons.bus_alert,
                          color: Theme.of(context).primaryColor),
                      const Text(" Call Ambulance")
                    ],
                  ),
                )
              ],
              onSelected: (value) async {
                if (value == 1) {
                  PlacesService.place = "pharmacy";
                  Navigator.pushNamed(context, "/locate");
                } else if (value == 2) {
                  PlacesService.place = "hospital";
                  Navigator.pushNamed(context, "/locate");
                } else if (value == 3) {
                  const number = '112'; //set the number here
                  bool? res = await FlutterPhoneDirectCaller.callNumber(number);
                  print(res);
                }
              },
            ),
          ],
        ),
        body: const Center(child: Chat()));
  }
}
