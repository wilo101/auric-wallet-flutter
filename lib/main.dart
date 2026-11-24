import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/root_gate.dart';
import 'services/auth_service.dart';
import 'services/insights_service.dart';
import 'services/wallet_repository.dart';
import 'theme/app_theme.dart';

/// Run with real Firebase:  flutter run --dart-define=USE_FIREBASE=true
/// Run with an AI proxy:    --dart-define=INSIGHTS_URL=https://your-proxy/insights
/// With neither flag the app runs fully on mock data.
const _useFirebase = bool.fromEnvironment('USE_FIREBASE');
const _insightsUrl = String.fromEnvironment('INSIGHTS_URL');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (_useFirebase) {
    await Firebase.initializeApp(); // needs google-services config (see README)
  }

  final AuthService auth = _useFirebase ? FirebaseAuthService() : MockAuthService();
  final WalletRepository repo =
      _useFirebase ? FirestoreWalletRepository() : MockWalletRepository();
  final InsightsService insights = _insightsUrl.isEmpty
      ? MockInsightsService()
      : LlmInsightsService(
          endpoint: Uri.parse(_insightsUrl), fallback: MockInsightsService());

  runApp(MultiProvider(
    providers: [
      Provider<AuthService>.value(value: auth),
      Provider<WalletRepository>.value(value: repo),
      Provider<InsightsService>.value(value: insights),
    ],
    child: const AuricApp(),
  ));
}

class AuricApp extends StatelessWidget {
  const AuricApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Auric Wallet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const RootGate(),
      );
}
