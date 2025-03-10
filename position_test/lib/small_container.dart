import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmallContainer extends StatefulWidget {

  const SmallContainer({
    super.key,
  });

  @override
  _SmallContainerState createState() => _SmallContainerState();
}

class _SmallContainerState extends State<SmallContainer> {

  @override
  void initState() {
    super.initState();
    _loadPosition();
  }

    Future _loadPosition() async {                          //load the saved position from the cache(shared preferences)
    final prefs = await SharedPreferences.getInstance();
    double? positionX = prefs.getDouble('positionX');
    double? positionY = prefs.getDouble('positionY');
    print('position loaded');
    if (positionX != null && positionY != null) {
      await windowManager.setPosition(Offset(positionX, positionY));
      print('position set');
    }
  }

    @override
  Widget build(BuildContext context) {         //this normally does something but this is a simplified static version
    final List<Color> colors = [const Color(0xFF1B5E20).withOpacity(0.7), const Color(0xFF388E3C).withOpacity(0.7)];
        return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: SizedBox(
                height: 75,
                width: 75,
                child: Stack(
                  children: [
                    SizedBox(
                      width: 75,
                      height: 75,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        backgroundColor: Colors.grey.shade300,
                        strokeWidth: 10,
                      ),
                    ),
                    SizedBox(
                      width: 75,
                      height: 75,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0,
                          end: 10,
                        ),
                        duration: const Duration(seconds: 1, milliseconds: 500),
                        builder: (context, value, child) {
                          return CircularProgressIndicator(
                            value: value,
                            color: Colors.green,
                            strokeWidth: 10,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
      ),
    );
  }
  }