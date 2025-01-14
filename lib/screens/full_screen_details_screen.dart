import 'package:callstats/widgets/graph_indicators.dart';
import 'package:callstats/widgets/single_person_bar_chart_overview.dart';
import 'package:callstats/widgets/single_person_pie_chart.dart';
import 'package:flutter/material.dart';

class FullScreenDetailsScreen extends StatefulWidget {
  static const routeName = '/full-screen-details';

  const FullScreenDetailsScreen({
    super.key,
  });

  @override
  State<FullScreenDetailsScreen> createState() => _FullScreenDetailState();
}

class _FullScreenDetailState extends State<FullScreenDetailsScreen> {
  bool isInit = true;

  late final Map curCall;
  late final bool showNumber;
  late final Map allCalls;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      final arguments = ModalRoute.of(context)!.settings.arguments as List;
      curCall = arguments[0];
      showNumber = arguments[1];
      allCalls = arguments[2];
      isInit = false;
    }
  }

  int curPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: showNumber ? 5.0 : 15.0),
            Hero(
              key: UniqueKey(),
              tag: {"name": curCall["name"]},
              child: Text(
                curCall["name"],
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: showNumber ? 2.0 : 10.0),
            showNumber
                ? Text(
                    curCall["number"],
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[800],
                    ),
                  )
                : Container(),
          ],
        ),
        actions: [
          SizedBox(width: showNumber ? 0.0 : 50.0),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              // border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 0.0),
                SizedBox(
                  height: 280,
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    pageSnapping: true,
                    onPageChanged: (value) {
                      curPage = value;
                      setState(() {});
                    },
                    children: [
                      SinglePersonPieChart(
                        curCall: curCall,
                      ),
                      SinglePersonBarChartOverview(
                        curCall: curCall,
                        callHistoryOverview: allCalls,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 0.0),
                // Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 5.0,
                      height: 5.0,
                      decoration: BoxDecoration(
                        color:
                            curPage == 0 ? Colors.blueAccent : Colors.grey[400],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Container(
                      width: 5.0,
                      height: 5.0,
                      decoration: BoxDecoration(
                        color:
                            curPage == 1 ? Colors.blueAccent : Colors.grey[400],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                // Indicators
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GraphIndicators(color: Colors.pinkAccent, text: "Missed"),
                    GraphIndicators(
                        color: Colors.greenAccent, text: "Incoming"),
                    GraphIndicators(color: Colors.blue, text: "Outgoing"),
                  ],
                ),
                const SizedBox(height: 20.0),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GraphIndicators(color: Colors.red, text: "Rejected"),
                    GraphIndicators(color: Colors.black, text: "Blocked"),
                    GraphIndicators(color: Colors.cyanAccent, text: "Unknown"),
                  ],
                ),
                const SizedBox(height: 30.0),
                // Duration Stats
                Column(children: [
                  eachDetailDuration(
                    "Total Duration",
                    curCall["totalDuration"].toString(),
                    curCall["totalDurationMinutes"].toString(),
                    curCall["totalDurationHours"].toString(),
                    Icons.upgrade_outlined,
                  ),
                  eachDetailDuration(
                    "Maximum Duration",
                    curCall["maxDuration"].toString(),
                    curCall["maxDurationMinutes"].toString(),
                    curCall["maxDurationHours"].toString(),
                    Icons.unfold_more_sharp,
                  ),
                  eachDetailDuration(
                    "Minimum Duration",
                    curCall["minDuration"].toString(),
                    curCall["minDurationMinutes"].toString(),
                    curCall["minDurationHours"].toString(),
                    Icons.unfold_less_rounded,
                  ),
                  dateDetail(
                    "Date Range",
                    DateTime.fromMicrosecondsSinceEpoch(
                      curCall["oldestDate"] * 1000,
                    ).toString().substring(0, 10),
                    DateTime.fromMicrosecondsSinceEpoch(
                            curCall["newestDate"] * 1000)
                        .toString()
                        .substring(0, 10),
                    Icons.calendar_month_outlined,
                  ),
                ]),
                const SizedBox(height: 50.0),
                // End
                Text(
                  "End of Analysis",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Duration Triplets
  Container eachDetailDuration(String title, String firstVal, String secondVal,
      String thirdVal, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        // border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Icon(
                  icon,
                  size: 21.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          // Values
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              // border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      firstVal,
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      "sec",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${(((double.parse(secondVal) * 60) / 60).floor().toInt()).toString().padLeft(2, "0")}:${(((double.parse(secondVal) * 60) % 60).floor().toInt()).toString().padLeft(2, "0")}',
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      "min",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${(((double.parse(thirdVal) * 60) / 60).floor().toInt()).toString().padLeft(2, "0")}:${(((double.parse(thirdVal) * 60) % 60).floor().toInt()).toString().padLeft(2, "0")}',
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      "hour",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Date Detail
  Container dateDetail(
      String title, String firstVal, String secondVal, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        // border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Icon(
                  icon,
                  size: 17.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          // Values
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              // border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      firstVal,
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      "from",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      secondVal,
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      "to",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
