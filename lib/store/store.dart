import 'package:redux/redux.dart';

class AppState {
  final List<String> items;
  AppState(this.items);
}

// Define your Actions
class AddItemAction {
  String? item;
}

class PerformSearchAction {
  String? query;
}

List<String> itemsReducer(List<String> items, action) {
  if (action is AddItemAction) {
    // Notice how we don't need to recreate the entire state tree! We just focus
    // on returning a new List of Items.
    return new List.from(items)..add(action.item!);
  } else {
    return items;
  }
}

loggingMiddleware(Store<AppState> store, action, NextDispatcher next) {
  print('${new DateTime.now()}: $action');
  next(action);
}

AppState appStateReducer(AppState state, action) => new AppState(
      itemsReducer(state.items, action),
    );

final defaultAppState = AppState([]);
final store = new Store<AppState>(
  appStateReducer,
  initialState: defaultAppState,
  middleware: [loggingMiddleware],
);
