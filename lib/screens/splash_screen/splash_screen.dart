import 'package:ex_module_core/ex_module_core.dart';
import 'package:ex_module_core/gen/assets.gen.dart';
import 'package:ex_widget/ex_widget.dart';
import 'package:flutter/material.dart';

import '../intro/intro_screen.dart';
import 'cubit/splash_cubit.dart';
import 'cubit/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  void _initData() {
    context.read<SplashCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GetIt.instance<ToastWidget>().globalKey,
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            goToLogin: () => _goToLoginScreen(context),
          );
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: SizedBox(
            width: 210,
            height: 80,
            child: Image.asset(
              Assets.images.flutter.path,
            ),
          ),
        ),
        Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                color: ThemeUtils.color.neutralPurple,
              ),
            ))
      ],
    );
  }

  void _goToLoginScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const IntroScreen(), fullscreenDialog: false),
    );
  }
}
