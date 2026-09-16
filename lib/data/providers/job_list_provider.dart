import 'package:worklance/data/model/job_list_model.dart';
import 'package:worklance/data/model/skill_matching.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyJobListProvider {
  Future<MyJobListModel> getJobList(
    int typeId, {
    String? userId,
    List<String> userSkills = const [],
  }) async {
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

      final jobs = response.map((job) {
        final requiredSkills = normalizeSkills(job['required_skills']);
        return {
          ...job,
          'required_skills': requiredSkills,
          'match_score': calculateSkillMatchScore(userSkills, requiredSkills),
        };
      }).toList();
      jobs.sort((first, second) {
        final scoreDifference =
            (second['match_score'] as int) - (first['match_score'] as int);
        if (scoreDifference != 0) {
          return scoreDifference;
        }
        return (second['id'] as int).compareTo(first['id'] as int);
      });

      return MyJobListModel(jobs: jobs);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
