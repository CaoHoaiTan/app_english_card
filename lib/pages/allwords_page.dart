import 'package:app_english_card/models/english_today.dart';
import 'package:app_english_card/values/app_assets.dart';
import 'package:app_english_card/values/app_colors.dart';
import 'package:app_english_card/values/app_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AllWordsPage extends StatelessWidget {
  final List<EnglishToday> words;
  const AllWordsPage({Key? key, required this.words}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Navigator.pop(context);
          },
          child: Image.asset(AppAssets.leftArrow),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: words
                .map((e) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: AutoSizeText(
                        e.noun ?? '',
                        style: AppStyles.h3.copyWith(shadows: [
                          BoxShadow(
                              color: Colors.black38,
                              offset: Offset(3, 6),
                              blurRadius: 6),
                        ]),
                        maxLines: 1,
                      ),
                    ))
                .toList(),
          )),
    );
  }
}
