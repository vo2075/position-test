import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'large_container.dart';
import 'small_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  await windowManager.setAsFrameless();
  await windowManager.setHasShadow(false);
  await windowManager.setBackgroundColor(Colors.transparent);
  await windowManager.setSize(const Size(100, 100));
  await windowManager.setPosition(const Offset(0, 0));
  await windowManager.setAlwaysOnTop(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDragging = false;
  bool _isHovering = false;

  @override
    void initState() {
      super.initState();
    }

  void _updateWindowSize(bool isHovering) async {
    if (isHovering) {
      await windowManager.setSize(const Size(450, 300));
    } else {
      await windowManager.setSize(const Size(100, 100));
    }
  }

  void _toggleDragging(bool dragging) async {
    setState(() {
      _isDragging = dragging;
    });
    if (dragging) {
      await windowManager.setSize(const Size(100, 100));
      var position = await _loadPosition();
      double? positionX = position[0];
      double? positionY = position[1];
      await windowManager.setPosition(Offset(positionX! + 300, positionY! + 0));
    } else {
      _updateWindowSize(_isHovering);
    }
  }

  Future _loadPosition() async {
    final prefs = await SharedPreferences.getInstance();
    double? positionX = prefs.getDouble('positionX');
    double? positionY = prefs.getDouble('positionY');
    return [positionX, positionY];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
       child:
            MouseRegion(
                onEnter: (_) {
                  if (!_isDragging) {
                    setState(() => _isHovering = true);
                    _updateWindowSize(true);
                  }
                },
                onExit: (_) {
                  if (!_isDragging) {
                    setState(() => _isHovering = false);
                    _updateWindowSize(false);
                  }
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child:
                    (_isDragging
                      ? SmallContainer(
                          key: const ValueKey('small-dragging'),
                        )
                      : (_isHovering
                          ? LargeContainer(
                              key: const ValueKey('large'),
                              onDragStart: () { 
                                _toggleDragging(true);
                                print('start drag');
                              },
                              onDragEnd: () {
                                _toggleDragging(false);
                                print('end drag');
                              },
                            )
                          : SmallContainer(
                              key: const ValueKey('small'),
                            ))),
              ),
            )
      )
    );
  }
}
