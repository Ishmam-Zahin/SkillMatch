import 'package:supabase_flutter/supabase_flutter.dart';

class MyAddJobprovider {
  Future<void> uploadJob({
    required String title,
    required String dsc,
    required String deadlineDate,
    required String userId,
    required int typeId,
    required List<String> requiredSkills,
  }) async {
    try {
      await Supabase.instance.client.from('jobs').insert({
        'title': title,
        'deadline_date': deadlineDate,
        'dsc': dsc,
        'user_id': userId,
        'type_id': typeId,
        'required_skills': requiredSkills,
      });
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
