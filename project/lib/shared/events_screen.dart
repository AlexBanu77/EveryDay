// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hello_world/shared/Event.dart';
import 'package:http/http.dart' as http;

var client = http.Client();

Future<dynamic> postEvent() async {
  var response = await client.post('http://192.168.2.105:5001/events/', body: {
    "date": "The time is now old man",
    "Organizer": "Same but different",
    "Location": "Peste tot unde ma duc"
  });
  var decodedData = jsonDecode(response.body);
  return decodedData;
}

class DisplayEvents extends StatefulWidget {
  const DisplayEvents({Key key}) : super(key: key);
  @override
  State<DisplayEvents> createState() => _DisplayEventsState();
}

class _DisplayEventsState extends State<DisplayEvents> {
  List<Event> events = [];
  Future<List<Event>> getAll() async {
    var response = await http.get('http://192.168.2.105:5001/events/');

    if (response.statusCode == 200) {
      events.clear();
    }
    var decodedData = jsonDecode(response.body);
    for (var u in decodedData) {
      events.add(Event(u['date'], u['organizer'], u['location']));
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    getAll();
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Events'),
        elevation: 0.0,
        backgroundColor: Colors.indigo[700],
      ),
      body: FutureBuilder(
          future: getAll(),
          builder: (context, AsyncSnapshot<List<Event>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, index) => Scaffold(
                      body: InkWell(
                        onTap: () {
                          //handle tap gesture
                        },
                        child: ListTile(
                          title: Text(snapshot.data[index].organizer),
                          subtitle: Text(snapshot.data[index].location),
                        ),
                      ),
                    ));
          }),
      floatingActionButton: InkWell(
        onTap: () {
          postEvent();
        },
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
          onPressed: () {},
        ),
      ),
    );
  }
}
