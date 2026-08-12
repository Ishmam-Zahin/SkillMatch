import 'package:findjob/data/model/job_comments_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyJobCommentsProvider {
  Future<MyJobCommentsModel> getCommets({
    required int jobId,
  }) async {
    try {
      final List<Map<String, dynamic>> response =
          await Supabase.instance.client.rpc('get_comments', params: {
        'jobid': jobId,
      });

      return MyJobCommentsModel(comments: response);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> postComment({
    required String userId,
    required jobId,
    required String comTxt,
  }) async {
    try {
      await Supabase.instance.client.from('comments').insert({
        'user_id': userId,
        'job_id': jobId,
        'com_text': comTxt,
      });
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
