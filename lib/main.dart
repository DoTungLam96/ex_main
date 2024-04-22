import 'dart:io';

import 'package:ex_login/module/login_module.dart';
import 'package:ex_module_core/ex_module_core.dart';
import 'package:ex_module_core/generated/l10n.dart';
import 'package:ex_widget/ex_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_router.dart';
import 'screens/splash_screen/cubit/splash_cubit.dart';
import 'screens/splash_screen/splash_screen.dart';

typedef AppSetting = AppState<AppTheme, AppLanguage>;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt sl = GetIt.instance;

  final List<BaseModule> modules = <BaseModule>[LoginModule()];

  ModuleManagement().addModules(modules);

  await ModuleManagement().injectDependencies();

  sl.registerFactory(() => SplashCubit());

  final Dio dio = sl.get();

  dio.options.baseUrl = GetIt.instance.get<Network>().domain.apiUrl;

  dio.interceptors.addAll([
    CurlInterceptor(),
    LogInterceptor(requestBody: true, responseBody: true),
  ]);

  dio.interceptors.add(HandleErrorInterceptor(errorTokenExpire: () {
    print("Force logout");
  }));

  sl.registerLazySingleton(() => ToastWidget());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final localizationsDelegates = ModuleManagement().localizationsDelegates();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      GetIt.instance<ToastWidget>().registerContext();
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));
    }

    localizationsDelegates.add(ILanguage.delegate);

    _loadAppConfig();

    super.initState();
  }

  void _loadAppConfig() {
    final AppCubit cubit = GetIt.instance.get();
    final Pair setting = cubit.getDefault();

    cubit.applySetting(theme: setting.right, language: setting.left);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: GetIt.instance<AppCubit>()),
        // BlocProvider(
        //   create: (context) => SubjectBloc(),
        // ),
      ],
      child: BlocBuilder<AppCubit, AppSetting>(
        builder: (context, state) {
          Locale locale = Locale(AppLanguage.en.name, "");
          if (state.appLanguage == AppLanguage.vi) {
            locale = Locale(AppLanguage.vi.name, "");
          }
          return MaterialApp(
            title: 'Flutter Demo',
            onGenerateRoute: (settings) => onGenerateRoute(settings),
            localizationsDelegates: localizationsDelegates,
            locale: locale,
            theme: state.appTheme.data,
            supportedLocales: const [
              Locale('en', ""),
              Locale('vi', ""), // English, no country code
            ],
            home: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => GetIt.instance<SplashCubit>(),
                ),
              ],
              child: const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
