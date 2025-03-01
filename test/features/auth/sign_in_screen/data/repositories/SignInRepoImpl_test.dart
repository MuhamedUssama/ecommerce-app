import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/network/InternetChecker.dart';
import 'package:ecommerce_app/features/auth/sign_in_screen/data/data_sources/SignInDao.dart';
import 'package:ecommerce_app/features/auth/sign_in_screen/data/models/SignInResponse/SignInResponse.dart';
import 'package:ecommerce_app/features/auth/sign_in_screen/data/models/SignInResponse/User.dart';
import 'package:ecommerce_app/features/auth/sign_in_screen/data/repositories/SignInRepoImpl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'SignInRepoImpl_test.mocks.dart';

@GenerateMocks([SignInDao, Connectivity])
void main() {
  group('Test Sign In repository implementation', () {
    late SignInDao signInDao;
    late SignInRepoImpl signInRepo;
    late Connectivity connectivity;
    late String email;
    late String password;

    setUp(() async {
      signInDao = MockSignInDao();
      connectivity = MockConnectivity();
      signInRepo = SignInRepoImpl(signInDao);
      email = "test@example.com";
      password = "Mohamed@123456";

      InternetChecker.connectivity = connectivity;
    });

    test(
      'Returns Left(SignInEntity) when internet is connected and API succeeds',
      () async {
        when(connectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        when(signInDao.SignIn(email: email, password: password)).thenAnswer(
          (_) async => Left(
            SignInResponse(
              message: "success",
              statusMsg: "ok",
              token: "ayhaga",
              user: User(name: "Test User"),
            ),
          ),
        );

        final result = await signInRepo.SignIn(
          email: email,
          password: password,
        );

        expect(result.isLeft(), true);
        expect(
          result.fold((entity) => entity.token, (error) => null),
          "ayhaga",
        );
      },
    );

    test(
      'Returns Right(error) when internet is connected and API fails',
      () async {
        when(connectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        when(signInDao.SignIn(email: email, password: password)).thenAnswer(
          (_) async => const Right("Invalid credentials"),
        );

        final result = await signInRepo.SignIn(
          email: email,
          password: password,
        );

        expect(result.isRight(), true);
        expect(
          result.fold((entity) => null, (error) => error),
          "Invalid credentials",
        );
      },
    );

    test(
      'Returns Right("No Internet Connection") when there is no internet',
      () async {
        when(connectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);

        final result = await signInRepo.SignIn(
          email: email,
          password: password,
        );

        expect(result.isRight(), true);
        expect(
          result.fold((entity) => null, (error) => error),
          "No Internet Connection",
        );
      },
    );
  });
}
