import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'data_state.dart';

mixin ConvertAbleDataState {
  DataState<T> convertToDataState<T>(HttpResponse<T> _response) {
    if (_response.response.statusCode == HttpStatus.ok) {
      return DataSuccess<T>(_response.data);
    }
    return DataFailed<T>(
      DioError(
        error: _response.response.statusMessage,
        response: _response.response,
        type: DioErrorType.response,
        requestOptions: _response.response.requestOptions,
      ),
    );
  }
}
