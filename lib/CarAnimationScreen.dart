import 'package:flutter/material.dart';

class CarAnimationScreen extends StatefulWidget {
  final Widget destination;

  CarAnimationScreen({required this.destination});

  @override
  _CarAnimationScreenState createState() => _CarAnimationScreenState();
}

class _CarAnimationScreenState extends State<CarAnimationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => widget.destination),
          );
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned(
                left: _animation.value * MediaQuery.of(context).size.width,
                bottom: 50,
                child: Stack(
                  children: [
                    Icon(Icons.local_shipping, size: 150, color: Colors.orange), // Carrito más grande
                    Positioned(
                      left: -40,
                      top: 30,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: (1 - _animation.value) > 0.5 ? 1 - _animation.value : 0,
                            child: Transform.translate(
                              offset: Offset(-50 * _animation.value, 50 * _animation.value),
                              child: Icon(Icons.cloud, size: 50, color: Colors.grey), // Gas del escape
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
