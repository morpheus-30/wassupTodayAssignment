import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:wassuptoday/Screens/LoginScreen.dart';
import 'package:wassuptoday/Screens/NewsDetailsScreen.dart';
import 'package:wassuptoday/Screens/SavedScreen.dart';
import 'package:wassuptoday/provider/themeAndHeadlines.dart';
import 'package:wassuptoday/utils/NetworkHelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic headlineData;

  @override
  void initState() {
    super.initState();
    Provider.of<ThemeAndHeadlineProvider>(context, listen: false)
        .fetchHeadlines(selectedCountry, selectedCategory);
  }

  Future<dynamic> fetchHeadlines(String countrycode, String category) async {
    NetworkHelper networkHelper = NetworkHelper();
    dynamic data = await networkHelper
        .getData('top-headlines?country=$countrycode&category=$category');
    print(data.runtimeType);
    return data;
  }

  String selectedCountry = 'us';
  String selectedCategory = 'general';

  bool isGridView = true;
  Widget _buildGridView() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount:
          Provider.of<ThemeAndHeadlineProvider>(context).headlineData == null
              ? 0
              : Provider.of<ThemeAndHeadlineProvider>(context)
                  .headlineData['articles']
                  .length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailsScreen(
                  newsData: Provider.of<ThemeAndHeadlineProvider>(context)
                      .headlineData['articles'][index],
                ),
              ),
            );
          },
          child: GridTile(
            title: Provider.of<ThemeAndHeadlineProvider>(context)
                .headlineData['articles'][index]['title'],
            imageurl: Provider.of<ThemeAndHeadlineProvider>(context)
                .headlineData['articles'][index]['urlToImage'],
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount:
          Provider.of<ThemeAndHeadlineProvider>(context).headlineData == null
              ? 0
              : Provider.of<ThemeAndHeadlineProvider>(context)
                  .headlineData['articles']
                  .length,
      itemBuilder: (context, index) {
        // print(Provider.of<ThemeAndHeadlineProvider>(context).headlineData['articles'][index]['title']);
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailsScreen(
                  newsData: Provider.of<ThemeAndHeadlineProvider>(context)
                      .headlineData['articles'][index],
                ),
              ),
            );
          },
          child: MyListTile(
            title: Provider.of<ThemeAndHeadlineProvider>(context)
                .headlineData['articles'][index]['title'],
            imgUrl: Provider.of<ThemeAndHeadlineProvider>(context)
                .headlineData['articles'][index]['urlToImage'],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
          drawer: Drawer(
            child: Container(
              margin: EdgeInsets.only(top: 10.h),
              child: Column(
                children: [
                  Text(
                      "Hello ${FirebaseAuth.instance.currentUser!.displayName}!",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      )),
                  WassupTodayDrawerButton(
                    title: 'Sign Out',
                    onPressedFunc: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    width: 60.w,
                    height: 0.25.h,
                    color: Provider.of<ThemeAndHeadlineProvider>(context)
                            .isLightModeOn
                        ? Colors.white
                        : Colors.black,
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  WassupTodayDrawerButton(
                    title: "Saved",
                    onPressedFunc: () {
                      Provider.of<ThemeAndHeadlineProvider>(context, listen: false).fetchSavedNews();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SavedScreen(),
                        ),
                      );
                    },
                    
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'wassupToday? ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Switch(
                  value: Provider.of<ThemeAndHeadlineProvider>(context)
                      .isLightModeOn,
                  onChanged: (val) {
                    Provider.of<ThemeAndHeadlineProvider>(context,
                            listen: false)
                        .switchTheme();
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {
                  setState(() {
                    isGridView = !isGridView;
                  });
                },
                child: Icon(
                  isGridView ? Icons.list : Icons.grid_view,
                ),
              ),
            ],
          ),
          body: isGridView ? _buildGridView() : _buildListView());
    });
  }
}

class WassupTodayDrawerButton extends StatelessWidget {
  Function onPressedFunc;
  String title;
  WassupTodayDrawerButton({required this.onPressedFunc, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor:
                Provider.of<ThemeAndHeadlineProvider>(context)
                        .isLightModeOn
                    ? Colors.black
                    : Colors.white,
          ),
          onPressed: () {
            onPressedFunc();
          },
          child: Text(title,
              style: TextStyle(
                color:
                    Provider.of<ThemeAndHeadlineProvider>(context)
                            .isLightModeOn
                        ? Colors.white
                        : Colors.black,
              ))),
    );
  }
}

class MyListTile extends StatelessWidget {
  String? title;
  String? imgUrl;
  Function? onTap;

  MyListTile({required this.title, required this.imgUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      height: 10.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          opacity: 0.4,
          image: NetworkImage(
            imgUrl ??
                'https://bs-uploads.toptal.io/blackfish-uploads/components/blog_post_page/content/cover_image_file/cover_image/1279949/retina_500x200_cover-best-command-line-tools-98feb625512f30450c52a01f63761266.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title ??
              'Ut esse mollit labore mollit voluptate sint officia ad ullamco reprehenderit.',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}

class GridTile extends StatelessWidget {
  GridTile({this.title, this.imageurl});

  String? title;
  String? imageurl;
  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            opacity: 0.4,
            image: NetworkImage(
              imageurl ??
                  'https://bs-uploads.toptal.io/blackfish-uploads/components/blog_post_page/content/cover_image_file/cover_image/1279949/retina_500x200_cover-best-command-line-tools-98feb625512f30450c52a01f63761266.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        margin: const EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title ??
                'Ut esse mollit labore mollit voluptate sint officia ad ullamco reprehenderit.',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ));
  }
}


// Center(
//         child: Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.only(top: 20),
//               width: 90.w,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   DropdownMenu(
//                     width: 40.w,
//                     dropdownMenuEntries: countryCode.map((e) {
//                       return DropdownMenuEntry(
//                         label: e['country']??'',
//                         value: e['code'],
//                       );
//                     }).toList(),
//                   ),
//                   DropdownMenu(
//                     width: 40.w,
//                     dropdownMenuEntries: categories.map((e) {
//                       return DropdownMenuEntry(
//                         label: e,
//                         value: e,
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),

