import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:findjob/bloc/blocs/change_job_isactive_bloc.dart';
import 'package:findjob/bloc/blocs/job_comment_bloc.dart';
import 'package:findjob/bloc/blocs/job_detail_bloc.dart';
import 'package:findjob/bloc/blocs/job_list_page_bloc.dart';
import 'package:findjob/bloc/blocs/job_types_bloc.dart';
import 'package:findjob/bloc/blocs/post_job_comment_bloc.dart';
import 'package:findjob/bloc/blocs/send_mail_bloc.dart';
import 'package:findjob/bloc/blocs/send_mail_validity_bloc.dart';
import 'package:findjob/bloc/events/job_list_page_events.dart';
import 'package:findjob/bloc/events/job_types_events.dart';
import 'package:findjob/bloc/states/job_list_page_states.dart';
import 'package:findjob/bloc/states/job_types_states.dart';
import 'package:findjob/data/repository/home_page_repository.dart';
import 'package:findjob/job_details_page.dart';
import 'package:get/get.dart';

class JobListPage extends StatelessWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<JobListPageBloc>().add(LoadJobListEvent(typeId: -1));
    context.read<JobTypesBloc>().add(LoadJobTypesEvent());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'HireHub',
              style: TextStyle(
                fontFamily: 'Wet', // Replace with the login page font family
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          BlocBuilder<JobTypesBloc, MyJobTypesStates>(
            builder: (context, state) {
              if (state is JobTypesLoadedState) {
                final types = state.myjobTypesModel.jobTypes;
                types.add({
                  'id': -1,
                  'type_name': 'All',
                });
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: DropdownButton<int>(
                    underline: Container(),
                    hint: const Text('Select Category'),
                    items: types.map((type) {
                      return DropdownMenuItem<int>(
                        value: type['id'] as int,
                        child: Text(type['type_name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      context.read<JobListPageBloc>().add(
                            LoadJobListEvent(typeId: value!),
                          );
                    },
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<JobListPageBloc, MyJobListPageStates>(
        builder: (context, state) {
          if (state is JobListErrorState) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(fontSize: 24),
              ),
            );
          }

          if (state is JobListLoadedState) {
            final jobs = state.myJobListModel.jobs;
            return ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => JobDetailBloc(
                              homePageRepository:
                                  context.read<HomePageRepository>(),
                            ),
                          ),
                          BlocProvider(
                            create: (context) => SendMailBloc(
                              homePageRepository:
                                  context.read<HomePageRepository>(),
                            ),
                          ),
                          BlocProvider(
                            create: (context) => JobCommentBloc(
                              homePageRepository:
                                  context.read<HomePageRepository>(),
                            ),
                          ),
                          BlocProvider(
                            create: (context) => PostJobCommentBloc(
                              homePageRepository:
                                  context.read<HomePageRepository>(),
                            ),
                          ),
                          BlocProvider(
                            create: (context) => SendMailValidityBloc(
                              homePageRepository:
                                  context.read<HomePageRepository>(),
                            ),
                          ),
                          BlocProvider(
                            create: (context) => ChangeJobIsActiveBloc(
                              homePageRepository:
                                  context.read<HomePageRepository>(),
                            ),
                          ),
                        ],
                        child: JobDetailsPage(jobId: job['id']),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 3,
                      horizontal: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              job['user_image_url'],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job['title'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  job['type_name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  job['dsc'],
                                  style: const TextStyle(fontSize: 16),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
