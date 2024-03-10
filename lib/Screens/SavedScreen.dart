import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:wassuptoday/provider/themeAndHeadlines.dart';
import 'NewsDetailsScreen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: Switch(
                value: Provider.of<ThemeAndHeadlineProvider>(context)
                    .isLightModeOn,
                onChanged: (value) {
                  Provider.of<ThemeAndHeadlineProvider>(context, listen: false)
                      .switchTheme();
                },
              ),
            ),
          ],
          leadingWidth: 100,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: const EdgeInsets.only(left: 10, top: 10),
            child: IconButton(
              iconSize: 30,
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  const CircleBorder(
                    side: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                foregroundColor:
                    Provider.of<ThemeAndHeadlineProvider>(context).isLightModeOn
                        ? MaterialStateProperty.all(Colors.black)
                        : MaterialStateProperty.all(Colors.white),
                backgroundColor:
                    Provider.of<ThemeAndHeadlineProvider>(context).isLightModeOn
                        ? MaterialStateProperty.all(Colors.white)
                        : MaterialStateProperty.all(Colors.black),
              ),
              icon: const Icon(
                Icons.arrow_back,
                weight: 2,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )),
      body: Container(
        margin: EdgeInsets.only(top: 20,left: 20),
        child: Column(
          children: [
            Text(
              'Saved Articles',
              style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 90.w,
              height: 60.h,
              child: GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.7,
              ),
              children: [
                ...Provider.of<ThemeAndHeadlineProvider>(context)
                    .savedNews
                    .map((e) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetailsScreen(newsData: e,)
                          ),
                        );
                      },
                      child: Container(
                                        decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(e['urlToImage']),
                        fit: BoxFit.cover,
                      ),
                                        ),
                                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            e['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                                        ),
                                      ),
                    ))
              ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
