import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leo_final/widgets/badge_grid_item.dart';
import 'package:leo_final/widgets/body_container.dart';
import 'package:leo_final/widgets/profile_info.dart';

import '../../constants.dart';
import '../../widgets/back_button.dart';

class BadgesScreen extends StatelessWidget {
  final String userId;
  final String name;
  const BadgesScreen({super.key, required this.name,required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBarBackButton(),
        centerTitle: true,
        title: Text(
          'Badges',
          style: TextStyle(
            fontSize: 16.sp,
            color: darkModeEnabled ? kDarkTextColor : kTextColor,
          ),
        ),
      ),
      body: BodyContainer(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             ProfileInfo(name: name,userId: userId),
            SizedBox(
              height: 30.w,
            ),
            Text(
              'Earned Badges',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16.sp,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20.w,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 25,
                itemBuilder: (context, index) {
                  return const BadgeGridItem(
                    icon: 'assets/icons/ic-gifticon.svg',
                    text: 'Total Gifting Diamond',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}