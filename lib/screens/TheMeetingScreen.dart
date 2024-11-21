import 'package:meety/widgets/meetingDetails.dart';
import 'package:flutter/material.dart';

class UpcomingMeetingsWidget extends StatefulWidget {
  final List<Map<String, String>> meetings;

  const UpcomingMeetingsWidget({super.key, required this.meetings});

  @override
  _UpcomingMeetingsWidgetState createState() => _UpcomingMeetingsWidgetState();
}

class _UpcomingMeetingsWidgetState extends State<UpcomingMeetingsWidget> {
  int selectedMeetingIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        const Text(
          'פגישה קרובה',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to MeetingDetailScreen with the selected meeting's ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeetingDetailsContent(
                      meetingId: widget.meetings[selectedMeetingIndex]['id']!,
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: 150,
                height: 250,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                        Color.fromRGBO(67, 198, 250, 0.513),
                      Color.fromARGB(95, 138, 248, 158),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.meetings[selectedMeetingIndex]['date']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 255, 253, 253),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.meetings[selectedMeetingIndex]['title']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 246, 245, 245),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.people,
                          color: Color.fromARGB(255, 255, 254, 254),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                textDirection: TextDirection.rtl,
                children: List.generate(3, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMeetingIndex = index;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: selectedMeetingIndex == index
                              ? const LinearGradient(
                                  colors: [
                     Color.fromRGBO(67, 198, 250, 0.513),
                      Color.fromARGB(95, 138, 248, 158),
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                )
                              : null,
                          color: selectedMeetingIndex != index
                              ? Colors.white
                              : null,
                          borderRadius: BorderRadius.circular(10),
                          
                        ),
                        child: ListTile(
                          title: Text(
                            widget.meetings[index]['title']!,
                            style: const TextStyle(fontSize: 16),
                            textDirection: TextDirection.rtl,
                          ),
                          subtitle: Text(
                            widget.meetings[index]['date']!,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
