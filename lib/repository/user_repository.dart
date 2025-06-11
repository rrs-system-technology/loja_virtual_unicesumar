import 'package:flutter/foundation.dart';

import '../repository/repository.dart';
import '../models/models.dart';

class UserRepository {
  final UserLocalRepository localRepository;
  final UserRemoteRepository remoteRepository;

  UserRepository(this.localRepository, this.remoteRepository);

  Future<UserModel?> getUserById(int id) async {
    // Primeiro tenta buscar local
    UserModel? user = await localRepository.getUserById(id);

    if (user != null) {
      if (kDebugMode) {
        print('Usuário encontrado localmente');
      }
      return user;
    }

    if (kDebugMode) {
      print('Usuário não encontrado localmente. Buscando remoto...');
    }
    user = await remoteRepository.fetchUserById(id);

    if (user != null) {
      if (kDebugMode) {
        print('Usuário encontrado remoto. Salvando localmente...');
      }
      await localRepository.saveUser(user);
    } else {
      if (kDebugMode) {
        print('Usuário não encontrado na API.');
      }
    }

    return user;
  }

  Future<void> saveUser(UserModel user) async {
    await localRepository.saveUser(user);
  }
}
