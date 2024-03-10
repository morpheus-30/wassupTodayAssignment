import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wassuptoday/Screens/SavedScreen.dart';
import 'package:wassuptoday/provider/themeAndHeadlines.dart';
import 'package:wassuptoday/utils/util.dart';

class NewsDetailsScreen extends StatelessWidget {
  Map<String, dynamic> newsData;
  NewsDetailsScreen({required this.newsData});
  @override

  

  @override
  Widget build(BuildContext context) {
    bool isSaved = Provider.of<ThemeAndHeadlineProvider>(context, listen: false)
        .savedNews
        .contains(newsData);
    // print(newsData);
    return Scaffold(
      extendBodyBehindAppBar: true,
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 70, left: 10),
            width: 100.w,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: NetworkImage(newsData['urlToImage'] ??
                    "https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg"),
                opacity: 0.4,
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  newsData['title'] ?? "No Title Found",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Wrap(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Text(
                        "By " +
                            (newsData['author'] ??
                                newsData['source']['name'] ??
                                "No Author Found"),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Text(
                        humanizeDateTime(newsData['publishedAt'] ??
                            DateTime.now().toString()),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Text(
                    newsData['content'] ??
                        newsData['description'] ??
                        "No Content Found",
                    style: TextStyle(
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (await hasNetwork() == false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("No Internet Connection"),
                        ),
                      );
                      return;
                    }
                    if (newsData['url'] == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("No URL to open"),
                        ),
                      );
                      return;
                    }
                    Uri url = Uri.parse(newsData['url']);
                    try {
                      await launchUrl(url);
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Could not open the URL"),
                        ),
                      );
                    }
                  },
                  child: SizedBox(
                    width: 40.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.read_more,
                          size: 25.sp,
                        ),
                        Text("Read More", style: TextStyle(fontSize: 15.sp)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                ElevatedButton(
                  child: SizedBox(
                    width: 40.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          isSaved?Icons.bookmark:Icons.bookmark_border,
                          size: 25.sp,
                        ),
                        Text(isSaved?"Remove":"Save", style: TextStyle(fontSize: 15.sp)),
                      ],
                    ),
                  ),
                  onPressed: () async{
                   
                   if(await Provider.of<ThemeAndHeadlineProvider>(context, listen: false).saveNews(newsData)){
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                         content: Row(
                           children: [
                             Text("Article Saved"),
                             TextButton(onPressed: (){
                              Navigator.pop(context);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SavedScreen()));
                             }, child: Text("Open Saved Articles"))
                           ]  
                         ),
                       ),
                     );
                     return;
                   }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Article Removed"),
                        ),
                      );
                   }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
