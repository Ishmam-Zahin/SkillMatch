import 'package:findjob/data/model/job_list_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyJobListProvider {
  Future<MyJobListModel> getJobList(int typeId, {String? userId}) async {
    try {
      final List<Map<String, dynamic>> response;
      if (typeId == -1) {
        if (userId != null) {
          response = await Supabase.instance.client
              .from('get_job_list')
              .select('*')
              .eq('user_id', userId);
        } else {
          response = await Supabase.instance.client
              .from('get_job_list')
              .select('*')
              .eq('active', true);
        }
      } else {
        response = await Supabase.instance.client
            .from('get_job_list')
            .select('*')
            .eq('type_id', typeId)
            .eq('active', true);
      }

      return MyJobListModel(jobs: response);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
