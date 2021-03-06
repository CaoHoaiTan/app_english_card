import 'dart:math';

import 'package:app_english_card/models/english_today.dart';
import 'package:app_english_card/packages/quote/qoute_model.dart';
import 'package:app_english_card/packages/quote/quote.dart';
import 'package:app_english_card/pages/allwords_page.dart';
import 'package:app_english_card/pages/control_page.dart';
import 'package:app_english_card/values/app_assets.dart';
import 'package:app_english_card/values/app_colors.dart';
import 'package:app_english_card/values/app_styles.dart';
import 'package:app_english_card/values/share_keys.dart';
import 'package:app_english_card/widgets/app_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  String subquote = Quotes().getRandom().content!;
  List<EnglishToday> words = [];

  List<int> fixedListRamdom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];

    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int len = prefs.getInt(ShareKeys.counter) ?? 5;
    List<String> newList = [];
    List<int> rans = fixedListRamdom(len: len, max: nouns.length);
    rans.forEach((index) {
      newList.add(nouns[index]);
    });

    setState(() {
      words = newList.map((e) => getQuote(e)).toList();
    });
  }

  EnglishToday getQuote(String nouns) {
    Quote? quote;
    quote = Quotes().getByWord(nouns);
    return EnglishToday(
      noun: nouns,
      quote: quote?.content,
      id: quote?.id,
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
    getEnglishToday();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        title: Text(
          'English today',
          style:
              AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 36),
        ),
        leading: InkWell(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Image.asset(AppAssets.menu),
        ),
      ),
      body: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 24),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: size.height * 1 / 10,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: Text(
                '"$subquote',
                style: AppStyles.h5
                    .copyWith(fontSize: 12, color: AppColors.textColor),
              ),
            ),
            Container(
              // padding: const EdgeInsets.symmetric(horizontal: 24),
              height: size.height * 2 / 3,
              // page view ????? vu???t ngang
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: words.length > 5 ? 6 : words.length,
                  itemBuilder: (context, index) {
                    String first_Leter =
                        words[index].noun != null ? words[index].noun! : "";

                    first_Leter = first_Leter.substring(0, 1);
                    String leftLetter =
                        words[index].noun != null ? words[index].noun! : "";

                    leftLetter = leftLetter.substring(1, leftLetter.length);

                    String quoteDefault =
                        "???Think of all the beauty still left around you and be happy.???";
                    String quote = words[index].quote == null
                        ? quoteDefault
                        : words[index].quote!;

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                        color: AppColors.primaryColor,
                        child: InkWell(
                          onDoubleTap: () {
                            setState(() {
                              words[index].isFavorite =
                                  !words[index].isFavorite;
                            });
                          },
                          splashColor: Colors.black26,
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          // X??? l?? show  more
                          child: index >= 5
                              ? InkWell(
                                  onTap: () {
                                    print("Show more");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => AllWordsPage(
                                                words: this.words)));
                                  },
                                  child: Center(
                                    child: Text(
                                      "Show more...",
                                      style: AppStyles.h3.copyWith(shadows: [
                                        BoxShadow(
                                            color: Colors.black38,
                                            offset: Offset(3, 6),
                                            blurRadius: 6)
                                      ]),
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.all(16),
                                  // margin: const EdgeInsets.symmetric(vertical: 16),

                                  child: Container(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Container(
                                        //     padding: const EdgeInsets.only(
                                        //         top: 16, right: 16),
                                        //     alignment: Alignment.centerRight,
                                        //     child: Image.asset(
                                        //       AppAssets.heart,
                                        //       color: words[index].isFavorite
                                        //           ? Colors.red
                                        //           : Colors.white,
                                        //     )),
                                        LikeButton(
                                          onTap: (bool isLiked) async {
                                            setState(() {
                                              words[index].isFavorite =
                                                  !words[index].isFavorite;
                                            });
                                            return words[index].isFavorite;
                                          },
                                          isLiked: words[index].isFavorite,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          size: 42,
                                          circleColor: CircleColor(
                                              start: Color(0xff00ddff),
                                              end: Color(0xff0099cc)),
                                          bubblesColor: BubblesColor(
                                            dotPrimaryColor: Color(0xff33b5e5),
                                            dotSecondaryColor:
                                                Color(0xff0099cc),
                                          ),
                                          likeBuilder: (bool isLiked) {
                                            // return Icon(
                                            //   Icons.home,
                                            //   color: isLiked
                                            //       ? Colors.deepPurpleAccent
                                            //       : Colors.grey,
                                            //   size: 42,
                                            // );
                                            return ImageIcon(
                                              AssetImage(AppAssets.heart),
                                              color: isLiked
                                                  ? Colors.red
                                                  : Colors.white,
                                            );
                                          },
                                        ),
                                        RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                            text: TextSpan(
                                                text: first_Leter,
                                                style: TextStyle(
                                                    fontFamily: FontFamily.sen,
                                                    fontSize: 89,
                                                    fontWeight: FontWeight.bold,
                                                    shadows: [
                                                      BoxShadow(
                                                          color: Colors.black38,
                                                          offset: Offset(3, 6),
                                                          blurRadius: 6)
                                                    ]),
                                                children: [
                                                  TextSpan(
                                                    text: leftLetter,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontFamily.sen,
                                                        fontSize: 56,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        shadows: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black38,
                                                              offset:
                                                                  Offset(3, 6),
                                                              blurRadius: 6)
                                                        ]),
                                                  )
                                                ])),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 24),
                                          child: AutoSizeText(
                                            '"$quote"',
                                            maxFontSize: 26,
                                            style: AppStyles.h4.copyWith(
                                                letterSpacing: 3,
                                                color: AppColors.textColor),
                                            maxLines: 9,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    );
                  }),
            ),
            // Indicator
            // _currentIndex >= 5
            //     ? buildShowMore():
            Container(
              height: 12,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(right: 24, left: 24),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  // Cu???n theo chi???u ngang
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return buildIndicator(index == _currentIndex, size);
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          setState(() {
            getEnglishToday();
          });
        },
        child: Image.asset(AppAssets.exchange),
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.lighBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 16),
                child: Text(
                  "Your mind",
                  style: AppStyles.h3.copyWith(color: AppColors.textColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(label: 'Favourites', onTap: () {}),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppButton(
                    label: 'Your control',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ControlPage()));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
      // height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16),

      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
          color: isActive ? AppColors.lighBlue : AppColors.lightGrey,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
          ]),
    );
  }

  Widget buildShowMore() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      alignment: Alignment.centerLeft,
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        color: AppColors.primaryColor,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AllWordsPage(words: this.words)));
          },
          splashColor: Colors.black38,
          borderRadius: BorderRadius.all(Radius.circular(24)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              "Show more",
              style: AppStyles.h5,
            ),
          ),
        ),
      ),
    );
  }
}
