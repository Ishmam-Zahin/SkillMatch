import 'package:skillmatch/data/model/jobs_types_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyJobTypesProvider {
  Future<MyjobTypesModel> getJobTypes() async {
    try {
      final response =
          await Supabase.instance.client.from('job_types').select('*');

      return MyjobTypesModel(jobTypes: response);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
