import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quantane/firebase_options.dart';
import 'package:quantane/core/theme/app_theme.dart';

import 'package:quantane/core/router/app_router.dart';
import 'package:quantane/features/trips/trip_providers.dart';
import 'package:quantane/features/trips/widgets/route_snapshot_host.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      builder: (context, child) {
        return Stack(
          children: [
            ?child,
            Positioned(
              left: -1200,
              top: 0,
              child: RouteSnapshotHost(key: routeSnapshotHostKey),
            ),
          ],
        );
      },
    );
  }
}
