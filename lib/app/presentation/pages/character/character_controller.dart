import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:rickandmorty/app/domain/models/dtos/character/character_dto.dart';
import 'package:rickandmorty/app/domain/models/exceptions/exception.dart';
import 'package:rickandmorty/app/domain/models/presentation/result_presentation.dart';
import 'package:rickandmorty/app/domain/usecases/get_character/get_character_usecase.dart';

part 'character_controller.g.dart';

final $CharacterController = BindInject(
  (i) => CharacterController(i()),
  isSingleton: true,
  isLazy: true,
);

class CharacterController = _CharacterControllerBase with _$CharacterController;

abstract class _CharacterControllerBase with Store {
  final GetCharacterUsecase _characterUsecase;

  _CharacterControllerBase(this._characterUsecase);

  @observable
  bool loading = false;

  @observable
  List<CharacterDto>? listCharacters;

  @action
  Future<ResultPresentation> getCharacters({String? query}) async {
    try {
      loading = true;

      listCharacters = await _characterUsecase(query);
      loading = false;
      return ResultPresentation(payload: listCharacters);
    } on RMException catch (e) {
      loading = false;
      return ResultPresentation(error: e.error ?? '', message: e.message);
    }
  }
}
