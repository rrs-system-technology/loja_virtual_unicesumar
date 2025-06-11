import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import '../common/common.dart';

class AuthService {
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await http.post(
      Uri.parse('${Common.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return LoginResponseModel.fromJson(data);
    } else {
      throw Exception('Erro no login: ${response.statusCode}');
    }
  }
}
