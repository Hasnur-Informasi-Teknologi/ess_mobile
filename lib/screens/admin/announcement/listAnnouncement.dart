import 'package:flutter/material.dart';

class ListAnnouncmentAdmin extends StatefulWidget {
  const ListAnnouncmentAdmin({super.key});

  @override
  State<ListAnnouncmentAdmin> createState() => _ListAnnouncmentAdminState();
}

class _ListAnnouncmentAdminState extends State<ListAnnouncmentAdmin> {
  var vdata = {};

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textMedium = size.width * 0.0329;
    double paddingHorizontalNarrow = size.width * 0.035;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontalNarrow),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Annoucement",
                style: TextStyle(
                    fontSize: textMedium,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Quicksand'),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      children: [
                        Text(
                          "Announcement General",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("PT Hasnur Informasi Teknologi")
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: const Color.fromARGB(221, 255, 255, 255),
                            elevation: 5,
                            primary: Color.fromARGB(255, 6, 202, 35),
                            padding: EdgeInsets.symmetric(horizontal: 1),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          onPressed: () {},
                          child: IconButton(
                            iconSize: 19,
                            icon: const Icon(Icons.notifications),
                            onPressed: () {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary:
                                  const Color.fromARGB(221, 255, 255, 255),
                              elevation: 5,
                              primary: Color.fromARGB(255, 202, 6, 6),
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onPressed: () {},
                            child: IconButton(
                              iconSize: 19,
                              icon: const Icon(Icons.track_changes),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // ==================================================================
                Divider(
                  height: 3,
                  thickness: 1,
                  color: Colors.grey,
                  indent: 0,
                  endIndent: 0,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Announcement General",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("PT Hasnur Informasi Teknologi")
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: const Color.fromARGB(221, 255, 255, 255),
                            elevation: 5,
                            primary: Color.fromARGB(255, 6, 202, 35),
                            padding: EdgeInsets.symmetric(horizontal: 1),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          onPressed: () {},
                          child: IconButton(
                            iconSize: 19,
                            icon: const Icon(Icons.notifications),
                            onPressed: () {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary:
                                  const Color.fromARGB(221, 255, 255, 255),
                              elevation: 5,
                              primary: Color.fromARGB(255, 202, 6, 6),
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onPressed: () {},
                            child: IconButton(
                              iconSize: 19,
                              icon: const Icon(Icons.track_changes),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // ==================================================================
                Divider(
                  height: 3,
                  thickness: 1,
                  color: Colors.grey,
                  indent: 0,
                  endIndent: 0,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Announcement General",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("PT Hasnur Informasi Teknologi")
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: const Color.fromARGB(221, 255, 255, 255),
                            elevation: 5,
                            primary: Color.fromARGB(255, 6, 202, 35),
                            padding: EdgeInsets.symmetric(horizontal: 1),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          onPressed: () {},
                          child: IconButton(
                            iconSize: 19,
                            icon: const Icon(Icons.notifications),
                            onPressed: () {},
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              onPrimary:
                                  const Color.fromARGB(221, 255, 255, 255),
                              elevation: 5,
                              primary: Color.fromARGB(255, 202, 6, 6),
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onPressed: () {},
                            child: IconButton(
                              iconSize: 19,
                              icon: const Icon(Icons.track_changes),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                // ==================================================================
                Divider(
                  height: 3,
                  thickness: 1,
                  color: Colors.grey,
                  indent: 0,
                  endIndent: 0,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
