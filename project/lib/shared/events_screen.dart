// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hello_world/shared/Event.dart';
import 'package:http/http.dart' as http;

var client = http.Client();

Future<dynamic> postEvent(body) async {
  var response = await client.post(
      'http://192.168.172.24:5001/events/', body: body);
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
    events.clear();
    var response = await http.get('http://192.168.172.24:5001/events/');
    var decodedData = jsonDecode(response.body);
    for (var u in decodedData) {
      try{
        events.add(Event(u['date'], u['organizer'], u['location']));
      } catch (e) {
        print(e);
      }
    }
    return events;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Display Events'),
          elevation: 0.0,
          backgroundColor: Colors.indigo[700],
        ),
        body: FutureBuilder(
          future: getAll(),
          builder: (context, AsyncSnapshot<List<Event>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if(snapshot.hasError){
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                  );
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, index) =>
                          ListTile(
                                title: Text(snapshot.data[index].organizer),
                                subtitle: Text(snapshot.data[index].location),
                                onTap: (){
                                },
                              ),
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );

            },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            var u =
            {
              "date": DateTime.now().toString(),
              "organizer": "Same but different",
              "location": "Peste tot unde ma duc"
            };
            setState(() {
              events.add(Event(u['date'], u['organizer'], u['location']));
            });
            postEvent(u);
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
    )
    );
  }
}