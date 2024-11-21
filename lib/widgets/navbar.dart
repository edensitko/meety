import 'package:meety/providers/UnreadMessagesProvider.dart';
import 'package:meety/providers/requestProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Navbar extends StatelessWidget {
  final int currentRouteIndex;

  const Navbar({super.key, required this.currentRouteIndex});

  @override
  Widget build(BuildContext context) {
    int unreadCount = context.watch<UnreadMessagesProvider>().unreadCount;
    int friendRequestCount = context.watch<FriendRequestProvider>().unreadRequestCount;

    return Container(
                  color: const Color.fromARGB(255, 238, 238, 238),
    //  padding: EdgeInsets.only(bottom: 15, left: 10, right: 10,top: 2 ), // מרחק מהצדדים ומלמטה
         padding: const EdgeInsets.only(bottom: 0, left: 0, right: 0,top: 0 ), // מרחק מהצדדים ומלמטה
      child: Container(
        padding: const EdgeInsets.only( bottom: 10,top: 0, left: 15,right: 15 ), // פדינג פנימי

        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 249, 246, 246), // צבע רקע שחור כמו בדוגמה
         borderRadius: BorderRadius.circular(30), // רדיוס גדול לעיצוב מעוגל
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // צבע הצללה
              spreadRadius: 2, // פיזור הצללה
              blurRadius: 5, // רמת הצללה
              offset: Offset(0, 2), // מיקום הצללה
            ),
          ],
        ),
        height: 75, // גובה מותאם
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          textDirection: TextDirection.rtl, // כיוון טקסט מימין לשמאל
          children: [
            // Match Button
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: currentRouteIndex == 2
                      ? ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: [Color.fromRGBO(67, 198, 250, 0.513),
                      Color.fromARGB(176, 138, 248, 158),],
                            ).createShader(bounds);

                          },
                          child: Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: currentRouteIndex == 2 ? 34 : 28,
                          ),
                        )
                      : const Icon(
                          Icons.calendar_month,
                          color: Color.fromARGB(255, 176, 175, 175),
                            size: 28,
                        ),
                  onPressed: () {
                    if (currentRouteIndex != 2) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/match', (Route<dynamic> route) => false);
                    }
                  },
                ),
                if (friendRequestCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '$friendRequestCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (currentRouteIndex == 2) _buildIndicator(), // אינדיקטור
              ],
            ),

            // Groups Button
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: currentRouteIndex == 4
                      ? ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                               colors: [Color.fromRGBO(67, 198, 250, 0.513),
                      Color.fromARGB(176, 138, 248, 158),],
                            ).createShader(bounds);
                          },
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size : currentRouteIndex == 4 ? 34 : 28,
                          ),
                        )
                      : const Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 176, 175, 175),
                          size: 28,
                        ),
                  onPressed: () {
                    if (currentRouteIndex != 4) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/groups', (Route<dynamic> route) => false);
                    }
                  },
                ),
                if (currentRouteIndex == 4) _buildIndicator(), // אינדיקטור
              ],
            ),

            // Home Button (Center)
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: currentRouteIndex == 0
                      ? ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
               colors: [Color.fromRGBO(67, 198, 250, 0.513),
                      Color.fromARGB(176, 138, 248, 158),
                          ],
                            ).createShader(bounds);
                          },
                          
                          child:  Icon(
                            Icons.home,
                            color: Colors.white,
                            size:currentRouteIndex == 0 ? 34 : 28,
                          ),
                        )
                      : const Icon(
                          Icons.home,
                          color: Color.fromARGB(255, 176, 175, 175),
                          size: 28,
                        ),
                  onPressed: () {
                    if (currentRouteIndex != 0) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                    }
                  },
                ),
                if (currentRouteIndex == 0) _buildIndicator(), // אינדיקטור
              ],
            ),

            // Chat Button
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: currentRouteIndex == 3
                      ? ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                               colors: [Color.fromRGBO(67, 198, 250, 0.513),
                      Color.fromARGB(176, 138, 248, 158),
                          ],
                            ).createShader(bounds);
                          },
                          child:  Icon(
                            Icons.star,
                            color: Colors.white,
                            size: currentRouteIndex == 3 ? 34 : 28,
                          ),
                        )
                      : const Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 176, 175, 175),
                          size: 28,
                        ),
                  onPressed: () {
                    if (currentRouteIndex != 3) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/chat', (Route<dynamic> route) => false);
                    }
                  },
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                if (currentRouteIndex == 3) _buildIndicator(), // אינדיקטור
              ],
            ),

            // Settings Button
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: currentRouteIndex == 1
                      ? ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                         colors: [ Color.fromRGBO(67, 198, 250, 0.513),
                      Color.fromARGB(176, 138, 248, 158),
                          ],
                            ).createShader(bounds);
                          },
                          child:  Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: currentRouteIndex == 1 ? 34 : 28,
                          ),
                        )
                      : const Icon(
                          Icons.settings,
                          color: Color.fromARGB(255, 176, 175, 175),
                          size: 28,
                        ),
                  onPressed: () {
                    if (currentRouteIndex != 1) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/settings', (Route<dynamic> route) => false);
                    }
                  },
                ),
                if (currentRouteIndex == 1) _buildIndicator(), // אינדיקטור
              ],
            ),
          ],
        ),
      ),
    );
  }

  // פונקציה לבניית אינדיקטור עיצובי מתחת לאייקונים
  Widget _buildIndicator() {
    return Positioned(
      bottom: -10,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
