import 'package:redux/redux.dart';

class User {
  int id;
  String username;
  String tel;
  List<String>? roles;
  Map? workyard;
  Map? jpush;
  List? workyards;
  User({
    required this.id,
    required this.tel,
    required this.username,
    this.jpush,
    this.roles,
    this.workyard,
    this.workyards,
  });
}

final _defaultUser = User(id: 0, tel: '', username: '');

class _AppState {
  User user;
  _AppState({required this.user});
}

// Define your Actions
class ClearUserAction {}

User _userReducer(User user, action) {
  if (action is ClearUserAction) {
    return _defaultUser;
  } else {
    return user;
  }
}

_loggingMiddleware(Store<_AppState> store, action, NextDispatcher next) {
  print('${new DateTime.now()}: $action');
  next(action);
}

_AppState _appStateReducer(_AppState state, action) => new _AppState(
      user: _userReducer(state.user, action),
    );

final store = new Store<_AppState>(
  _appStateReducer,
  initialState: _AppState(
    user: _defaultUser,
  ),
  middleware: [_loggingMiddleware],
);
