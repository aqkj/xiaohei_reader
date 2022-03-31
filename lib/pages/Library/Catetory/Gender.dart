/**
 * 性别分类
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/06 13:50:51
 */
import 'package:flutter/material.dart';
import 'package:intimate_couple/apis/book.dart';
import 'GenderCatetoryItem.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intimate_couple/components/PageLoading.dart';
class CateoryGender extends StatefulWidget {
  final String gender;
  CateoryGender({
    Key key,
    this.gender
  }):super(key: key);
  @override
  _CateoryGenderState createState() => _CateoryGenderState();
}
class _CateoryGenderState extends State<CateoryGender> with AutomaticKeepAliveClientMixin {
  List<dynamic> _data = [];
  List<dynamic> _banner = [];
  // String _error = '无异常';
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 150)).then((value) {
      // 获取性别数据
      _getGenderData();
    });
  }
  _getGenderData() async {
    try {
      final result = await Future.wait([
        getGenderBanner(widget.gender),
        getGenderData(widget.gender),
      ]);
      if (result != null && result.length == 2) {
        setState(() {
          _banner = result[0]['data'];
          _data = result[1]['data'];
        });
      }
      // debugPrint(result.toString());
      // final bannerResult = await getGenderBanner(widget.gender);
      // // 调用接口回去数据
      // final result = await getGenderData(widget.gender);
      // if (result != null && result['data'].length > 0) {
      //   // 更新数据
      //   setState(() {
      //     data = result['data'];
      //     _banner = bannerResult
      //   });
      // }
    } catch (e) {
      print(e);
      // setState(() {
      //   _error = e.toString();
      // });
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _data.length == 0 ? PageLoading() : Container(
      // color: Colors.white,
      child: ListView.builder(
        itemCount: _data.length + 1,
        itemBuilder: (context, int index) {
          if (index == 0) {
            return _banner.length == 0 ? SizedBox() : Container(
              height: 138,
              child: Swiper(
                outer:false,
                itemBuilder: (BuildContext context,int index){
                  return Container(
                    height: 130,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          offset: Offset(1, 1),
                          blurRadius: 9
                        )
                      ],
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(_banner[index]['imgurl']),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                    ),
                  );
                },
                itemCount: _banner.length,
                viewportFraction: 0.8,
                scale: 0.9,
                autoplay: true,
                // pagination: SwiperPagination(
                //   builder:DotSwiperPaginationBuilder(
                //     activeColor: Colors.red
                //   )
                // ),
              )
            );
          }
          return CatetoryItem(
            category: _data[index - 1],
            cateIndex: index - 1,
            gender: widget.gender
          );
        },
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}