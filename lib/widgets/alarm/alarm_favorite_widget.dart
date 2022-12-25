import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:omega_clock/screens/favorite.dart';
import 'package:omega_clock/widgets/favorite_button.dart';
import 'package:omega_clock/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmFavoriteWidget extends StatefulWidget {
  final alarmName;
  final alarmTime;
  String alarmFavoriteListAsString;
  String alarmUsed;
  AlarmFavoriteWidget(this.alarmName, this.alarmTime,
      this.alarmFavoriteListAsString, this.alarmUsed,
      {super.key});

  @override
  State<AlarmFavoriteWidget> createState() => _AlarmFavoriteWidgetState();
}

bool isLoading = false;

bool _visibleLoading = false;

bool firstTimeLoading = true;

class _AlarmFavoriteWidgetState extends State<AlarmFavoriteWidget> {
  bool _visibleFavorite = false;
  int? index;
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
      getFavoriteIndex();
    }
  }

  getFavoriteIndex() async {
    final prefs = await SharedPreferences.getInstance();
    index = prefs.getInt("FavoriteIndex")!;
  }

  @override
  Widget build(BuildContext context) {
    bool alarmFavorite = widget.alarmFavoriteListAsString == 'true';
    getFavoriteIndex();
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 25),
                                        child: IconButton(
                                          onPressed: () {
                                            // info delete
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
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
                                                              child:
                                                                  Text("Okey")),
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
                                    if (!_visibleFavorite)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: FavoriteButton(
                                          iconSize: 55,
                                          isFavorited: alarmFavorite,
                                          valueChanged: (_isChanged) async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            if (_isChanged) {
                                              debugPrint("Is changed true");

                                              alarmFavoriteNameList
                                                  .add(widget.alarmName);
                                              alarmFavoriteTimeList
                                                  .add(widget.alarmTime);

                                              prefs.setStringList(
                                                  'alarmFavoriteNameList',
                                                  alarmFavoriteNameList);
                                              prefs.setStringList(
                                                  'alarmFavoriteTimeList',
                                                  alarmFavoriteTimeList);

                                              // test favorite
                                              alarmFavoriteList
                                                  .removeAt(index!);
                                              alarmFavoriteList.insert(
                                                  index!, "true");
                                              prefs.setStringList(
                                                  'alarmFavoriteList',
                                                  alarmFavoriteList);
                                              // end

                                              setState(() {
                                                _visibleFavorite = true;
                                              });
                                            }
                                            if (!_isChanged) {
                                              debugPrint("Is changed false");

                                              alarmFavoriteNameList
                                                  .remove(widget.alarmName);
                                              alarmFavoriteTimeList
                                                  .remove(widget.alarmTime);

                                              prefs.setStringList(
                                                  'alarmFavoriteNameList',
                                                  alarmFavoriteNameList);
                                              prefs.setStringList(
                                                  'alarmFavoriteTimeList',
                                                  alarmFavoriteTimeList);

                                              // test favorite
                                              alarmFavoriteList
                                                  .removeAt(index!);
                                              alarmFavoriteList.insert(
                                                  index!, "false");
                                              prefs.setStringList(
                                                  'alarmFavoriteList',
                                                  alarmFavoriteList);
                                              debugPrint(
                                                  alarmFavoriteList.toString());
                                              debugPrint(index.toString());
                                              // end
                                            }
                                          },
                                        ),
                                      ),
                                    if (_visibleFavorite)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15, bottom: 5),
                                        child: IconButton(
                                          onPressed: () async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            alarmFavoriteNameList
                                                .remove(widget.alarmName);
                                            alarmFavoriteTimeList
                                                .remove(widget.alarmTime);

                                            prefs.setStringList(
                                                'alarmFavoriteNameList',
                                                alarmFavoriteNameList);
                                            prefs.setStringList(
                                                'alarmFavoriteTimeList',
                                                alarmFavoriteTimeList);

                                            // test favorite
                                            alarmFavoriteList.removeAt(index!);
                                            alarmFavoriteList.insert(
                                                index!, "false");
                                            prefs.setStringList(
                                                'alarmFavoriteList',
                                                alarmFavoriteList);
                                            // end

                                            setState(() {
                                              _visibleFavorite =
                                                  !_visibleFavorite;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: 40,
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                                if (widget.alarmUsed == "true")
                                  Text(
                                    "This alarm has already gone off, please delete",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
              ]
            ],
          ),
        ));
  }
}
