import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LargeContainer extends StatefulWidget {
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;

  const LargeContainer({
    super.key,
    required this.onDragStart,
    required this.onDragEnd,
  });

  @override
  _LargeContainerState createState() => _LargeContainerState();
}
class _LargeContainerState extends State<LargeContainer> {
  @override
  void initState() {
   super.initState();
  }

  Future _savePosition() async {            //save the current position of the window to the cache(shared preferences)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('positionX', await windowManager.getPosition().then((value) => value.dx));
    await prefs.setDouble('positionY', await windowManager.getPosition().then((value) => value.dy));
    print('position saved');
  }

  @override
  Widget build(BuildContext context) {           //this is normally a more complex widget with a lot of extra functions but these aren't needed for the movement of the window
  final List<Color> colors = [const Color(0xFF1B5E20).withOpacity(0.7), const Color(0xFF388E3C).withOpacity(0.7)];
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 450,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: 
                 Positioned(
                      right: 60,
                      top: 30,
                      child: GestureDetector(
                        onPanStart: (details) async {    //does get called
                          print('start pan');
                          widget.onDragStart();
                          final offset = details.globalPosition;
                          await windowManager.setPosition(Offset(offset.dx - 50, offset.dy - 50));
                          await windowManager.startDragging();
                          _savePosition();
                        },
                        onPanEnd: (details) {  //not being called
                          widget.onDragEnd();
                          print('end pan '); 
                        },
                        child: const Icon(Icons.open_with, size: 24, color: Colors.black),
                      ),
                    )
              )
           )
        ]
      )
    );
  }
}