import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import "levels_list.dart";
import "scenarios_list.dart";

class ChallengesMenu extends StatefulWidget {
  const ChallengesMenu({Key? key, 
    required this.title}) : super(key: key);

  final String title;

  @override
  State<ChallengesMenu> createState() => _ChallengesMenu();
}

class _ChallengesMenu extends State<ChallengesMenu> {
    var isPressed = false;
    List<Level> levels = <Level>[]; 

    @override
    void initState() {
        super.initState();
        this.levels = LEVELS;
    }

    @override
    void dispose() {
        super.dispose();
    }

    Container titleWidget() {
        return Container(
        width: double.infinity,
        child: Container(
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
                "🚇 Todos los retos", 
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Futura')
            ),
            ),
        )
        );
    }

    @override
    Widget build(BuildContext context) {
        return Positioned(
            left: 40,
            right: 40,
            bottom: 0,
            top: 80,
            child: Column(
                children: <Widget>[
                    this.titleWidget(),
                    Container(
                        child: Expanded(
                            child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: buildChallenges()
                        )
                    )
                )]
            )
        );
    }

    Container buildChallenges() {
      List<Widget> widgets = [];
      
      this.levels.forEach((level) {
        widgets.add(ChallengeCard(level: level));
      });

      return Container(
        margin: EdgeInsets.symmetric(vertical: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widgets
        )
      );
    }
}

class ChallengeCard extends StatefulWidget {
  const ChallengeCard({Key? key, 
    required this.level}) : super(key: key);

  final Level level;

  @override
  State<ChallengeCard> createState() => _ChallengeCard();
}

class _ChallengeCard extends State<ChallengeCard> {
    var isPressed = false;
    var shouldDisplayListOfChallenges = false;

    Column buildTextContent() {
        return Column(children: [
            ListTile(
                leading: Text(widget.level.icon, style: TextStyle(fontSize: 40)),
                title: Text(
                widget.level.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Futura', color: Colors.white)
                ),
                subtitle: Text(widget.level.description,
                style: TextStyle(fontFamily: 'Futura', fontSize: 13, color: Colors.white))
            ),
            SizedBox(height: 10),
            Text(widget.level.caption,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Futura', fontSize: 11, color: Colors.white)
            )]
        );
    }

    Column buildChallengeList() {

        List<Widget> challenges = [
            Padding(
                padding: EdgeInsets.only(left: 15, bottom: 15, top: 10, right: 15),
                child: Column(children: [
                    Text(widget.level.icon, style: TextStyle(fontSize: 40)),
                    Text(widget.level.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Futura', fontSize: 20, color: Colors.white)
                    )   
                ])
            )
        ];

        SCENARIOS
        .where((i) => i.levelId == widget.level.id)
        .toList()
        .forEach((s) => challenges.add(Challenge(scenario: s)));

        return Column(children: challenges);
    }

    Container buildContent() {
        var cardContent = buildTextContent();

        var backgroundColor = (isPressed && shouldDisplayListOfChallenges) ? widget.level.emphColor : widget.level.color;

        if(shouldDisplayListOfChallenges) {
            cardContent = buildChallengeList();
        }

        return Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            width: double.infinity,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                onEnd: () {
                    setState((){
                        isPressed = false;
                    });
                    
                },
                decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(
                        width: 2,
                        color: Colors.white
                    ),
                    borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                    padding: EdgeInsets.only(left: 15, bottom: 15, top: 20, right: 15),
                    child: widget.level.isBlocked ? Opacity( opacity: 0.5, child: cardContent) : cardContent
                ),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        var container = buildContent();

        var inkwell = InkWell(
            onTap: () {
                setState((){
                    shouldDisplayListOfChallenges = !shouldDisplayListOfChallenges;
                    isPressed = true;
                });
            },
            child: container
        );
        
        return inkwell;
    }
}

class Challenge extends StatefulWidget {
  const Challenge({Key? key, 
    required this.scenario}) : super(key: key);

    final Scenario scenario;

    @override
    State<Challenge> createState() => _Challenge();
}

class _Challenge extends State<Challenge> {
    var isPressed = false;

    @override
    void initState() {
        super.initState();
    }

    @override
    void dispose() {
        super.dispose();
    }

    ListTile buildTextContent() {
        return ListTile(
            contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
            leading: Text(widget.scenario.icon, style: TextStyle(fontSize: 40)),
            title: Text(widget.scenario.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Futura', color: Colors.black)
            ),
            subtitle: Padding(
                padding: EdgeInsets.only(left: 0, bottom: 0, top: 5, right: 0),
                child: Text("Gana ${widget.scenario.path.length-1} monedas",
                    style: TextStyle(fontStyle: FontStyle.italic, fontFamily: 'Futura', fontSize: 13, color: Colors.black)
                )
            )
        );
    }

    Container buildContent() {
        var backgroundColor = isPressed ? Colors.grey : Colors.white;

        return Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            width: double.infinity,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                onEnd: () {
                    setState((){
                        isPressed = false;
                    });
                },
                decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(
                        width: 1,
                        color: Colors.white
                    ),
                    borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                    padding: EdgeInsets.only(left: 15, bottom: 15, top: 20, right: 15),
                    child: buildTextContent()
                ),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        var container = buildContent();

        var inkwell = InkWell(
            onTap: () {
                setState((){
                    isPressed = true;
                });
            },
            child: container
        );
        
        return inkwell;
    }
}