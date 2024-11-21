import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TopBarWidget extends StatelessWidget {
  final String? userName;
  final String? userImageUrl;
  final int? meetingsToday;
  final bool isLoading; // Add a loading state

  const TopBarWidget({super.key, 
    this.userName,
    this.userImageUrl,
    this.meetingsToday,
    this.isLoading = false, // Default to not loading
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Right-to-left layout
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 40),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/thi.png'), // Background image
            fit: BoxFit.cover,
            opacity: 0.5, // Adjust opacity
          ),
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        child: isLoading
            ? _buildShimmerEffect() // Show shimmer if loading
            : _buildContent(), // Show actual content if not loading
      ),
    );
  }

  /// Builds the actual content of the top bar.
  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildImageWithShimmer(userImageUrl), // Add shimmer for the image
            const SizedBox(width: 10),
            Text(
              ' היי, ${userName ?? 'משתמש'}',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [ Color.fromRGBO(67, 198, 250, 0.513),
                      Color.fromARGB(95, 138, 248, 158),
                          ],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 250.0, 60.0)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            text: 'יש לך היום ',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w100,
              color: Color(0xFF006B56),
            ),
            children: <TextSpan>[
              TextSpan(
                text: '${meetingsToday ?? 0}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [ Color.fromRGBO(67, 198, 250, 0.513),
                      Color.fromARGB(95, 138, 248, 158),],
                    ).createShader(const Rect.fromLTWH(10.0, 0.0, 300.0, 100.0)),
                ),
              ),
              const TextSpan(text: ' פגישות'),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a shimmer effect for the loading state.
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white, // Placeholder for avatar
              ),
              const SizedBox(width: 10),
              Container(
                height: 30,
                width: 150,
                color: Colors.white, // Placeholder for name text
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 25,
            width: 250,
            color: Colors.white, // Placeholder for meetings info
          ),
        ],
      ),
    );
  }

  /// Builds the image with a shimmer effect during loading.
  Widget _buildImageWithShimmer(String? imageUrl) {
    return FutureBuilder(
      future: _loadImage(imageUrl), // Simulate network image loading
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
            ),
          );
        } else if (snapshot.hasError) {
          return const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            child: Icon(Icons.error, color: Colors.red),
          );
        } else {
          return CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(imageUrl ?? ''),
            backgroundColor: Colors.transparent,
          );
        }
      },
    );
  }

  /// Simulates loading the image (for demo purposes).
  Future<void> _loadImage(String? url) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
  }
}
