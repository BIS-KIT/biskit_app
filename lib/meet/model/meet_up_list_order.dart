// ignore: constant_identifier_names
enum MeetUpOrderState { created_time, meeting_time, deadline_soon }

class MeetUpListOrder {
  final MeetUpOrderState state;
  final String text;
  MeetUpListOrder({
    required this.state,
    required this.text,
  });
}
