import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:findjob/bloc/blocs/add_job_bloc.dart';
import 'package:findjob/bloc/blocs/job_types_bloc.dart';
import 'package:findjob/bloc/blocs/user_bloc.dart';
import 'package:findjob/bloc/events/add_job_events.dart';
import 'package:findjob/bloc/events/job_types_events.dart';
import 'package:findjob/bloc/states/add_job_states.dart';
import 'package:findjob/bloc/states/job_types_states.dart';
import 'package:findjob/bloc/states/user_state.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _dsc;
  String? _deadlineDate;
  int? _typeId;
  final TextEditingController _dateControler = TextEditingController();

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  void dispose() {
    _dateControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    'Upload A New Work',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                BlocBuilder<JobTypesBloc, MyJobTypesStates>(
                  builder: (context, state) {
                    if (state is JobTypesInitialState) {
                      context.read<JobTypesBloc>().add(LoadJobTypesEvent());
                    }
                    if (state is JobTypesLoadedState) {
                      final List<Map<String, dynamic>> types =
                          state.myjobTypesModel.jobTypes;
                      return DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Select Category',
                          border: OutlineInputBorder(),
                        ),
                        isExpanded: true,
                        hint: const Text('Select Category'),
                        items: List.generate(types.length, (count) {
                          return DropdownMenuItem<int>(
                            value: types[count]['id'],
                            child: Text(types[count]['type_name']),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            _typeId = value;
                          });
                        },
                        onSaved: (value) {
                          _typeId = value as int?;
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required';
                    }
                    if (value.length <= 5) {
                      return 'Title must be greater than 5 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  maxLines: 6, // Allows multiline input with increased height
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description is required';
                    }
                    if (value.length <= 30) {
                      return 'Description must be greater than 30 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _dsc = value;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dateControler,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? pickDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (pickDate != null) {
                      _deadlineDate = pickDate!.toIso8601String().split('T')[0];
                      _dateControler.text = _deadlineDate!;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Deadline Date',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Deadline Date is required';
                    }
                    try {
                      DateTime.parse(value);
                    } catch (_) {
                      return 'Invalid Date';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _deadlineDate = value;
                  },
                ),
                const SizedBox(height: 40),
                BlocConsumer<AddJobBloc, MyAddJobStates>(
                  listener: (context, state) {
                    if (state is AddJobLoadedState) {
                      _showSnackBar(
                        context,
                        'Job uploaded successfully!',
                        Colors.green,
                      );
                      _formKey.currentState!.reset();
                    }
                    if (state is AddJobErrorState) {
                      _showSnackBar(
                        context,
                        state.error,
                        Colors.red,
                      );
                    }
                  },
                  builder: (context, state) {
                    return Center(
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.blueAccent,
                          ),
                        ),
                        onPressed: state is! AddJobLoadingState
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  final AuthenticateUserSate userState = context
                                      .read<AuthUserBloc>()
                                      .state as AuthenticateUserSate;
                                  final String userId =
                                      userState.myAuthUser.userId;
                                  context.read<AddJobBloc>().add(
                                        UploadJobEvent(
                                          title: _title!,
                                          dsc: _dsc!,
                                          deadlineDate: _deadlineDate!,
                                          userId: userId,
                                          typeId: _typeId!,
                                        ),
                                      );
                                }
                              }
                            : null,
                        child: state is AddJobLoadingState
                            ? const CircularProgressIndicator()
                            : const Text(
                                'POST',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
