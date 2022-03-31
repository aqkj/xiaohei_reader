/**
 * 底部导航item
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/05 22:24:37
 */
import 'package:flutter/material.dart';
class BottomNavBarItem {
  final Icon icon;
  final Icon activeIcon;
  final Widget title;
  Widget component;
  BottomNavBarItem({
    this.icon,
    this.title,
    this.component,
    this.activeIcon,
  });
}
class ButtomItem extends StatefulWidget {
  final BottomNavBarItem bottomNavBarItem;
  final Function onTap;
  final bool isActive;
  ButtomItem({
    this.bottomNavBarItem,
    this.onTap,
    this.isActive
  });
  @override
  _ButtomItemState createState() => _ButtomItemState();
}

class _ButtomItemState extends State<ButtomItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      onTap: widget.onTap,
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment(0, 0),
        child: AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: widget.isActive ? 18 : 14,
            color: widget.isActive ? Colors.brown : Colors.black87,
          ),
          child: IconTheme(
            data: IconThemeData(
              size: 35,
              color: widget.isActive ? Colors.brown : Colors.black54
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                widget.isActive ? widget.bottomNavBarItem.activeIcon : widget.bottomNavBarItem.icon,
                widget.bottomNavBarItem.title
              ],
            ),
          ),
        ),
      ),
    );
  }
}