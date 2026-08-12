import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:findjob/bloc/blocs/change_job_isactive_bloc.dart';
import 'package:findjob/bloc/blocs/job_comment_bloc.dart';
import 'package:findjob/bloc/blocs/job_detail_bloc.dart';
import 'package:findjob/bloc/blocs/post_job_comment_bloc.dart';
import 'package:findjob/bloc/blocs/send_mail_bloc.dart';
import 'package:findjob/bloc/blocs/send_mail_validity_bloc.dart';
import 'package:findjob/bloc/blocs/user_bloc.dart';
import 'package:findjob/bloc/events/change_job_isactive_events.dart';
import 'package:findjob/bloc/events/job_comments_events.dart';
import 'package:findjob/bloc/events/job_detail_events.dart';
import 'package:findjob/bloc/events/send_mail_events.dart';
import 'package:findjob/bloc/states/change_job_isActive_states.dart';
import 'package:findjob/bloc/states/job_comments_states.dart';
import 'package:findjob/bloc/states/job_detail_states.dart';
import 'package:findjob/bloc/states/send_mail_states.dart';
import 'package:findjob/bloc/states/user_state.dart';

class JobDetailsPage extends StatefulWidget {
  final int jobId;

  const JobDetailsPage({
    super.key,
    required this.jobId,
  });

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  final _postCommentFormKey = GlobalKey<FormState>();
  String? _comTxt;

  void _showErrorSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticateUserSate userState =
        context.read<AuthUserBloc>().state as AuthenticateUserSate;
    final String userId = userState.myAuthUser.userId;
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
      ),
      body: BlocConsumer<JobDetailBloc, MyJobDetailStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is JobDetailInitialState) {
            context
                .read<JobDetailBloc>()
                .add(LoadJobDetailEvent(jobId: widget.jobId));
          }

          if (state is JobDetailErrorState) {
            return Center(
              child: Text(
                state.error,
              ),
            );
          }

          if (state is JobDetailLoadedState) {
            final Map<String, dynamic> job = state.job.job;
            return SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Card(
                        elevation: 5, // Add shadow for better elevation
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(
                                16.0), // Increased padding for better spacing
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Job Title
                                Center(
                                  child: Text(
                                    job['title'],
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight
                                          .bold, // Added bold for emphasis
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Job Info (Image, Name, Address)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // User Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          8), // Rounded corners for the image
                                      child: Image.network(
                                        job['user_image'],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Vertical Divider between Name & Address
                                    Container(
                                      height: 80,
                                      width: 2,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(width: 16),

                                    // Job Info (Name, Address)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          job['name'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          job['address'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                // Divider (Job Details)
                                Divider(color: Colors.grey.shade300),

                                const SizedBox(height: 16),

                                // Total Applicants
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Total Applicants: ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      job['total_applicant'].toString(),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .blueAccent, // Adding a color to highlight it
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.manage_accounts,
                                        size: 20, color: Colors.blueAccent),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Divider
                                Divider(color: Colors.grey.shade300),

                                const SizedBox(height: 16),

                                // Description Title
                                const Center(
                                  child: Text(
                                    'Description',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Job Description Text
                                Text(
                                  job['description'],
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5, // Add shadow for better elevation
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Builder(builder: (context) {
                                  if (userId == job['user_id']) {
                                    return BlocConsumer<ChangeJobIsActiveBloc,
                                        MyChangeJobIsActiveState>(
                                      listener: (context, state) {
                                        if (state
                                            is ChangeJobIsActiveErrorState) {
                                          _showErrorSnackBar(
                                              context, state.error, Colors.red);
                                        }
                                        if (state
                                            is ChangeJobIsActiveLoadedState) {
                                          _showErrorSnackBar(
                                              context,
                                              "Changed Successfully!",
                                              Colors.green);
                                          context.read<JobDetailBloc>().add(
                                              LoadJobDetailEvent(
                                                  jobId: widget.jobId));
                                        }
                                      },
                                      builder: (context, state) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 130,
                                            child: ListTile(
                                              title: const Text(
                                                'ON',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize:
                                                      16, // Adjusted font size for consistency
                                                  fontWeight: FontWeight
                                                      .w600, // Slightly bolder text
                                                ),
                                              ),
                                              leading: Radio(
                                                value: true,
                                                groupValue: job['active'],
                                                onChanged: (value) {
                                                  context
                                                      .read<
                                                          ChangeJobIsActiveBloc>()
                                                      .add(
                                                        ChangeMyJobIsActiveEvent(
                                                          jobId: widget.jobId,
                                                          status: true,
                                                        ),
                                                      );
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 140,
                                            child: ListTile(
                                              title: const Text(
                                                'OFF',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize:
                                                      16, // Adjusted font size for consistency
                                                  fontWeight: FontWeight
                                                      .w600, // Slightly bolder text
                                                ),
                                              ),
                                              leading: Radio(
                                                value: false,
                                                groupValue: job['active'],
                                                onChanged: (value) {
                                                  context
                                                      .read<
                                                          ChangeJobIsActiveBloc>()
                                                      .add(
                                                        ChangeMyJobIsActiveEvent(
                                                          jobId: widget.jobId,
                                                          status: false,
                                                        ),
                                                      );
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  return BlocBuilder<SendMailValidityBloc,
                                          MySendMailStates>(
                                      builder: (context, state3) {
                                    if (state3
                                        is SendMailValidityInitialState) {
                                      context.read<SendMailValidityBloc>().add(
                                            SendMailValidityCheckEvent(
                                                userId: userId,
                                                jobId: widget.jobId),
                                          );
                                    }
                                    if (state3
                                        is SendMailValidityLoadingState) {
                                      return const CircularProgressIndicator();
                                    }
                                    if (state3 is SendMailValidityLoadedState) {
                                      if (!state3.isValid) {
                                        return const Center(
                                          child: Text(
                                            'Already Applied!',
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 20,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                    return BlocBuilder<SendMailBloc,
                                        MySendMailStates>(
                                      builder: (context, state2) {
                                        if (state2 is SendMailLoadedState) {
                                          return const Center(
                                            child: Text(
                                              'Applied Successfully!',
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontSize: 20,
                                              ),
                                            ),
                                          );
                                        }
                                        return Center(
                                          child: ElevatedButton(
                                            style: const ButtonStyle(
                                              padding: WidgetStatePropertyAll(
                                                EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 15,
                                                ),
                                              ),
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                Colors.blueAccent,
                                              ),
                                            ),
                                            onPressed: () {
                                              final String userEmail =
                                                  job['user_email'];

                                              final int jobId = job['id'];
                                              context.read<SendMailBloc>().add(
                                                    SendMailEvent(
                                                      userEmail: userEmail,
                                                      userId: userId,
                                                      jobId: jobId,
                                                    ),
                                                  );
                                            },
                                            child: const Text(
                                              'Apply Now',
                                              style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  });
                                }),
                                const SizedBox(
                                  height: 10,
                                ),
                                Divider(color: Colors.grey.shade300),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Uploaded Date: ${job['upload_date']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Deadline Date: ${job['deadline_date']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Divider(color: Colors.grey.shade300),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Center(
                          child: Text(
                        'Comments',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      )),
                      Card(
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Form(
                                      key: _postCommentFormKey,
                                      child: Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'Enter your comment...',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.green),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[100],
                                          ),
                                          onSaved: (value) {
                                            _comTxt = value;
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    BlocConsumer<PostJobCommentBloc,
                                        MyJobCommentsStates>(
                                      listener: (context, state) {
                                        if (state
                                            is PostJobCommentLoadedState) {
                                          _showErrorSnackBar(
                                              context,
                                              'Comment posted successfully!',
                                              Colors.green);
                                          _postCommentFormKey.currentState!
                                              .reset();
                                          context.read<JobCommentBloc>().add(
                                              LoadCommentsEvent(
                                                  jobId: widget.jobId));
                                        }
                                        if (state is PostJobCommentErrorState) {
                                          _showErrorSnackBar(
                                              context, state.error, Colors.red);
                                        }
                                      },
                                      builder: (context, state) {
                                        return ElevatedButton(
                                          onPressed: state
                                                  is! PostJobCommentLoadingState
                                              ? () {
                                                  if (_postCommentFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    _postCommentFormKey
                                                        .currentState!
                                                        .save();
                                                    final AuthenticateUserSate
                                                        userState = context
                                                                .read<
                                                                    AuthUserBloc>()
                                                                .state
                                                            as AuthenticateUserSate;
                                                    final String userId =
                                                        userState
                                                            .myAuthUser.userId;

                                                    context
                                                        .read<
                                                            PostJobCommentBloc>()
                                                        .add(
                                                          PostCommentEvent(
                                                            userId: userId,
                                                            jobId: widget.jobId,
                                                            comTxt: _comTxt!,
                                                          ),
                                                        );
                                                  }
                                                }
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            backgroundColor: Colors.blueAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: state
                                                  is PostJobCommentLoadingState
                                              ? const CircularProgressIndicator()
                                              : const Text(
                                                  'POST',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Colors.grey,
                                height: 1,
                              ),
                              BlocConsumer<JobCommentBloc, MyJobCommentsStates>(
                                listener: (context, state) {},
                                builder: (context, state) {
                                  if (state is JobCommentsErrorState) {
                                    return Text(state.error,
                                        style:
                                            const TextStyle(color: Colors.red));
                                  }
                                  if (state is JobCommentsInitialState) {
                                    context.read<JobCommentBloc>().add(
                                          LoadCommentsEvent(
                                              jobId: widget.jobId),
                                        );
                                  }
                                  if (state is JobCommentsLoadedState) {
                                    final comments = state.comments.comments;
                                    return ListView.builder(
                                      shrinkWrap:
                                          true, // Makes the ListView scrollable within its parent
                                      itemCount: comments.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Image.network(
                                                  comments[index]['user_image'],
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      comments[index]
                                                          ['user_name'],
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      comments[index]
                                                          ['com_time'],
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      comments[index]
                                                          ['com_text'],
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
