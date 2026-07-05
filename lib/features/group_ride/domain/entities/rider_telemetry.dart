class RiderTelemetry {
  const RiderTelemetry({
    required this.riderId,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.accuracy,
    required this.batteryLevel,
    required this.status, // 'moving' | 'stationary' | 'offline'
    required this.timestamp,
  });

  factory RiderTelemetry.fromJson(Map<String, dynamic> json) {
    return RiderTelemetry(
      riderId: json['riderId'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      heading: (json['heading'] as num).toDouble(),
      accuracy: (json['accuracy'] as num).toDouble(),
      batteryLevel: (json['batteryLevel'] as num).toInt(),
      status: json['status'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
    );
  }

  final String riderId;
  final double latitude;
  final double longitude;
  final double speed;
  final double heading;
  final double accuracy;
  final int batteryLevel;
  final String status;
  final int timestamp;

  Map<String, dynamic> toJson() {
    return {
      'riderId': riderId,
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'heading': heading,
      'accuracy': accuracy,
      'batteryLevel': batteryLevel,
      'status': status,
      'timestamp': timestamp,
    };
  }

  RiderTelemetry copyWith({
    String? riderId,
    double? latitude,
    double? longitude,
    double? speed,
    double? heading,
    double? accuracy,
    int? batteryLevel,
    String? status,
    int? timestamp,
  }) {
    return RiderTelemetry(
      riderId: riderId ?? this.riderId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      accuracy: accuracy ?? this.accuracy,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
