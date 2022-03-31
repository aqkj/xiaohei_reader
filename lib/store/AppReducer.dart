/**
 * 根Reducer
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/05 17:11:37
 */
import './reducers/UserReducer.dart';
class AppState {
  UserState user;
  AppState({
    this.user
  });
}
// 根reducer
AppState appReducer(AppState state, action) {
  return AppState(
    user: userReducer(state.user, action)
  );
}