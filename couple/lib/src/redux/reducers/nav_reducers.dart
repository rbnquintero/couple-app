import 'package:redux/redux.dart';

import 'package:couple/src/redux/actions/nav_actions.dart';
import 'package:couple/src/redux/model/nav_state.dart';

Reducer<NavState> navReducer = combineReducers<NavState>(
    [new TypedReducer<NavState, NavUpdateRoute>(updateRoute)]);

NavState updateRoute(NavState navState, NavUpdateRoute action) {
  return NavState(route: action.newRoute, title: action.newTitle);
}
