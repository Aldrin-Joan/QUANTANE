// Dart imports:
import 'dart:convert';
import 'dart:io';

// Package imports:
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:quantane/features/trips/trip_session_models.dart';

class ActiveTripSessionRepository {
  ActiveTripSessionRepository({Future<Directory> Function()? directoryResolver})
    : _directoryResolver = directoryResolver;
  static const String _fileName = 'active_trip_session.json';
  final Future<Directory> Function()? _directoryResolver;

  Future<File> _sessionFile() async {
    final directory = _directoryResolver == null
        ? await getApplicationDocumentsDirectory()
        : await _directoryResolver();
    return File('${directory.path}${Platform.pathSeparator}$_fileName');
  }

  Future<TripState?> load() async {
    final file = await _sessionFile();
    if (!await file.exists()) {
      return null;
    }

    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return null;
    }

    return TripState.fromJson(
      jsonDecode(content).cast<String, Object?>() as Map<String, Object?>,
    );
  }

  Future<void> save(TripState session) async {
    final file = await _sessionFile();
    await file.writeAsString(jsonEncode(session.toJson()), flush: true);
  }

  Future<void> clear() async {
    final file = await _sessionFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<bool> hasActiveSession() async {
    final file = await _sessionFile();
    return file.exists();
  }
}
