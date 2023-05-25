class Event {
  late int id;
  late String date;
  late String organizer;
  late String location;
  late double latitude; // for goooglemaps
  late double longitude; // for googlemaps

  Event(uid, udate, uorganizer, ulocation, ulatitude, ulongitude) {
    id = uid;
    date = udate;
    organizer = uorganizer;
    location = ulocation;
    latitude = ulatitude;
    longitude = ulongitude;
  }
}
