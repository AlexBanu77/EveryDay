// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hello_world/shared/Event.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

var client = http.Client();

Future<dynamic> postEvent(body) async {
  var response =
      await client.post('http://192.168.172.24:5001/events/', body: body);
  var decodedData = jsonDecode(response.body);
  return decodedData;
}

Future<void> removeEvent(index) async {
   await client.delete('http://192.168.172.24:5001/events/$index');
}

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({Key key, this.event}) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  GoogleMapController mapController;

  void showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Access Location'),
          content: Text('Do you want to access your location?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                // Request permission for location access
                requestLocationAccess(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void requestLocationAccess(BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Extract latitude and longitude from the position
      double latitude = position.latitude;
      double longitude = position.longitude;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 14.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('event'),
                    position: LatLng(latitude, longitude),
                  ),
                },
              ),
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Access Denied'),
            content: Text('Please grant permission to access your location.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('${widget.event.organizer}'),
            subtitle: Text(widget.event.location),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.event.latitude, widget.event.longitude),
                zoom: 14.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(widget.event.id.toString()),
                  position:
                      LatLng(widget.event.latitude, widget.event.longitude),
                ),
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showLocationDialog(context);
        },
        child: Icon(Icons.location_on),
      ),
    );
  }
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
  BuildContext scaffoldContext;

  Future<List<Event>> getAll() async {
    var response = await http.get('http://192.168.172.24:5001/events/');

    if (response.statusCode == 200) {
      events.clear();
    }
    var decodedData = jsonDecode(response.body);
    for (var u in decodedData) {
      try {
        events.add(Event(
          u['id'],
          u['date'],
          u['organizer'],
          u['location'],
          u['latitude'],
          u['longitude'],
        ));
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
            event.organizer.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  Future<void> refreshEvents() async {
    setState(() async {
      events = await getAll();
    });
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
      body: Builder(
        builder: (BuildContext context) {
          scaffoldContext = context;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by organizer',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: refreshEvents,
                  child: FutureBuilder(
                    future: getAll(),
                    builder: (context, AsyncSnapshot<List<Event>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          var filteredEvents = getFilteredEvents();
                          return ListView.builder(
                            itemCount: filteredEvents.length,
                            itemBuilder: (BuildContext context, index) =>
                                ListTile(
                              title: Text(
                                  '${filteredEvents[index].organizer}'),
                              subtitle: Text(
                                  filteredEvents[index].location),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  refreshEvents();
                                  await removeEvent(filteredEvents[index].id);
                                  Navigator.pushNamed(context, '/events');
                                  ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                                    SnackBar(
                                      content: Text('Event deleted'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                              onTap: () async {
                                // Navigate to event details screen when an event is tapped
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventDetailsScreen(
                                      event: filteredEvents[index],
                                    ),
                                  ),
                                );
                                refreshEvents(); // Refresh the events list after returning from the details screen
                              },
                            ),
                          );
                        }
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () async {

    var result = await showDialog(
      context: context,
      builder: (context) => EventDialog(),
    );

    // Request permission for location access
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // Retrieve the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Extract latitude and longitude from the position
      double latitude = position.latitude;
      double longitude = position.longitude;

      showDialog(
        context: context, // Use the context parameter from builder
        builder: (context) {
          return Dialog(
            child: Container(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longitude),
                  zoom: 14.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('event'),
                    position: LatLng(latitude, longitude),
                  ),
                },
              ),
            ),
          );
        },
      );
    } else {
      // Handle the case when the user denies location permission
      showDialog(
        context: context, // Use the context parameter from builder
        builder: (context) {
          return AlertDialog(
            title: Text('Location Access Denied'),
            content: Text('Please grant permission to access your location.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  },
  backgroundColor: Colors.green,
  child: const Icon(Icons.add),
),
    );
  }
}

class FilterDialog extends StatefulWidget {
  final String currentFilter;

  const FilterDialog({Key key, this.currentFilter}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter by location'),
      content: TextField(
        decoration: InputDecoration(hintText: 'Enter location'),
        controller: filterController,
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Apply'),
          onPressed: () => Navigator.of(context).pop(filterController.text),
        ),
      ],
    );
  }
}


class EventDialog extends StatefulWidget {

  const EventDialog({Key key}) : super(key: key);

  @override
  _EventDialogState createState() => _EventDialogState();
}

class _EventDialogState extends State<EventDialog> {
  final organizerController = TextEditingController();
  final locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    organizerController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> _onpressed() async {
    var u =
    {
      "date": DateTime.now().toString(),
      "organizer": organizerController.text,
      "location": locationController.text
    };
    await postEvent(u);
    Navigator.pushNamed(context, '/events');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add an event'),
      content: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: organizerController,
              decoration: InputDecoration(
                labelText: 'Organizer',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
              ),
            ),
            SizedBox(height: 20)]
        )
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () {
            _onpressed();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
