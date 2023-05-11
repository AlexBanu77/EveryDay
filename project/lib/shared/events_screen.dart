// @dart=2.9

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hello_world/shared/Event.dart';
import 'package:http/http.dart' as http;

var client = http.Client();

Future<dynamic> postEvent(body) async {
  var response =
      await client.post('http://192.168.172.24:5001/events/', body: body);
  var decodedData = jsonDecode(response.body);
  return decodedData;
}

void removeEvent(index) {
  client.delete('http://192.168.172.24:5001/events/$index');
}

class DisplayEvents extends StatefulWidget {
  const DisplayEvents({Key key}) : super(key: key);

  @override
  _DisplayEventsState createState() => _DisplayEventsState();
}

class _DisplayEventsState extends State<DisplayEvents> {
  List<Event> events = [];
  String filter = '';

  final TextEditingController _searchController = TextEditingController();

  Future<List<Event>> getAll() async {
    var response = await http.get('http://192.168.172.24:5001/events/');

    if (response.statusCode == 200) {
      events.clear();
    }
    var decodedData = jsonDecode(response.body);
    for (var u in decodedData) {
      try {
        events.add(Event(u['id'], u['date'], u['organizer'], u['location']));
      } catch (e) {
        print(e);
      }
    }
    return events;
  }

  List<Event> getFilteredEvents() {
    if (filter.isEmpty) {
      return events;
    }
    return events
        .where((event) =>
            event.location.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        filter = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Events'),
        elevation: 0.0,
        backgroundColor: Colors.indigo[700],
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              var result = await showDialog(
                context: context,
                builder: (context) => FilterDialog(currentFilter: filter),
              );
              if (result != null) {
                setState(() {
                  filter = result;
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getAll(),
              builder: (context, AsyncSnapshot<List<Event>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    );
                  }
                  if (snapshot.hasData) {
                    var filteredEvents = getFilteredEvents();
                    return ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (BuildContext context, index) => ListTile(
                        title: Text(
                            '${snapshot.data[index].organizer} ${snapshot.data[index].id}'),
                        subtitle: Text(snapshot.data[index].location),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {});
                            removeEvent(snapshot.data[index].id);
                          },
                        ),
                        onTap: () {},
                      ),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var u = {
            "date": DateTime.now().toString(),
            "organizer": "Same but different",
            "location": "Peste tot unde ma duc"
          };
          setState(() {});
          postEvent(u);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ));
  }
}

class FilterDialog extends StatefulWidget {
  final String currentFilter;

  const FilterDialog({Key key, this.currentFilter}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String filter;

  @override
  void initState() {
    super.initState();
    filter = widget.currentFilter;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter by location'),
      content: TextField(
        decoration: InputDecoration(hintText: 'Enter location'),
        onChanged: (value) {
          setState(() {
            filter = value;
          });
        },
        controller: TextEditingController(text: filter),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Apply'),
          onPressed: () => Navigator.of(context).pop(filter),
        ),
      ],
    );
  }
}

