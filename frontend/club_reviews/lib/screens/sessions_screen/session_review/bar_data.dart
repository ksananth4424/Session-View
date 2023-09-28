import 'package:club_reviews/constants/cloud_constants.dart';
import 'package:club_reviews/screens/sessions_screen/session_review/individual_bar.dart';

class BarData {
  final Map<String, dynamic> tags;

  late List<IndividualBar> barData;

  BarData({required this.tags});

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: tags[managementField]),
      IndividualBar(x: 1, y: tags[overallGoodField]),
      IndividualBar(x: 2, y: tags[topicLevelField]),
      IndividualBar(x: 3, y: tags[lengthField]),
      IndividualBar(x: 4, y: tags[informativeField]),
      IndividualBar(x: 5, y: tags[beginnerFriendlyField]),
    ];
  }
}
