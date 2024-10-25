class Ceramah {
  final int id;
  final String title;
  final String date;
  final String time;
  final String speaker;



  Ceramah({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.speaker,
  
  
  });

  factory Ceramah.fromJson(Map<String, dynamic> json) {
    return Ceramah(
      id: int.parse(json['id']),
      title: json['title'],
      date: json['date'],
      time: json['time'],
      speaker: json['speaker'],
  
   
    );
  }
}
