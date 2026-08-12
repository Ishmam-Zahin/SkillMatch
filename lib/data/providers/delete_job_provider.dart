import 'package:supabase_flutter/supabase_flutter.dart';

class DeleteJobProvider {
  Future<void> deleteJob({required int jobId}) async {
    try {
      await Supabase.instance.client.from('jobs').delete().eq('id', jobId);
    } catch (e) {
      print(e.toString());
      return Future.error(e.toString());
    }
  }
}
