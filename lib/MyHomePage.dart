// ignore: file_names
import 'dart:math';

import 'package:flutter/material.dart';

final double buttonSize = 80;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: CircularFabWidget()));
  }

  CircularFabWidget() {
    return Flow(
      delegate: FlowMenuDelegate(controller: controller),
      children:
          <IconData>[
            Icons.mail,
            Icons.call,
            Icons.notifications,
            Icons.sms,
            Icons.menu,
          ].map<Widget>((buildFAB)).toList(),
    );
  }

  Widget buildFAB(IconData icon) => SizedBox(
    width: buttonSize,
    height: buttonSize,
    child: FloatingActionButton(
      elevation: 0,
      splashColor: Colors.black,
      shape: CircleBorder(),
      backgroundColor: Colors.red,
      child: Icon(icon, color: Colors.white, size: 45),
      onPressed: () {
        if (controller.status == AnimationStatus.completed) {
          controller.reverse();
        } else {
          controller.forward();
        }
      },
    ),
  );
}

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> controller;

  FlowMenuDelegate({required this.controller}) : super(repaint: controller);

  @override
  void paintChildren(FlowPaintingContext context) {
    final size = context.size;
    final xStart = size.width - buttonSize;
    final yStart = size.height - buttonSize;

    final n = context.childCount;
    for (var i = 0; i < n; i++) {
      final isLastItem = i == context.childCount - 1;
      setValue(value) => isLastItem ? 0.0 : value;

      final radius = 180 * controller.value;
      final theta = i * pi * 0.5 / (n - 2);
      final x = xStart - setValue(radius * cos(theta));
      final y = yStart - setValue(radius * sin(theta));
      context.paintChild(
        i,
        transform:
            Matrix4.identity()
              ..translate(x, y, 0)
              ..translate(buttonSize / 2, buttonSize / 2)
              ..rotateZ(
                isLastItem ? 0.0 : 180 * (1 - controller.value) * pi / 180,
              )
              ..scale(isLastItem ? 1.0 : max(controller.value, 0.5))
              ..translate(-buttonSize / 2, -buttonSize / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}
