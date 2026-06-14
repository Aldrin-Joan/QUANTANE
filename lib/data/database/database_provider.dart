import 'package:quantane/data/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

AppDatabase? _sharedDatabase;

AppDatabase get sharedAppDatabase {
  _sharedDatabase ??= AppDatabase();
  return _sharedDatabase as AppDatabase;
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  return sharedAppDatabase;
}
