import 'package:flutter/material.dart';
import 'package:skillmatch/bloc/blocs/change_job_isactive_bloc.dart';
import 'package:skillmatch/bloc/blocs/job_comment_bloc.dart';
import 'package:skillmatch/bloc/blocs/job_detail_bloc.dart';
import 'package:skillmatch/bloc/blocs/job_list_page_bloc.dart';
import 'package:skillmatch/bloc/blocs/post_job_comment_bloc.dart';
import 'package:skillmatch/bloc/blocs/send_mail_bloc.dart';
import 'package:skillmatch/bloc/blocs/send_mail_validity_bloc.dart';
import 'package:skillmatch/bloc/blocs/user_bloc.dart';
import 'package:skillmatch/bloc/events/job_list_page_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillmatch/bloc/states/job_list_page_states.dart';
import 'package:skillmatch/bloc/states/user_state.dart';
import 'package:skillmatch/data/repository/home_page_repository.dart';
import 'package:skillmatch/job_details_page.dart';
import 'package:get/get.dart';

class OtherProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const OtherProfilePage({super.key, required this.userData});

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  void _showErrorSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    final userData = widget.userData;

    context.read<JobListPageBloc>().add(
      LoadJobListEvent(typeId: -1, userId: userData['id']),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            const SizedBox(width: 10),
            const Text(
              'SkillMatch',
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
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<AuthUserBloc, UserState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                userData['image_url'],
                              ),
                              radius: 60,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              userData['name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 3,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Account Informations :',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        const Icon(Icons.email_outlined),
                                        const SizedBox(width: 10),
                                        Text(
                                          userData['email'],
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone),
                                        const SizedBox(width: 10),
                                        Text(
                                          userData['phone'],
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.home),
                                        const SizedBox(width: 10),
                                        Text(
                                          userData['address'],
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 3,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.black,
                                  ),
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'SEND-MAIL',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Icon(Icons.mail, color: Colors.red),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Jobs:', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 10),
                  BlocBuilder<JobListPageBloc, MyJobListPageStates>(
                    builder: (context, state) {
                      if (state is JobListLoadingState) {
                        return const CircularProgressIndicator();
                      }
                      if (State is JobListErrorState) {
                        return const Text('Unexpected Error!');
                      }
                      state = state as JobListLoadedState;
                      return Column(
                        children: List.generate(state.myJobListModel.jobs.length, (
                          count,
                        ) {
                          state = state as JobListLoadedState;
                          return SizedBox(
                            width: double.infinity,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (state as JobListLoadedState)
                                                .myJobListModel
                                                .jobs[count]['title'],
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 21,
                                            ),
                                          ),
                                          Text(
                                            (state as JobListLoadedState)
                                                .myJobListModel
                                                .jobs[count]['type_name'],
                                          ),
                                          Text(
                                            'Deadline Date: ${(state as JobListLoadedState).myJobListModel.jobs[count]['deadline_date']}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        Get.to(
                                          () => MultiBlocProvider(
                                            providers: [
                                              BlocProvider(
                                                create: (context) =>
                                                    JobDetailBloc(
                                                      homePageRepository: context
                                                          .read<
                                                            HomePageRepository
                                                          >(),
                                                    ),
                                              ),
                                              BlocProvider(
                                                create: (context) =>
                                                    SendMailBloc(
                                                      homePageRepository: context
                                                          .read<
                                                            HomePageRepository
                                                          >(),
                                                    ),
                                              ),
                                              BlocProvider(
                                                create: (context) =>
                                                    JobCommentBloc(
                                                      homePageRepository: context
                                                          .read<
                                                            HomePageRepository
                                                          >(),
                                                    ),
                                              ),
                                              BlocProvider(
                                                create: (context) =>
                                                    PostJobCommentBloc(
                                                      homePageRepository: context
                                                          .read<
                                                            HomePageRepository
                                                          >(),
                                                    ),
                                              ),
                                              BlocProvider(
                                                create: (context) =>
                                                    SendMailValidityBloc(
                                                      homePageRepository: context
                                                          .read<
                                                            HomePageRepository
                                                          >(),
                                                    ),
                                              ),
                                              BlocProvider(
                                                create: (context) =>
                                                    ChangeJobIsActiveBloc(
                                                      homePageRepository: context
                                                          .read<
                                                            HomePageRepository
                                                          >(),
                                                    ),
                                              ),
                                            ],
                                            child: JobDetailsPage(
                                              jobId:
                                                  (state as JobListLoadedState)
                                                      .myJobListModel
                                                      .jobs[count]['id'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Details'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
