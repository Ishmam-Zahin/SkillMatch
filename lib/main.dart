import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worklance/auth_wrapper.dart';
import 'package:worklance/bloc/blocs/user_bloc.dart';
import 'package:worklance/data/providers/add_job_provider.dart';
import 'package:worklance/data/providers/auth_user_provider.dart';
import 'package:worklance/data/providers/delete_job_provider.dart';
import 'package:worklance/data/providers/image_provider.dart';
import 'package:worklance/data/providers/job_comments_provider.dart';
import 'package:worklance/data/providers/job_detail_provider.dart';
import 'package:worklance/data/providers/job_isActive_provider.dart';
import 'package:worklance/data/providers/job_list_provider.dart';
import 'package:worklance/data/providers/job_types_provider.dart';
import 'package:worklance/data/providers/search_provider.dart';
import 'package:worklance/data/providers/send_mail_provider.dart';
import 'package:worklance/data/repository/auth_user_repository.dart';
import 'package:worklance/data/repository/home_page_repository.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://niphofrigykislfbpycu.supabase.co',
    publishableKey: 'sb_publishable_BrFC2LxoqXMx5N4n41UDdQ_Pg3WCe4O',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthUserRepository(
            authUserProvider: AuthUserProvider(),
            myImageProvider: MyImageProvider(),
          ),
        ),
        RepositoryProvider(
          create: (context) => HomePageRepository(
            myJobListProvider: MyJobListProvider(),
            myJobTypesProvider: MyJobTypesProvider(),
            myAddJobprovider: MyAddJobprovider(),
            myJobDetailProvider: MyJobDetailProvider(),
            mySendMailProvider: MySendMailProvider(),
            myJobCommentsProvider: MyJobCommentsProvider(),
            myJobIsActiveProvider: MyJobIsActiveProvider(),
            deleteJobProvider: DeleteJobProvider(),
            searchProvider: SearchProvider(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) =>
                AuthUserBloc(context.read<AuthUserRepository>()),
          ),
        ],
        child: GetMaterialApp(
          title: 'Worklance',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 6, 0, 167),
            ),
            scaffoldBackgroundColor: const Color.fromARGB(255, 238, 238, 238),
            inputDecorationTheme: const InputDecorationTheme(),
          ),
          home: const AuthWrapper(),
        ),
      ),
    );
  }
}
