import 'package:flutter/material.dart';

class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ModernButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Colors.blue, width: 2.0),
      ),
      color: Colors.white,
      elevation: 2.0,
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


class CircularCenterButton extends StatefulWidget {
  @override
  _CircularCenterButtonState createState() => _CircularCenterButtonState();
}

class _CircularCenterButtonState extends State<CircularCenterButton> {
  bool isPlaying = false;
  double elevation = 2.0;

  void togglePlaying() {
    setState(() {
      isPlaying = !isPlaying;
      elevation = isPlaying ? 2.0 : 20.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: MaterialButton(
          elevation: elevation,
          shape: CircleBorder(),
          color: isPlaying ? Colors.red : Colors.green,
          onPressed: togglePlaying,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isPlaying ? 'Stop' : 'Start'),
              Icon(
                isPlaying ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}