import 'package:flutter/material.dart';

import './shared_response.dart';

// ignore: must_be_immutable
class SharedResponsePage extends StatefulWidget {
  Function functionOfSuccess;
  Widget loadingWidget;
  Function functionOfError;
  String url;

  SharedResponsePage({
    @required this.functionOfSuccess,
    @required this.functionOfError,
    @required this.loadingWidget,
    @required this.url,
  });

  @override
  _SharedResponsePageState createState() => _SharedResponsePageState();
}

class _SharedResponsePageState extends State<SharedResponsePage> {
  GetJSONBloc _bloc;
  @override
  void initState() {
    _bloc = GetJSONBloc(widget.url);
    _bloc.eventSink.add(GetJSONEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _bloc.pull();
        // return;
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: StreamBuilder<ResponseHelper>(
            stream: _bloc.outputOfStreamController,
            initialData: _bloc.responseHelper,
            builder:
                (BuildContext context, AsyncSnapshot<ResponseHelper> snapshot) {
              if (snapshot.data.hasError) {
                return widget.functionOfError(snapshot.data, () {
                  _bloc.eventSink.add(GetJSONEvent());
                });
              } else if (snapshot.data.isLoading) {
                return widget.loadingWidget;
              } else {
                return widget.functionOfSuccess(snapshot.data);
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
