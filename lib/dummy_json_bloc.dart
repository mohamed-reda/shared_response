import 'dart:async';

import './response_helper.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

// class GetJSONEvent {}
class Event {}

class GetJSONEvent extends Event {}

class PullToEvent extends Event {}

/// event => Bloc => state
class GetJSONBloc {
// event
  ResponseHelper _responseHelper = ResponseHelper();
  String url;

  dynamic response;

  get responseHelper => _responseHelper;
  final _streamController = StreamController<ResponseHelper>();

  StreamSink<ResponseHelper> get _inputOfStreamController =>
      _streamController.sink;

  Stream<ResponseHelper> get outputOfStreamController =>
      _streamController.stream;

  //----------------------------------
  final _eventController = StreamController<Event>();

  //  just the sink (the input) for the event
  Sink<Event> get eventSink {
    return _eventController.sink;
  }

  GetJSONBloc(this.url) {
    _eventController.stream.listen(_mapEventToState);
  }

  _mapEventToState(Event event) async {
    try {
      if (event is GetJSONEvent) {
        _responseHelper.setData(
            nErrorMessage: '', nHasError: false, nIsLoading: true);
        _inputOfStreamController.add(_responseHelper);
      }
      response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        _responseHelper.setData(
            nErrorMessage: '',
            nData: jsonResponse,
            nHasError: false,
            nIsLoading: false);
        print('You have got http request successfully.\n');
        // print('Number of books about http: ${jsonResponse.runtimeType}.');
      } else {
        _responseHelper.setData(
            nErrorMessage: 'status: ${response.statusCode}, please try again.',
            nHasError: true,
            nIsLoading: false);

        print('MoRequest failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      _responseHelper.setData(
          nErrorMessage: 'Some thing happened, please try again.',
          nHasError: true,
          nIsLoading: false);
      print('MoError: ${e.toString()}');
    }
    _inputOfStreamController.add(_responseHelper);
  }

  pull() async {
    await _mapEventToState(PullToEvent());
    return;
  }

  void dispose() {
    _streamController.close();
    _eventController.close();
  }
}
