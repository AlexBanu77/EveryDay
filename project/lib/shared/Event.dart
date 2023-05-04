class Event {
  late int id;
  late String date;
  late String organizer;
  late String location;
  Event(uid, udate, uorganizer, ulocation){
    id = uid;
    date = udate;
    organizer = uorganizer;
    location = ulocation;
  }
}