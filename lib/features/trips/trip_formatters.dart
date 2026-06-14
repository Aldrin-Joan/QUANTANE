import 'package:intl/intl.dart';
import 'package:quantane/domain/models/trip.dart';

class TripFormatters {
  static String formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('d MMM yyyy, HH:mm').format(date);
  }

  static String formatShortDuration(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return '${hours}h ${minutes}m';
    }

    if (duration.inMinutes > 0) {
      return '${duration.inMinutes} mins';
    }

    return '${duration.inSeconds} secs';
  }

  static String formatLongDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String routeLabel({
    required String? startAddress,
    required String? endAddress,
  }) {
    final start = _displayAddress(startAddress);
    final end = _displayAddress(endAddress);
    return '$start → $end';
  }

  static String _displayAddress(String? address) {
    if (address == null || address.trim().isEmpty) {
      return 'Unknown location';
    }
    return address.trim();
  }

  static String coordinateLabel(Trip trip, {required bool isStart}) {
    if (isStart && trip.routePoints.isNotEmpty) {
      final point = trip.routePoints.first;
      return '${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}';
    }
    if (!isStart && trip.routePoints.isNotEmpty) {
      final point = trip.routePoints.last;
      return '${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}';
    }
    return 'Unknown location';
  }
}
