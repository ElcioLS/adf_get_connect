import 'dart:developer';

import 'package:adf_get_connect/models/user_model.dart';
import 'package:adf_get_connect/repositories/user_repository.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with StateMixin<List<UserModel>> {
  final UserRepository _repository;

  HomeController({required UserRepository repository})
      : _repository = repository;
  @override
  void onReady() {
    _findAll();
    super.onReady();
  }

  Future<void> _findAll() async {
    try {
      change([], status: RxStatus.loading());

      final users = await _repository.findAll();

      var statusReturn = RxStatus.success();
      if (users.isEmpty) {
        statusReturn = RxStatus.empty();
      }
      change(users, status: statusReturn);
    } catch (e, s) {
      log('Erro ao buscar usuários', error: e, stackTrace: s);
      change(state, status: RxStatus.error());
    }
  }

  Future<void> register() async {
    try {
      final user = UserModel(
          name: 'Yasmim', email: 'Yasmim@gmail.com', password: '1234');
      await _repository.save(user);
      _findAll();
    } catch (e, s) {
      log('Erro ao salvar usuário', error: e, stackTrace: s);
      Get.snackbar('Erro', 'Erro ao salvar usuário');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      user.name = 'Elcio Lopes da Silva';
      user.email = 'elcinho@gmail.com';
      await _repository.updateUser(user);
      _findAll();
    } catch (e, s) {
      log('Erro ao atualizar usuário', error: e, stackTrace: s);
      Get.snackbar('Erro', 'Erro ao atualizar usuário');
    }
  }

  void delete(UserModel user) async {
    try {
      user.name = '';
      user.email = '';
      await _repository.deleteUser(user);
      Get.snackbar('Sucesso!!!', 'Usuário deletado com sucesso.',
          snackPosition: SnackPosition.BOTTOM);
      _findAll();
    } catch (e, s) {
      log('Erro ao deletar usuário', error: e, stackTrace: s);
      Get.snackbar('Erro', 'Erro ao deletar usuário');
    }
  }
}
