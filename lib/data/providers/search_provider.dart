import 'package:findjob/data/model/search_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchProvider {
  Future<SearchItemModel> searchItem({required String name}) async {
    try {
      final response = await Supabase.instance.client
          .from('search_users')
          .select('*')
          .ilike('name', '%$name%');

      return SearchItemModel(items: response);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
