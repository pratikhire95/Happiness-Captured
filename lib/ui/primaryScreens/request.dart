import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:geolocator/geolocator.dart';
import '../../components/notificationUI.dart';

class Request extends StatelessWidget {
  Request({Key key, @required this.uid}) : super(key: key);

  final String uid;

  @override
  final _firestore = FirebaseFirestore.instance;
  void getMessage() {
    _firestore.collection('request').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.data());
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff12d4e),
        title: Text(
          'Happiness Captured',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
                stream: _firestore
                    .collection('request')
                    .orderBy('messageTime', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Expanded(
                    child: ListView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: snapshot.data.docs.map((request) {
                        return NotificationUI(
                          address: request['address'],
                          name: request['name'],
                          mobileNo: request['mobile'],
                          distance: Geolocator.distanceBetween(
                                  request['latitude'],
                                  request['longitude'],
                                  19.920600079349757,
                                  75.01306136879904) /
                              1000,
                          uid: request.id,
                          userEmail: uid,
                          requestLatitude: request['latitude'],
                          requestLongitude: request['longitude'],
                          // name: uid,
                          // name: _firestore
                          //     .collection('database')
                          //     .doc("$uid")
                          //     .get()
                          //     .then((doc) => doc.data()['name']),
                        );
                      }).toList(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}