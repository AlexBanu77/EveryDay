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

void removeEvent(index) {
  client.delete('http://192.168.172.24:5001/events/$index');
}

class DisplayEvents extends StatefulWidget {
  const DisplayEvents({Key key}) : super(key: key);
  @override
  State<DisplayEvents> createState() => _DisplayEventsState();
}
class _DisplayEventsState extends State<DisplayEvents> {
  List<Event> events = [];
  Future<List<Event>> getAll() async {
    var response = await http.get('http://192.168.172.24:5001/events/');

    if(response.statusCode==200){
      events.clear();
    }
    var decodedData = jsonDecode(response.body);
    for (var u in decodedData) {
      try{
        events.add(Event(u['id'],u['date'], u['organizer'], u['location']));
      } catch (e) {
        print(e);
      }
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
          automaticallyImplyLeading: false,
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
                                title: Text('${snapshot.data[index].organizer} ${snapshot.data[index].id}'),
                                subtitle: Text(snapshot.data[index].location),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                    });
                                    removeEvent(snapshot.data[index].id);
                                  },
                                ),
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

            });
            postEvent(u);
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
    )
    );
  }
}