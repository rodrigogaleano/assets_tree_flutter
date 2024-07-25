import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/asset.dart';

typedef Success = void Function(List<Asset> assets);
typedef Failure = void Function(String error);

abstract class GetAssetsUseCaseProtocol {
  void execute({
    required String jsonPath,
    Success? success,
    Failure? failure,
    VoidCallback? onComplete,
  });
}

class GetAssetsUseCase extends GetAssetsUseCaseProtocol {
  @override
  Future<void> execute({
    required String jsonPath,
    Success? success,
    Failure? failure,
    VoidCallback? onComplete,
  }) async {
    try {
      final response = await rootBundle.loadString(jsonPath);
      final data = json.decode(response);
      final assets = Asset.fromMaps(data);

      success?.call(assets);
    } on Error catch (error) {
      failure?.call(error.toString());
    } finally {
      onComplete?.call();
    }
  }
}
