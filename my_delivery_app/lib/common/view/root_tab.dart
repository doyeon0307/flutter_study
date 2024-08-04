import 'package:flutter/material.dart';
import 'package:my_delivery_app/common/const/colors.dart';
import 'package:my_delivery_app/common/layout/default_layout.dart';
import 'package:my_delivery_app/restaurant/view/restaurant_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

  class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin{
  int index = 0;
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 4,
      vsync: this, // controller를 선언하는 state
      // vsync를 위해 with SingleTickerProviderStateMixin 추가
    );
    controller.addListener(tabListener);
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(tabListener);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        title: '코팩 딜리버리',
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: PRIMARY_COLOR,
          unselectedItemColor: BODY_TEXT_COLOR,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.shifting,
          onTap: (index) {
            controller.animateTo(index);
          },
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_outlined),
              label: '음식',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: '주문',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: '프로필',
            ),
          ],
        ),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: const [
            RestaurantScreen(),
            Center(child: Text('음식'),),
            Center(child: Text('주문'),),
            Center(child: Text('프로필'),),
          ],
        )
    );
  }
}
