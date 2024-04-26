import 'package:cloud_firestore/cloud_firestore.dart';

class MoodEntry {
  DateTime date;
  int mood;
  String journalEntry;

  MoodEntry({required this.date, required this.mood, this.journalEntry = ""});

  Map<String, dynamic> toJson() => {
    'date': Timestamp.fromDate(date),
    'mood': mood,
    'journalEntry': journalEntry,
  };

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
    date: (json['date'] as Timestamp).toDate(),
    mood: json['mood'],
    journalEntry: json['journalEntry'] ?? "",
  );
}

class DataManager {
  static final DataManager _instance = DataManager._internal();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DataManager._internal();

  factory DataManager() {
    return _instance;
  }
  Future<int> countReflections(DateTime date) async {
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    var querySnapshot = await FirebaseFirestore.instance
        .collection('moodEntries')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();

    return querySnapshot.docs.length;
  }

  Future<void> addMoodEntry(MoodEntry entry) async {
    var entryData = entry.toJson(); // Ensure this converts the DateTime to Timestamp correctly
    await firestore.collection('moodEntries').add(entryData);
  }

  Stream<List<MoodEntry>> getMoodEntriesStream() {
    return firestore.collection('moodEntries').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) =>
            MoodEntry.fromJson(doc.data() as Map<String, dynamic>)).toList());
  }

  Stream<Map<DateTime, int>> getMoodMapStream() {
    return firestore.collection('moodEntries').snapshots().map((snapshot) {
      Map<DateTime, List<int>> tempMap = {};
      for (var doc in snapshot.docs) {
        var entry = MoodEntry.fromJson(doc.data() as Map<String, dynamic>);
        DateTime dateOnly = DateTime(entry.date.year, entry.date.month, entry.date.day);  // Normalize to date only
        tempMap.putIfAbsent(dateOnly, () => []).add(entry.mood);
      }
      Map<DateTime, int> finalMap = tempMap.map((date, moods) {
        final averageMood = (moods.fold(0, (sum, item) => sum + item) / moods.length).round();
        print("Date: $date, Average Mood: $averageMood");  // Logging the computed averages
        return MapEntry(date, averageMood);
      });
      print("Final Mood Map: $finalMap");  // Log the final map
      return finalMap;
    });
  }

  Future<List<MoodEntry>> getMoodEntriesByDate(DateTime date) async {
    DateTime start = DateTime(date.year, date.month, date.day);
    DateTime end = DateTime(date.year, date.month, date.day, 23, 59, 59);
    var query = await firestore.collection('moodEntries')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();
    return query.docs.map((doc) =>
        MoodEntry.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<Map<DateTime, int>> getMoodMapForHeatmap() async {
    var entries = await firestore.collection('moodEntries').get();
    Map<DateTime, List<int>> tempMap = {};
    entries.docs.forEach((doc) {
      var entry = MoodEntry.fromJson(doc.data() as Map<String, dynamic>);
      tempMap.putIfAbsent(entry.date, () => []).add(entry.mood);
    });
    return tempMap.map((date, moods) {
      final averageMood = (moods.fold(0, (sum, item) => sum + item) / moods.length).round();
      return MapEntry(date, averageMood);
    });
  }
}
