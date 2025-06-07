import 'package:flutter/material.dart';
import 'package:vibe_link/controller/variables/static_store.dart';

class DraggableFloatingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final Color color;

  DraggableFloatingButton({
    Key? key,
    this.color = Colors.blue,
    this.icon = const Icon(Icons.drag_handle),
    required this.onPressed,
  }) : super(key: key);

  @override
  _DraggableFloatingButtonState createState() => _DraggableFloatingButtonState();
}

class _DraggableFloatingButtonState extends State<DraggableFloatingButton> {
    double posX=320;
    double posY=700;
  // var context;
  // double height;
  // double width;
  // _DraggableFloatingButtonState(this.height,this.width);

  @override
  Widget build(BuildContext context) {
    // double posX = M-100;
    // double posX = MediaQuery.of(context).size.height;
    // double posY = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          left: posX,
          top: posY,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                posX += details.delta.dx;
                posY += details.delta.dy;
              });
            },
            child: FloatingActionButton(
              onPressed: widget.onPressed,
              backgroundColor: widget.color,
              child: widget.icon,
            ),
          ),
        ),
      ],
    );
  }
}
