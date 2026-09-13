import 'package:flutter/material.dart';
import 'package:skillmatch/add_job_page.dart';
import 'package:skillmatch/bloc/blocs/add_job_bloc.dart';
import 'package:skillmatch/bloc/blocs/delete_job_bloc.dart';
import 'package:skillmatch/bloc/blocs/home_page_bloc.dart';
import 'package:skillmatch/bloc/blocs/job_list_page_bloc.dart';
import 'package:skillmatch/bloc/blocs/job_types_bloc.dart';
import 'package:skillmatch/bloc/blocs/search_item_bloc.dart';
import 'package:skillmatch/bloc/blocs/user_bloc.dart';
import 'package:skillmatch/bloc/events/home_page_events.dart';
import 'package:skillmatch/bloc/events/user_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillmatch/bloc/states/home_page_states.dart';
import 'package:skillmatch/data/repository/home_page_repository.dart';
import 'package:skillmatch/job_list_page.dart';
import 'package:skillmatch/profile_page.dart';
import 'package:skillmatch/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomePageBloc, MyHomePageStates>(
        builder: (context, state) {
          if (state is ShowProfilePageState) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => JobListPageBloc(
                    context.read<HomePageRepository>(),
                  ),
                ),
                BlocProvider(
                  create: (context) => DeleteJobBloc(
                    context.read<HomePageRepository>(),
                  ),
                ),
              ],
              child: const ProfilePage(),
            );
          }
          if (state is ShowSearchPageState) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SearchItemBloc(
                    homePageRepository: context.read<HomePageRepository>(),
                  ),
                ),
              ],
              child: const SearchPage(),
            );
          }
          if (state is ShowAddJobPageState) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => JobTypesBloc(
                    homePageRepository: context.read<HomePageRepository>(),
                  ),
                ),
                BlocProvider(
                  create: (context) => AddJobBloc(
                    homePageRepository: context.read<HomePageRepository>(),
                  ),
                ),
              ],
              child: const AddJobPage(),
            );
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => JobListPageBloc(
                  context.read<HomePageRepository>(),
                ),
              ),
              BlocProvider(
                create: (context) => JobTypesBloc(
                  homePageRepository: context.read<HomePageRepository>(),
                ),
              ),
            ],
            child: const JobListPage(),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            switch (index) {
              case 0:
                context.read<HomePageBloc>().add(LoadJobListPageEvent());
                break;
              case 1:
                context.read<HomePageBloc>().add(LoadSearchPageEvent());
                break;
              case 2:
                context.read<HomePageBloc>().add(LoadAddJobPageEvent());
                break;
              case 3:
                context.read<HomePageBloc>().add(LoadProfilePageEvent());
                break;
              case 4:
                context.read<AuthUserBloc>().add(LogoutEvent());
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt, size: 28),
              label: 'Jobs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 28),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 40),
              label: 'Add Job',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, size: 28),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout, size: 28),
              label: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
