/**
 * 用户reducer
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/05 17:13:44
 */
import 'package:redux/redux.dart';
// 用户state数据
class UserState {
  Map userInfo;
  UserState({
    this.userInfo
  });
  UserState.empty();
}
final userReducer = TypedReducer<UserState, dynamic>(
  _loadUserInfo
);
// 返回一个userStat
UserState _loadUserInfo(UserState user, dynamic action) {
  user = UserState(userInfo: action.userInfo);
  return user;
}