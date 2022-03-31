import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'store/AppReducer.dart';
import 'store/reducers/UserReducer.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'pages/WelcomePage.dart';
import 'pages/Home/index.dart';
import 'package:oktoast/oktoast.dart';
void main() {
  // 设置系统状态栏透明
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  final store = new Store(appReducer, initialState: AppState(
    user: UserState.empty()
  ));
  runApp(MyApp(store: store));
}
class MyApp extends StatelessWidget {
  final store;
  MyApp({
    this.store
  });
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: StoreProvider(
        store: store,
        child: MaterialApp(
          // showPerformanceOverlay: true,
          title: '我的小黑',
          navigatorObservers: [
            MyObserver()
          ],
          theme: ThemeData(
            // 主要颜色
            primaryColor: Colors.brown,
            // 背景颜色
            backgroundColor: Color(0xFFEFEFEF),
            // 强调颜色
            accentColor: Color(0xFF888888),
            textTheme: TextTheme(
              //设置Material的默认字体样式
              body1: TextStyle(color: Color(0xFF888888), fontSize: 16.0),
            ),
            // 设置图标默认主题
            iconTheme: IconThemeData(
              color: Colors.brown,
              size: 35.0,
            ),
          ),
          routes: {
            WelcomePage.routeName: (context) {
              return WelcomePage();
            },
            Home.routerName: (context) {
              return Home();
            }
          },
        ),
      )
    );
  }
}
class MyObserver extends NavigatorObserver {
  List<Route<dynamic>> routeStack = List();
  @override
  void didPush(Route route, Route previousRoute) {
    routeStack.add(route);
    // super.didPush(route, previousRoute);
  }
  @override
  void didPop(Route route, Route previousRoute) {
    routeStack.removeLast();
    super.didPop(route, previousRoute);
  }
  @override
  void didRemove(Route route, Route previousRoute) {
    routeStack.removeLast();
    super.didRemove(route, previousRoute);
  }
  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    routeStack.removeLast();
    routeStack.add(newRoute);
    super.didReplace();
  }
}