import 'package:findjob/data/model/job_detail_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyJobDetailProvider {
  Future<MyJobDetailModel> getJobDetail({required int jobId}) async {
    try {
      final response = await Supabase.instance.client.rpc(
        'get_job_detail',
        params: {
          'j_id': jobId,
        },
      );

      return MyJobDetailModel(job: response[0]);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
