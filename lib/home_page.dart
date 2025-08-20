import 'dart:convert';

//import 'package:flutter/cupertino.dart';
import 'package:academy_of_coding/ai_text.dart';
import 'package:academy_of_coding/video_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'colors.dart' as color;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List info = [];
  int _selectedIndex = 0;
  void _initData() {
    DefaultAssetBundle.of(context).loadString("json/info.json").then((value) {
      setState(() {
        info = json.decode(value);
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Get.to(() => HomePage());
    } else if (index == 1) {
      Get.to(() => VideoInfo());
    } else if (index == 2) {
      // Navigate to profile or any other page
      Get.to(() => GeminiTextScreen());
    }
    // You can add navigation logic here if needed
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.AppColor.homePageBackground,
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 30, right: 30),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Tutorial",
                  style: TextStyle(
                    fontSize: 30,
                    color: color.AppColor.homePageTitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(child: Container()),
                Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: color.AppColor.homePageIcons,
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: color.AppColor.homePageIcons,
                ),
                SizedBox(width: 15),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: color.AppColor.homePageIcons,
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  "Academy Of Coding",
                  style: TextStyle(
                    fontSize: 20,
                    color: color.AppColor.homePageSubtitle,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  "Details",
                  style: TextStyle(
                    fontSize: 20,
                    color: color.AppColor.homePageDetail,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    Get.to(() => VideoInfo());
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    size: 20,
                    color: color.AppColor.homePageIcons,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.AppColor.gradientFirst.withValues(alpha: 0.8),
                    color.AppColor.gradientSecond.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(80),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(5, 10),
                    blurRadius: 20,
                    color: color.AppColor.gradientSecond.withValues(alpha: 0.2),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.only(left: 20, top: 25, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start Exploring Yourself",
                      style: TextStyle(
                        fontSize: 16,
                        color: color.AppColor.homePageContainerTextSmall,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Let's start Learning",
                      style: TextStyle(
                        fontSize: 25,
                        color: color.AppColor.homePageContainerTextSmall,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "and Watch video Tutorial",
                      style: TextStyle(
                        fontSize: 25,
                        color: color.AppColor.homePageContainerTextSmall,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.timer,
                              size: 20,
                              color: color.AppColor.homePageContainerTextSmall,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "60 min",
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    color.AppColor.homePageContainerTextSmall,
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: color.AppColor.gradientFirst,
                                blurRadius: 10,
                                offset: Offset(4, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(top: 10),
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage("assets/coverimage.jpg"),
                        fit: BoxFit.fill,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 40,
                          offset: Offset(8, 10),
                          color: color.AppColor.gradientSecond.withValues(
                            alpha: 0.50,
                          ),
                        ),
                        BoxShadow(
                          blurRadius: 10,
                          offset: Offset(-1, -5),
                          color: color.AppColor.gradientSecond.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  /* Container(
                    height: 200,
                    width: 350,
                    margin:
                        const EdgeInsets.only(right: 400, bottom: 85, top: 20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: AssetImage("assets/education1.gif"),
                          fit: BoxFit.fill),
                    ),
                  )*/
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Contents",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: color.AppColor.homePageTitle,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: info.length.toDouble() ~/ 2,
                itemBuilder: (_, i) {
                  int a = 2 * i;
                  int b = 2 * i + 1;
                  return Row(
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        margin: EdgeInsets.only(
                          bottom: 25,
                          right: 10,
                          left: 15,
                          top: 15,
                        ),
                        padding: EdgeInsets.only(bottom: 1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: AssetImage(info[a]['img']),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              offset: Offset(5, 5),
                              color: color.AppColor.gradientSecond.withValues(
                                alpha: 0.1,
                              ),
                            ),
                            BoxShadow(
                              blurRadius: 3,
                              offset: Offset(-5, -5),
                              color: color.AppColor.gradientSecond.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              info[a]["title"],
                              style: TextStyle(
                                fontSize: 15,
                                color: color.AppColor.homePageDetail,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 160,
                        height: 160,
                        margin: EdgeInsets.only(bottom: 25, left: 20, top: 25),
                        padding: EdgeInsets.only(bottom: 1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                            image: AssetImage(info[b]['img']),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              offset: Offset(5, 5),
                              color: color.AppColor.gradientSecond.withValues(
                                alpha: 0.1,
                              ),
                            ),
                            BoxShadow(
                              blurRadius: 3,
                              offset: Offset(-5, -5),
                              color: color.AppColor.gradientSecond.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              info[b]["title"],
                              style: TextStyle(
                                fontSize: 15,
                                color: color.AppColor.homePageDetail,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: color.AppColor.homePageIcons,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: color.AppColor.homePageTitle,
        unselectedItemColor: color.AppColor.homePageSubtitle,
        selectedIconTheme: IconThemeData(
          color: color.AppColor.homePageTitle,
          size: 32, // Increase selected icon size
        ),
        unselectedIconTheme: IconThemeData(
          color: color.AppColor.homePageSubtitle,
          size: 24, // Default size for unselected icons
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant),
            label: 'AI Tutor',
          ),
        ],
      ),
    );
  }
}
