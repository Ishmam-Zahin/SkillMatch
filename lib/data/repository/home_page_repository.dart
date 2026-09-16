import 'package:worklance/data/model/job_comments_model.dart';
import 'package:worklance/data/model/job_detail_model.dart';
import 'package:worklance/data/model/job_list_model.dart';
import 'package:worklance/data/model/jobs_types_model.dart';
import 'package:worklance/data/model/search_item_model.dart';
import 'package:worklance/data/providers/add_job_provider.dart';
import 'package:worklance/data/providers/delete_job_provider.dart';
import 'package:worklance/data/providers/job_comments_provider.dart';
import 'package:worklance/data/providers/job_detail_provider.dart';
import 'package:worklance/data/providers/job_isActive_provider.dart';
import 'package:worklance/data/providers/job_list_provider.dart';
import 'package:worklance/data/providers/job_types_provider.dart';
import 'package:worklance/data/providers/search_provider.dart';
import 'package:worklance/data/providers/send_mail_provider.dart';

abstract class IHomePageRepository {
  Future<MyJobListModel> getJobList(
    int typeId, {
    String? userId,
    List<String> userSkills = const [],
  });
  Future<MyjobTypesModel> getJobTypes();
  Future<void> uploadJob({
    required String title,
    required String dsc,
    required String deadlineDate,
    required String userId,
    required int typeId,
    required List<String> requiredSkills,
  });
  Future<MyJobDetailModel> getJobDetail({required int jobId});

  Future<void> applyJob({
    required String userEmail,
    required String userId,
    required int jobId,
  });

  Future<bool> applyJobValidity({required String userId, required int jobId});

  Future<MyJobCommentsModel> getComments({required int jobId});

  Future<void> postComment({
    required String userId,
    required jobId,
    required String comTxt,
  });

  Future<void> changeJobState({required int jobId, required bool status});

  Future<void> deleteJob({required int jobId});

  Future<SearchItemModel> searchItem({required name});
}

class HomePageRepository implements IHomePageRepository {
  final MyJobListProvider myJobListProvider;
  final MyJobTypesProvider myJobTypesProvider;
  final MyAddJobprovider myAddJobprovider;
  final MyJobDetailProvider myJobDetailProvider;
  final MySendMailProvider mySendMailProvider;
  final MyJobCommentsProvider myJobCommentsProvider;
  final MyJobIsActiveProvider myJobIsActiveProvider;
  final DeleteJobProvider deleteJobProvider;
  final SearchProvider searchProvider;

  HomePageRepository({
    required this.myJobListProvider,
    required this.myJobTypesProvider,
    required this.myAddJobprovider,
    required this.myJobDetailProvider,
    required this.mySendMailProvider,
    required this.myJobCommentsProvider,
    required this.myJobIsActiveProvider,
    required this.deleteJobProvider,
    required this.searchProvider,
  });

  @override
  Future<MyJobListModel> getJobList(
    int typeId, {
    String? userId,
    List<String> userSkills = const [],
  }) async {
    try {
      return await myJobListProvider.getJobList(
        typeId,
        userId: userId,
        userSkills: userSkills,
      );
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<MyjobTypesModel> getJobTypes() async {
    try {
      return myJobTypesProvider.getJobTypes();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> uploadJob({
    required String title,
    required String dsc,
    required String deadlineDate,
    required String userId,
    required int typeId,
    required List<String> requiredSkills,
  }) async {
    try {
      return await myAddJobprovider.uploadJob(
        title: title,
        dsc: dsc,
        deadlineDate: deadlineDate,
        userId: userId,
        typeId: typeId,
        requiredSkills: requiredSkills,
      );
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<MyJobDetailModel> getJobDetail({required int jobId}) async {
    try {
      return await myJobDetailProvider.getJobDetail(jobId: jobId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> applyJob({
    required String userEmail,
    required String userId,
    required int jobId,
  }) async {
    try {
      await mySendMailProvider.sendMail(
        userEmail: userEmail,
        userId: userId,
        jobId: jobId,
      );
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<MyJobCommentsModel> getComments({required int jobId}) async {
    try {
      return await myJobCommentsProvider.getCommets(jobId: jobId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> postComment({
    required String userId,
    required jobId,
    required String comTxt,
  }) async {
    try {
      await myJobCommentsProvider.postComment(
        userId: userId,
        jobId: jobId,
        comTxt: comTxt,
      );
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<bool> applyJobValidity({
    required String userId,
    required int jobId,
  }) async {
    try {
      return await mySendMailProvider.isValid(userId: userId, jobId: jobId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> changeJobState({
    required int jobId,
    required bool status,
  }) async {
    try {
      await myJobIsActiveProvider.setJobActive(jobId: jobId, status: status);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deleteJob({required int jobId}) async {
    try {
      await deleteJobProvider.deleteJob(jobId: jobId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<SearchItemModel> searchItem({required name}) async {
    try {
      return await searchProvider.searchItem(name: name);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
