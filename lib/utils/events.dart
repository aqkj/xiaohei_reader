/**
 * 事件集合
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/11 15:37:53
 */
import 'package:event_bus/event_bus.dart';
import 'package:intimate_couple/model/book.dart';
/// 插入book
class InsertBook {
  Book book;
  InsertBook({
    this.book
  });
}
// 更新图书
class UpdateBook {
  Map<String, dynamic> values;
  int id;
  UpdateBook({
    this.values,
    this.id
  });
}
final EventBus eventBus = new EventBus();