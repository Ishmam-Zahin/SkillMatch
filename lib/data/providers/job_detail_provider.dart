import 'package:skillmatch/data/model/job_detail_model.dart';
import 'package:skillmatch/data/model/skill_matching.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyJobDetailProvider {
  Future<MyJobDetailModel> getJobDetail({required int jobId}) async {
    try {
      final response = await Supabase.instance.client.rpc(
        'get_job_detail',
        params: {'j_id': jobId},
      );

      final job = Map<String, dynamic>.from(response[0]);
      job['required_skills'] = normalizeSkills(job['required_skills']);
      return MyJobDetailModel(job: job);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
