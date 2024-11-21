import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';  // Import Shimmer package
import 'package:meety/widgets/meetingDetails.dart';

class UpcomingMeetingsWidget extends StatefulWidget {
  const UpcomingMeetingsWidget({super.key});

  @override
  _UpcomingMeetingsWidgetState createState() => _UpcomingMeetingsWidgetState();
}

class _UpcomingMeetingsWidgetState extends State<UpcomingMeetingsWidget> {
  int selectedMeetingIndex = 0;
  bool isLoading = false; // Track loading state

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('meetings').snapshots(),
      builder: (context, snapshot) {
      
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No upcoming meetings available.'));
        }

        final meetings = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.rtl,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'פגישה קרובה',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                _buildMainMeetingCard(meetings[selectedMeetingIndex]),
                const SizedBox(width: 12),
                _buildMeetingList(meetings),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Builds the large meeting card on the left.
  Widget _buildMainMeetingCard(QueryDocumentSnapshot meeting) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true; // Show loading effect
        });

        final meetingId = meeting.id;
        if (meetingId.isNotEmpty) {
          await Future.delayed(const Duration(milliseconds: 300)); // Simulate a short delay
          setState(() {
            isLoading = false;
          });

         //  with the selected meeting's ID  navigate open the bottom sheet with 80 percent of screen 
        showModalBottomSheet(
  context: context,
  isScrollControlled: true, // this must be true to change height dynamically
  builder: (BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.75, // Adjust this value to change the height of the bottom sheet
      child: MeetingDetailsContent(meetingId: meetingId),
    );
  },
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),
);



        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Invalid Meeting ID')),
          );
        }
      },
      child: Hero(
              tag: meeting.id,
              child: SizedBox(
                width: 160,
                height: 250,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                         Color.fromRGBO(67, 198, 250, 0.42),
                      Color.fromARGB(92, 141, 250, 161),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(
                              (meeting['date'] as Timestamp).toDate()),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 23, 22, 22),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          meeting['title'] ?? 'Untitled Meeting',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 28, 26, 26),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.people, color: Color.fromARGB(255, 21, 18, 18)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  /// Builds the shimmer effect for loading.
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 160,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
           
        ),
      ),
    );
  }

  /// Builds the smaller meeting list on the right side.
  Widget _buildMeetingList(List<QueryDocumentSnapshot> meetings) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        textDirection: TextDirection.rtl,
        children: List.generate(3, (index) {
          final meeting = meetings[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedMeetingIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              decoration: BoxDecoration(
                gradient: selectedMeetingIndex == index
                    ? const LinearGradient(
                        colors: [
                          Color.fromRGBO(67, 198, 250, 0.247),
                      Color.fromARGB(66, 141, 250, 161),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      )
                    : null,
                color: selectedMeetingIndex != index ? const Color.fromARGB(255, 253, 252, 252) : null,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
                
              ),
              child: ListTile(
                title: Text(
                  meeting['title'] ?? 'Untitled Meeting',
                  style: const TextStyle(fontSize: 16),
                  textDirection: TextDirection.rtl,
                ),
                subtitle: Text(
                  _formatDate(
                    (meeting['date'] as Timestamp).toDate(),
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Helper method to format the date.
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
