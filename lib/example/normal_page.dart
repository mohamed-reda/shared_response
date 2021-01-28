import 'package:flutter/material.dart';
import 'package:shared_response/shared_response.dart';

class NormalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get some JSON'),
      ),
      body: SharedResponsePage(
        url: 'https://www.googleapis.com/books/v1/volumes?q={http}',
        functionOfSuccess: (ResponseHelper<dynamic> responseHelper) {
          /// Here You should convert the response (responseHelper.data) to your model and use that model at the UI
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text('${responseHelper.data}'),
              ),
            ],
          );
        },
        functionOfError:
            (ResponseHelper<dynamic> responseHelper, Function getDataAgain) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text('${responseHelper.errorMessage}'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  onPressed: () {
                    getDataAgain();
                  },
                  color: Colors.grey,
                  child: Text('Get the Data Again'),
                ),
              )
            ],
          );
        },
        loadingWidget: CircularProgressIndicator(),
      ),
    );
  }
}
