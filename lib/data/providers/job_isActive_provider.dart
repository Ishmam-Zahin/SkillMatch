import 'package:supabase_flutter/supabase_flutter.dart';

class MyJobIsActiveProvider {
  Future<void> setJobActive({
    required int jobId,
    required bool status,
  }) async {
    try {
      await Supabase.instance.client
          .from('jobs')
          .update({'active': status}).eq('id', jobId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
