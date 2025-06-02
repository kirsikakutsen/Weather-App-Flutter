// weather_model.dart
class WeatherResponse {
  double? tzoffset; // Changed from int to double
  List<Days>? days;
  CurrentConditions? currentConditions;

  WeatherResponse({
    this.tzoffset,
    this.days,
    this.currentConditions,
  });

  WeatherResponse.fromJson(Map<String, dynamic> json) {
    tzoffset = (json['tzoffset'] != null) ? (json['tzoffset'] as num).toDouble() : null;
    if (json['days'] != null) {
      days = <Days>[];
      json['days'].forEach((v) {
        days!.add(Days.fromJson(v));
      });
    }
    currentConditions = json['currentConditions'] != null
        ? CurrentConditions.fromJson(json['currentConditions'])
        : null;
  }
}

class Days {
  List<Hours>? hours;

  Days({
    this.hours,
  });

  Days.fromJson(Map<String, dynamic> json) {
    if (json['hours'] != null) {
      hours = <Hours>[];
      json['hours'].forEach((v) {
        hours!.add(Hours.fromJson(v));
      });
    }
  }
}

class Hours {
  String? datetime;
  double? temp;
  List<String>? preciptype;
  String? conditions;

  Hours({
    this.datetime,
    this.temp,
    this.preciptype,
    this.conditions,
  });

  Hours.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    temp = (json['temp'] != null) ? (json['temp'] as num).toDouble() : null;

    if (json['preciptype'] != null) {
      preciptype = List<String>.from(json['preciptype']);
    } else {
      preciptype = null;
    }

    conditions = json['conditions'];
  }
}

class CurrentConditions {
  String? datetime;
  double? temp;
  String? preciptype;
  String? conditions;

  CurrentConditions({
    this.datetime,
    this.temp,
    this.preciptype,
    this.conditions,
  });

  CurrentConditions.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    temp = (json['temp'] != null) ? (json['temp'] as num).toDouble() : null;
    preciptype = json['preciptype']?.toString();
    conditions = json['conditions'];
  }
}