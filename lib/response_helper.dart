import 'dart:async';

import 'package:flutter/services.dart';

class ResponseHelper<T> {
  // static final _singleton = n ResponseHelper._internal();
  T data;
  bool hasError;
  String errorMessage;
  bool isLoading;

  ResponseHelper({
    this.data,
    this.errorMessage = 'There is No Data yet',
    this.hasError = true,
    this.isLoading = true,
  });

  // ResponseHelper._internal();

  ResponseHelper copyWith(
      {bool hasError, bool isLoading, String errorMessage, T data}) {
    return ResponseHelper(
//      if the field is null then use the old one
      hasError: hasError ?? this.hasError,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }

  void setData(
      {T nData, bool nHasError, String nErrorMessage, bool nIsLoading}) {
    data = nData;
    hasError = nHasError;
    errorMessage = nErrorMessage;
    isLoading = nIsLoading;
  }
}
