import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillmatch/bloc/blocs/change_job_isactive_bloc.dart';
import 'package:skillmatch/bloc/blocs/job_comment_bloc.dart';
import 'package:skillmatch/bloc/blocs/job_detail_bloc.dart';
import 'package:skillmatch/bloc/blocs/job_list_page_bloc.dart';
import 'package:skillmatch/bloc/blocs/job_types_bloc.dart';
import 'package:skillmatch/bloc/blocs/post_job_comment_bloc.dart';
import 'package:skillmatch/bloc/blocs/send_mail_bloc.dart';
import 'package:skillmatch/bloc/blocs/send_mail_validity_bloc.dart';
import 'package:skillmatch/bloc/events/job_list_page_events.dart';
import 'package:skillmatch/bloc/events/job_types_events.dart';
import 'package:skillmatch/bloc/states/job_list_page_states.dart';
import 'package:skillmatch/bloc/states/job_types_states.dart';
import 'package:skillmatch/data/repository/home_page_repository.dart';
import 'package:skillmatch/bloc/states/user_state.dart';
import 'package:skillmatch/bloc/blocs/user_bloc.dart';
import 'package:skillmatch/job_details_page.dart';
import 'package:get/get.dart';

class _AnimatedThreeDots extends StatefulWidget {
  const _AnimatedThreeDots();

  @override
  State<_AnimatedThreeDots> createState() => _AnimatedThreeDotsState();
}

class _AnimatedThreeDotsState extends State<_AnimatedThreeDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 24,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final phase = _controller.value * 2 * math.pi - index * 1.4;
              final opacity = 0.3 + 0.7 * ((math.sin(phase) + 1) / 2);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Opacity(
                  opacity: opacity,
                  child: const CircleAvatar(
                    radius: 3,
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class JobListPage extends StatelessWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userState =
        context.read<AuthUserBloc>().state as AuthenticateUserSate;
    final userSkills = userState.myAuthUser.skills;
    context.read<JobListPageBloc>().add(
      LoadJobListEvent(typeId: -1, userSkills: userSkills),
    );
    context.read<JobTypesBloc>().add(LoadJobTypesEvent());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 32),
            const SizedBox(width: 6),
            const Flexible(
              child: Text(
                'SkillMatch',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Wet',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
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
                types.add({'id': -1, 'type_name': 'All'});
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: PopupMenuButton<int>(
                    tooltip: 'Filter by category',
                    icon: const Icon(Icons.filter_list),
                    onSelected: (value) {
                      context.read<JobListPageBloc>().add(
                        LoadJobListEvent(typeId: value, userSkills: userSkills),
                      );
                    },
                    itemBuilder: (context) {
                      return types.map((type) {
                        return PopupMenuItem<int>(
                          value: type['id'] as int,
                          child: Text(type['type_name']),
                        );
                      }).toList();
                    },
                  ),
                );
              }
              return const _AnimatedThreeDots();
            },
          ),
        ],
      ),
      body: BlocBuilder<JobListPageBloc, MyJobListPageStates>(
        builder: (context, state) {
          if (state is JobListErrorState) {
            return Center(
              child: Text(state.error, style: const TextStyle(fontSize: 24)),
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
                              homePageRepository: context
                                  .read<HomePageRepository>(),
                            ),
                          ),
                          BlocProvider(
                            create: (context) => SendMailBloc(
                              homePageRepository: context
                                  .read<HomePageRepository>(),
                            ),
                          ),
                          BlocProvider(
                            create: (context) => JobCommentBloc(
                              homePageRepository: context
                                  .read<HomePageRepository>(),
                            ),
                          ),
                          BlocProvider(
                            create: (context) => PostJobCommentBloc(
                              homePageRepository: context
                                  .read<HomePageRepository>(),
                            ),
                          ),
                          BlocProvider(
                            create: (context) => SendMailValidityBloc(
                              homePageRepository: context
                                  .read<HomePageRepository>(),
                            ),
                          ),
                          BlocProvider(
                            create: (context) => ChangeJobIsActiveBloc(
                              homePageRepository: context
                                  .read<HomePageRepository>(),
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
                                if ((job['match_score'] as int? ?? 0) > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      '${job['match_score']} skill${job['match_score'] == 1 ? '' : 's'} match',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
