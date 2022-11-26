import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:omega_clock/widgets/favorite_button.dart';

class AlarmMainWidget extends StatefulWidget {
  final alarmName;
  final alarmTime;
  AlarmMainWidget(this.alarmName, this.alarmTime, {super.key});

  @override
  State<AlarmMainWidget> createState() => _AlarmMainWidgetState();
}

bool alarm = true;
bool timer = false;
bool settings = false;
bool donate = false;
bool alarmFavoriteList = false; //etc work

bool isLoading = false;

bool _visibleLoading = false;

bool firstTimeLoading = true;

class _AlarmMainWidgetState extends State<AlarmMainWidget> {
  @override
  void initState() {
    super.initState();
    if (firstTimeLoading == true) {
      // start card_loading widget
      setState(() {
        isLoading = true;
        // start card_loading opacity
        Future.delayed(const Duration(milliseconds: 1), () {
          setState(() {
            _visibleLoading = true;
          });
          // finish card_loading opacity
          Future.delayed(const Duration(milliseconds: 575), () {
            setState(() {
              _visibleLoading = false;
            });
            // start opacity alarm widget
            Future.delayed(const Duration(milliseconds: 575), () {
              setState(() {
                isLoading = false;
                _visibleLoading = true;
                firstTimeLoading = false;
              });
            });
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        opacity: _visibleLoading ? 1 : 0.0,
        duration: const Duration(milliseconds: 575),
        child: SafeArea(
          child: Column(
            children: [
              if (isLoading == true) ...[
                const Padding(
                  padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
                  child: CardLoading(
                    animationDuration: Duration(milliseconds: 750),
                    height: 125,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                ),
              ] else ...[
                Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: SizedBox(
                      height: 125,
                      child: Card(
                        color: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  widget.alarmName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  width: 35,
                                  color: Colors.green,
                                ),
                                Text(
                                  widget.alarmTime,
                                  style: const TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 2,
                              height: MediaQuery.of(context).size.height,
                              color: Colors.green,
                            ),
                            Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.only(right: 25),
                                    child: IconButton(
                                      onPressed: () {
                                        // info delete
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                title: Text(
                                                  "Delete alarm",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 27),
                                                ),
                                                content: Text(
                                                  "To delete an alarm just swipe left and confirm deletion",
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 17),
                                                ),
                                                actions: [
                                                  Center(
                                                    child: SizedBox(
                                                      height: 35,
                                                      width: 90,
                                                      child: ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text("Okey")),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.info_outline,
                                        size: 35,
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: FavoriteButton(
                                    iconSize: 55,
                                    isFavorited: alarmFavoriteList,
                                    valueChanged: (_isChanged) async {},
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ))
              ]
            ],
          ),
        ));
  }
}
