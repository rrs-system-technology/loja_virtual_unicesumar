import 'package:get/get.dart';
import './../repository/repository.dart';
import './../models/models.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  var logado = false.obs;
  var carregando = false.obs;
  var erro = ''.obs;

  // Resposta do login
  final Rx<LoginResponseModel?> loginResponse = Rx<LoginResponseModel?>(null);

  // Efetuar login
  Future<void> login(LoginRequestModel request) async {
    try {
      carregando.value = true;
      erro.value = '';
      final response = await authRepository.login(request);
      loginResponse.value = response;
      if (response != null) {
        logado.value = true;
      } else {
        logado.value = false;
      }
    } catch (e) {
      erro.value = e.toString();
    } finally {
      carregando.value = false;
    }
  }
}
