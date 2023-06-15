import "package:flutter/material.dart";

import "trains_top_bar.dart";
import "train_list.dart";

import "../api/trains_api.dart";
import "../single_train_info/single_train_page.dart";

class TrainsPage extends StatefulWidget {
  final Function() backButtonCallback;

  const TrainsPage({
    required this.backButtonCallback,
    super.key,
  });

  @override
  State<TrainsPage> createState() => _TrainsPageState();
}

class _TrainsPageState extends State<TrainsPage> {
  bool _defaultMessage = true;

  // Initialize an instance of the API.
  TrainsApi trainsApi = TrainsApi();
  List<String> trainList = [];

  void _searchTrain(String query) async {
    // Wait 500 milliseconds before sending a search request.
    // This is so we do not overload the API.
    await Future.delayed(const Duration(milliseconds: 500));

    List<String> apiList = await trainsApi.getTrainsFromApi(query);

    if (apiList.isNotEmpty) {
      // Trigger update of the station list.
      setState(() {
        _defaultMessage = false;
        trainList = apiList;
      });
    } else {
      setState(() {
        _defaultMessage = true;
      });
    }
  }

  void _toggleTrainPage(String trainId) {
    // Hide the keyboard, if active.
    FocusManager.instance.primaryFocus?.unfocus();

    // Open the page.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SingleTrainPage(
        trainID: trainId,
      )),
    );
  }

  // Needed in case the user leaves the page before the API responds.
  @override
  void setState(fx) {
    if(mounted) {
      super.setState(fx);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TrainsTopBar(
        backButtonCallback: widget.backButtonCallback,
        searchCallback: _searchTrain,
      ),

      body: _defaultMessage ? DefaultMessage() : TrainList(
        trainList: trainList,
        trainCallback: _toggleTrainPage,
      )
    );
  }
}

class DefaultMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            color: Color.fromARGB(255, 174, 174, 174),
            size: 60,
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Search for a train to begin",
              style: TextStyle(
                color: Color.fromARGB(255, 174, 174, 174),
                fontSize: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
