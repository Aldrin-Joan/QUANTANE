// Dart imports:
import 'dart:math';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:quantane/features/group_ride/domain/entities/group_member.dart';
import 'package:quantane/features/group_ride/domain/entities/rider_telemetry.dart';

void main() {
  group('Group Ride Domain Models & Logic Tests', () {
    test('GroupMember serialization and copyWith', () {
      final now = DateTime.now().toUtc();
      final member = GroupMember(
        userId: 'user_123',
        displayName: 'John Doe',
        role: 'owner',
        joinedAt: now,
        isOnline: true,
        avatarUrl: 'https://example.com/avatar.png',
      );

      final json = member.toJson();
      expect(json['userId'], 'user_123');
      expect(json['displayName'], 'John Doe');
      expect(json['role'], 'owner');
      expect(json['joinedAt'], now.toIso8601String());
      expect(json['isOnline'], true);
      expect(json['avatarUrl'], 'https://example.com/avatar.png');

      final fromJson = GroupMember.fromJson(json);
      expect(fromJson.userId, member.userId);
      expect(fromJson.displayName, member.displayName);
      expect(fromJson.role, member.role);
      expect(fromJson.joinedAt, member.joinedAt);
      expect(fromJson.isOnline, member.isOnline);
      expect(fromJson.avatarUrl, member.avatarUrl);

      final copied = member.copyWith(displayName: 'Jane Doe', isOnline: false);
      expect(copied.displayName, 'Jane Doe');
      expect(copied.isOnline, false);
      expect(copied.userId, 'user_123');
    });

    test('RiderTelemetry serialization and copyWith', () {
      final nowEpoch = DateTime.now().millisecondsSinceEpoch;
      final telemetry = RiderTelemetry(
        riderId: 'rider_99',
        latitude: 12.9716,
        longitude: 77.5946,
        speed: 45.5,
        heading: 180.0,
        accuracy: 4.2,
        batteryLevel: 85,
        status: 'moving',
        timestamp: nowEpoch,
      );

      final json = telemetry.toJson();
      expect(json['riderId'], 'rider_99');
      expect(json['latitude'], 12.9716);
      expect(json['longitude'], 77.5946);
      expect(json['speed'], 45.5);
      expect(json['heading'], 180.0);
      expect(json['accuracy'], 4.2);
      expect(json['batteryLevel'], 85);
      expect(json['status'], 'moving');
      expect(json['timestamp'], nowEpoch);

      final fromJson = RiderTelemetry.fromJson(json);
      expect(fromJson.riderId, telemetry.riderId);
      expect(fromJson.latitude, telemetry.latitude);
      expect(fromJson.longitude, telemetry.longitude);
      expect(fromJson.speed, telemetry.speed);
      expect(fromJson.heading, telemetry.heading);
      expect(fromJson.accuracy, telemetry.accuracy);
      expect(fromJson.batteryLevel, telemetry.batteryLevel);
      expect(fromJson.status, telemetry.status);
      expect(fromJson.timestamp, telemetry.timestamp);
    });

    test('Haversine distance calculation logic', () {
      // Coordinates of Bangalore and Chennai
      const bangaloreLat = 12.9716;
      const bangaloreLng = 77.5946;
      const chennaiLat = 13.0827;
      const chennaiLng = 80.2707;

      // Mathematical implementation of Haversine formula
      double calculateDistance(
        double lat1,
        double lon1,
        double lat2,
        double lon2,
      ) {
        const p = 0.017453292519943295;
        final a =
            0.5 -
            cos((lat2 - lat1) * p) / 2 +
            cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
        return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
      }

      final dist = calculateDistance(
        bangaloreLat,
        bangaloreLng,
        chennaiLat,
        chennaiLng,
      );

      // Expected distance Bangalore ↔ Chennai is ~290 km
      expect(dist, closeTo(290.0, 10.0));
    });
  });
}
