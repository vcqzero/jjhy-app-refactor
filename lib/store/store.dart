import 'package:redux/redux.dart';

// Define your State
class AppState {
  final List<String> items;
  final String searchQuery;

  AppState(this.items, this.searchQuery);
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
  } else if (action is RemoveItemAction) {
    return new List.from(items)..remove(action.item);
  } else {
    return items;
  }
}

// This reducer will take in the current search query and the action, and update the query
// if the action is a `PerformSearchAction`
String? searchQueryReducer(String searchQuery, action) {
  return action is PerformSearchAction ? action.query : searchQuery;
}

loggingMiddleware(Store<int> store, action, NextDispatcher next) {
  print('${new DateTime.now()}: $action');
  next(action);
}

AppState appStateReducer(AppState state, action) => new AppState(
    itemsReducer(state.items, action),
    searchQueryReducer(state.searchQuery, action));

final store = new Store<int>(
  counterReducer,
  initialState: 0,
  middleware: [loggingMiddleware],
);
