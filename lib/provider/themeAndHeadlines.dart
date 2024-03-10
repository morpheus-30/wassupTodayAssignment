import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:json_cache/json_cache.dart';
import 'package:wassuptoday/utils/util.dart';
import 'package:wassuptoday/utils/NetworkHelper.dart';

class ThemeAndHeadlineProvider extends ChangeNotifier {
  
  ThemeData lightTheme = ThemeData(
    useMaterial3: true,
  );
  ThemeData darkTheme = ThemeData(
    useMaterial3: true,
  );

  final JsonCache jsonCache = JsonCacheMem();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  bool isLightModeOn = false;

  dynamic headlineData;
  List savedNews = [];

  void fetchLightMode() async {
    await jsonCache.value("theme").then((value) {
      if (value == null) {
        isLightModeOn = true;
        return;
      }
      isLightModeOn = value['isLightModeOn'];
    });
    notifyListeners();
  }

  Future<void> fetchSavedNews() async {
    savedNews = await firestore
        .collection('SavedArticles')
        .doc(auth.currentUser!.uid)
        .get().then((value) {
      if (value.data() == null) {
        return [];
      }else{
        return value.data()!['articles'];
      }
        });
    notifyListeners();
  }

  Future<bool> saveNews(Map<String, dynamic> newsData) async {
    await fetchSavedNews();
    // if (savedNews.contains(newsData)) {
    //   savedNews.remove(newsData);
    //   await firestore
    //       .collection('SavedArticles')
    //       .doc(auth.currentUser!.uid)
    //       .set({'articles': savedNews});
    //   notifyListeners();
    //   return false;
    // }
    // savedNews.add(newsData);
    // await firestore
    //     .collection('SavedArticles')
    //     .doc(auth.currentUser!.uid)
    //     .set({'articles': savedNews});
    // notifyListeners();
    // return true;
    for (var i = 0; i < savedNews.length; i++) {
      if (savedNews[i]['title'] == newsData['title']) {
        savedNews.removeAt(i);
        await firestore
            .collection('SavedArticles')
            .doc(auth.currentUser!.uid)
            .set({'articles': savedNews});
        notifyListeners();
        return false;
      }
    }
    savedNews.add(newsData);
    await firestore
        .collection('SavedArticles')
        .doc(auth.currentUser!.uid)
        .set({'articles': savedNews});
    notifyListeners();
    return true;
  }

  Future<void> deleteSavedNews(Map<String, dynamic> newsData) async {
    savedNews.remove(newsData);
    await firestore
        .collection('SavedArticles')
        .doc(auth.currentUser!.uid)
        .set({'articles': savedNews});
    notifyListeners();
  }

  Future<bool> isArticleSaved(Map<String, dynamic> newsData) async {
    await fetchSavedNews();
    for (var i = 0; i < savedNews.length; i++) {
      if (savedNews[i]['title'] == newsData['title']) {
        return true;
      }
    }
    return false;
  } 

  Future<void> fetchHeadlines(String countrycode, String category) async {
    NetworkHelper networkHelper = NetworkHelper();
    bool isOnline = await hasNetwork();
    print(isOnline);
    if (!isOnline) {
      await jsonCache
          .value("headlineData")
          .then((value) => this.headlineData = value);
      print("got data from cache");
      notifyListeners();
      return;
    }
    dynamic headlineData = await networkHelper
        .getData('top-headlines?country=$countrycode&category=$category');
    // print(headlineData);
    await jsonCache.refresh("headlineData", headlineData);
    this.headlineData = headlineData;
    print("got data from network");
    notifyListeners();
  }

  void switchTheme() {
    if (lightTheme == ThemeData.light()) {
      lightTheme = ThemeData.dark();
      darkTheme = ThemeData.light();
      isLightModeOn = false;
      jsonCache.refresh("theme", {"isLightModeOn": isLightModeOn});
    } else {
      lightTheme = ThemeData.light();
      darkTheme = ThemeData.dark();
      isLightModeOn = true;
      jsonCache.refresh("theme", {"isLightModeOn": isLightModeOn});
    }
    notifyListeners();
  }
}
