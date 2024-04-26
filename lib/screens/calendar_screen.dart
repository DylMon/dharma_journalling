import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'data_manager.dart';
import 'color_config.dart';
import 'package:intl/intl.dart';
import 'animated_background.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, int> moodData = {};

  @override
  void initState() {
    super.initState();
    fetchMoodData();
  }

  void fetchMoodData() async {
    Map<DateTime, int> fetchedData = await DataManager().getMoodMapForHeatmap();
    setState(() {
      moodData = fetchedData;
    });
  }

  void _handleDateClick(DateTime date) async {
    var entries = await DataManager().getMoodEntriesByDate(date);
    String formattedDate = DateFormat('EEEE, MMMM d').format(date);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Entries on $formattedDate", style: Theme.of(context).textTheme.headline6),
              ),
              Expanded(
                child: entries.isNotEmpty ? ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    MoodEntry entry = entries[index];
                    return ListTile(
                      leading: Icon(Icons.circle, color: ColorConfig.getMoodColor(entry.mood)),
                      title: Text("Mood ${entry.mood}", style: TextStyle(color: ColorConfig.getMoodColor(entry.mood))),
                      onTap: () => _showMoodDetails(entry),
                    );
                  },
                ) : Center(child: Text("No entries for this day", style: TextStyle(fontSize: 18))),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMoodDetails(MoodEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Mood Details", style: Theme.of(context).textTheme.headline6),
              SizedBox(height: 10),
              Text("Mood: ${entry.mood}", style: TextStyle(color: ColorConfig.getMoodColor(entry.mood), fontSize: 24)),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(entry.journalEntry ?? "No details provided", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(), // Dynamic animated background
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: StreamBuilder<Map<DateTime, int>>(
                  stream: DataManager().getMoodMapStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return HeatMapCalendar(
                        initDate: DateTime.now(),
                        datasets: snapshot.data!,
                        defaultColor: Color(0xFFF8F9FA),
                        colorsets: Map.fromIterable(
                          List.generate(10, (index) => index + 1),
                          key: (item) => item,
                          value: (item) => ColorConfig.getMoodColor(item),
                        ),
                        textColor: Color(0xFF8A8A8A),
                        colorMode: ColorMode.color,
                        size: MediaQuery.of(context).size.width / 9,
                        monthFontSize: 16,
                        weekFontSize: 14,
                        weekTextColor: Color(0xFF758EA1),
                        showColorTip: false,
                        colorTipCount: 7,
                        colorTipSize: 10,
                        onClick: _handleDateClick,
                      );
                    } else if (snapshot.hasError) {
                      return Text("Error loading data");
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Icon(Icons.arrow_back),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
