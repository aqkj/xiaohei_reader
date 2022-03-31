/**
 * 定位
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/31 23:32:24
 */
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:amap_base_core/util/permissions.dart';
import 'package:amap_base_map/amap_base_map.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  AMapController _controller;
  MyLocationStyle _myLocationStyle = MyLocationStyle();
  StreamSubscription _subscription;
  void _updateMyLocationStyle(
    BuildContext context, {
    String myLocationIcon,
    double anchorU,
    double anchorV,
    Color radiusFillColor,
    Color strokeColor,
    double strokeWidth,
    int myLocationType,
    int interval,
    bool showMyLocation,
    bool showsAccuracyRing,
    bool showsHeadingIndicator,
    Color locationDotBgColor,
    Color locationDotFillColor,
    bool enablePulseAnnimation,
    String image,
  }) async {
    if (await Permissions().requestPermission()) {
      _myLocationStyle = _myLocationStyle.copyWith(
        myLocationIcon: myLocationIcon,
        anchorU: anchorU,
        anchorV: anchorV,
        radiusFillColor: radiusFillColor,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        myLocationType: myLocationType,
        interval: interval,
        showMyLocation: showMyLocation,
        showsAccuracyRing: showsAccuracyRing,
        showsHeadingIndicator: showsHeadingIndicator,
        locationDotBgColor: locationDotBgColor,
        locationDotFillColor: locationDotFillColor,
        enablePulseAnimation: enablePulseAnnimation,
      );
      _controller.setMyLocationStyle(_myLocationStyle);
    } else {
      print('权限不足');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('小黑的位置'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: AMapView(
              
              onAMapViewCreated: (controller) {
                _controller = controller;
                controller.addMarker(
                  MarkerOptions(
                    icon: 'images/home_map_icon_positioning_nor.png',
                    position: LatLng(40.851827, 111.801637),
                    title: '哈哈',
                    snippet: '呵呵',
                    object: '测试数据${LatLng(40.851827, 111.801637)}',
                  )
                );
                controller.showMyLocation(true);
                _subscription = _controller.mapClickedEvent
                .listen((it) {
                  print('地图点击: 坐标: $it');
                  
                  _updateMyLocationStyle(context, myLocationType: 6, showMyLocation: true);
                });
              },
              amapOptions: AMapOptions(
                compassEnabled: false,
                zoomControlsEnabled: true,
                logoPosition: LOGO_POSITION_BOTTOM_LEFT
              ),
            ),
          ),
        ],
      )
    );
  }
}