import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/api_manager.dart';
import 'package:ecommerce_app/core/network/endpoint.dart';
import 'package:ecommerce_app/features/auth/sign_in_screen/data/data_sources/SignDaoImpl/SignInDaoApiImpl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'SignInDaoApiImpl_test.mocks.dart';

@GenerateMocks([ApiManager])
void main() {
  group('Testing Sign in online data source implementation', () {
    late SignInDaoApiImpl dataSource;
    late ApiManager apiManager;

    late String email;
    late String password;

    setUp(() {
      email = "test@example.com";
      password = "Mohamed@123456";
      apiManager = MockApiManager();
      dataSource = SignInDaoApiImpl(apiManager);
    });

    test('Test success (left) if SignIn method returns SignInResponse',
        () async {
      when(
        apiManager.PostRequestRawData(Endpoint.signInEndpoint,
            body: {"email": email, "password": password}),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(),
          data: {
            "message": "success",
            "statusMsg": "ok",
            "token": "abc123",
            "user": {"name": "Test User"}
          },
        ),
      );

      final result = await dataSource.SignIn(email: email, password: password);

      expect(result.isLeft(), true);
      // expect(result.fold((response) => response, (error) => null), isA<SignInResponse>());
    });
  });
}
