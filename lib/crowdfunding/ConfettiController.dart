import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllConfettWidget extends StatefulWidget {
  final Widget child;

  const AllConfettWidget({Key key, this.child}) : super(key: key);
  @override
  _AllConfettWidgetState createState() => _AllConfettWidgetState();
}

class _AllConfettWidgetState extends State<AllConfettWidget> {
  ConfettiController confettiController;

  @override
  void initState(){
    super.initState();
    confettiController = ConfettiController(duration: Duration(seconds: 2));
    confettiController.play();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: confettiController,
            colors: [
              Colors.blue,
              Colors.red,
              Colors.green,
              Colors.orange,
              Colors.purple,
              Colors.white,
              Colors.yellowAccent
            ],
            shouldLoop: false,
            blastDirectionality: BlastDirectionality.explosive,
            //blastDirection: -pi/2,
            numberOfParticles: 40,
          ),
        ),
        widget.child,
      ],
    );
  }
}
