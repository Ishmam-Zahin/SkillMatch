import 'package:findjob/data/model/search_item_model.dart';

class MySearchItemStates {}

class SearchItemInitialState extends MySearchItemStates {}

class SearchItemLoadingState extends MySearchItemStates {}

class SearchItemLoadedState extends MySearchItemStates {
  final SearchItemModel model;
  SearchItemLoadedState({required this.model});
}

class SearchItemErrorState extends MySearchItemStates {
  final String error;
  SearchItemErrorState({required this.error});
}
