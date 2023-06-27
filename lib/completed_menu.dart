import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class CompletedMenu extends StatefulWidget {
  const CompletedMenu({Key? key, required this.onTapRestart, required this.onTapReturn, required this.onTapNext }) : super(key: key);

    final Function onTapRestart;
    final Function onTapReturn;
    final Function onTapNext;

    @override
    State<CompletedMenu> createState() => _CompletedMenu();
}

class _CompletedMenu extends State<CompletedMenu> with TickerProviderStateMixin {
    var isBackButtonPressed = false;
    var isStartButtonPressed = false;

    final DecorationTween decorationTween = DecorationTween(
        begin: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8)
        ),
        end: BoxDecoration(
            color: Color(0xffffdc959),
            borderRadius: BorderRadius.circular(8)
        ),
    );

    late final AnimationController _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    late final AnimationController _lottieController;
    
    @override
    void initState() {
        super.initState();

        _lottieController = AnimationController(vsync: this, duration: Duration(milliseconds: 2300));
        _lottieController.addStatusListener((status) { 
            if(status == AnimationStatus.completed){
                Future.delayed(Duration(milliseconds: 8000),() {
                    _lottieController.forward(from: 0.0);
                });
            }
        });
        _lottieController.forward();
    }

    @override
    void dispose() {
        _lottieController.dispose();
        _controller.dispose();
        super.dispose();
    }

    InkWell nextButton() {
        var backgroundColor = isBackButtonPressed ? Colors.grey : Color.fromRGBO(38, 124, 232, 1);

        var container = AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            onEnd: () {
                setState((){
                    isBackButtonPressed = false;
                    this.widget.onTapNext();
                });
            },
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
                padding: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
                child: Text("Siguiente reto",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Futura', fontSize: 15, color: Colors.white)
                )
            ),
        );

        return InkWell(
            onTap: () {
                setState((){
                    isBackButtonPressed = true;
                });
            },
            child: container
        );
    }

    InkWell viewScoreButton() {
        var backgroundColor = isStartButtonPressed ? Colors.grey : Color(0xFFFF7A00);

        var container = AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            onEnd: () {
                setState((){
                    isStartButtonPressed = false;
                    this.widget.onTapRestart();
                });
            },
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
                padding: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
                child: Text("Ve tu score",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Futura', fontSize: 15, color: Colors.white)
                )
            ),
        );

        return InkWell(
            onTap: () {
                setState((){
                    isStartButtonPressed = true;
                });
            },
            child: container
        );
    }

    InkWell restartButton() {
        var backgroundColor = isStartButtonPressed ? Colors.grey : Color.fromRGBO(38, 124, 232, 1);

        var container = AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            onEnd: () {
                setState((){
                    isStartButtonPressed = false;
                    this.widget.onTapRestart();
                });
            },
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
                padding: EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
                child: Text("Jugar de nuevo",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Futura', fontSize: 15, color: Colors.white)
                )
            ),
        );

        return InkWell(
            onTap: () {
                setState((){
                    isStartButtonPressed = true;
                });
            },
            child: container
        );
    }

    Column buildMessageStack() {
        return Column(
            children: <Widget>[
                Container(
                    height: 200,
                    width: double.infinity,
                    child: Center(
                        child: Lottie.asset(
                            'assets/animations/star.json',
                            width: 200,
                            height: 200,
                            fit: BoxFit.fill,
                            repeat: false,
                            controller: _lottieController
                        ),
                    )
                ),
                Container(
                    width: double.infinity,
                    child: Text(
                        "Lo has logrado!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Futura', color: Colors.white)
                    )
                ),
                SizedBox(height: 5),
                Container(
                    width: double.infinity,
                    child: Text(
                        "Completaste este reto exitosamente",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15, fontFamily: 'Futura', color: Colors.white)
                    )
                ),
                SizedBox(height: 20)
            ],
        );
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    DecoratedBoxTransition(
                        decoration: decorationTween.animate(_controller),
                        child: Container(
                            width: 300,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                    children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFFFf84e02),
                                                borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                                children: [
                                                    buildMessageStack()
                                                ]
                                            )
                                        ),
                                        SizedBox(height: 20),
                                        viewScoreButton(),
                                        SizedBox(height: 10),
                                        nextButton(),
                                        SizedBox(height: 10),
                                        restartButton()
                                    ]
                                )
                            )
                        )
                    )
                ]
            )
        );
    }
}

