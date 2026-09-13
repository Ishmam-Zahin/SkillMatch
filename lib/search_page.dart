import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillmatch/bloc/blocs/job_list_page_bloc.dart';
import 'package:skillmatch/bloc/blocs/search_item_bloc.dart';
import 'package:skillmatch/bloc/events/search_item_events.dart';
import 'package:skillmatch/bloc/states/search_item_states.dart';
import 'package:skillmatch/data/repository/home_page_repository.dart';
import 'package:skillmatch/other_profile_page.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchFormKey = GlobalKey<FormState>();
  String? _searchWord;

  void _showErrorSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocConsumer<SearchItemBloc, MySearchItemStates>(
        listener: (context, state) {
          if (state is SearchItemErrorState) {
            _showErrorSnackBar(context, state.error, Colors.red);
          }
        },
        builder: (context, state) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Field
              Form(
                key: _searchFormKey,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Enter the company name',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value == '') {
                      return 'Value can\'t be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _searchWord = value;
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Search Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_searchFormKey.currentState!.validate()) {
                      _searchFormKey.currentState!.save();
                      context.read<SearchItemBloc>().add(
                        SearchItemEvent(name: _searchWord!),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Search',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Searched Items:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // Search Results
              state is SearchItemInitialState
                  ? const Center(child: Text('Search for companies'))
                  : Expanded(
                      child: Column(
                        children: [
                          state is SearchItemLoadingState
                              ? const Center(child: CircularProgressIndicator())
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount: (state as SearchItemLoadedState)
                                        .model
                                        .items
                                        .length,
                                    itemBuilder: (context, count) {
                                      final Map<String, dynamic> company =
                                          state.model.items[count];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 1,
                                        ),
                                        child: Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.network(
                                                company['image_url'],
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      value:
                                                          loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                (loadingProgress
                                                                        .expectedTotalBytes ??
                                                                    1)
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            title: Text(
                                              company['name'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(
                                              company['address'],
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            trailing: TextButton(
                                              onPressed: () {
                                                Get.to(
                                                  MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider(
                                                        create: (context) =>
                                                            JobListPageBloc(
                                                              context
                                                                  .read<
                                                                    HomePageRepository
                                                                  >(),
                                                            ),
                                                      ),
                                                    ],
                                                    child: OtherProfilePage(
                                                      userData: company,
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.blue,
                                              ),
                                              child: const Text(
                                                'View Profile',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
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
  }
}
