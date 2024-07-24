import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/location.dart';

typedef Success = void Function(List<Location> locations);
typedef Failure = void Function(String error);

abstract class GetLocationsUseCaseProtocol {
  void execute({
    required String jsonPath,
    Success? success,
    Failure? failure,
    VoidCallback? onComplete,
  });
}

class GetLocationsUseCase extends GetLocationsUseCaseProtocol {
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
      final locations = Location.fromMaps(data);

      success?.call(locations);
    } on Error catch (error) {
      failure?.call(error.toString());
    } finally {
      onComplete?.call();
    }
  }
}
