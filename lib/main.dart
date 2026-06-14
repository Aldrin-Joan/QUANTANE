import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantane/core/theme/app_theme.dart';

import 'package:quantane/core/router/app_router.dart';
import 'package:quantane/features/trips/trip_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.initCommunicationPort();
  runApp(const ProviderScope(child: QuantaneApp()));
}

class QuantaneApp extends ConsumerStatefulWidget {
  const QuantaneApp({super.key});

  @override
  ConsumerState<QuantaneApp> createState() => _QuantaneAppState();
}

class _QuantaneAppState extends ConsumerState<QuantaneApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(tripTrackingProvider.notifier).restore());
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Quantane',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
