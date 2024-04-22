import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_state.freezed.dart';

@freezed
abstract class SplashState with _$SplashState {
  factory SplashState.init() = Init;

  factory SplashState.loading() = Loading;

  factory SplashState.goToLogin() = GoToLogin;

  factory SplashState.goToHome() = GoToHome;
}
