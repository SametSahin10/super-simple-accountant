import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:super_simple_accountant/colors.dart';
import 'package:super_simple_accountant/currency_formatter.dart';
import 'package:super_simple_accountant/firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:super_simple_accountant/repositories/auth/auth_repository.dart';
import 'package:super_simple_accountant/revenue_cat_config.dart';
import 'package:super_simple_accountant/screens/main_screen.dart';
import 'package:super_simple_accountant/state/providers.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'environment/.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  if (kDebugMode) {
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  }

  final userId = await AuthRepository().signInAnonymously();
  await configureRevenueCat(userId: userId);

  if (!kIsWeb) MobileAds.instance.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Simple Accountant',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primaryColor: primaryColor,
        useMaterial3: true,
        fontFamily: GoogleFonts.josefinSans().fontFamily,
        appBarTheme: const AppBarTheme(centerTitle: true),
        buttonTheme: const ButtonThemeData(
          buttonColor: primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
        ),
      ),
      debugShowCheckedModeBanner: true,
      home: const MainScreen(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      builder: (context, child) => _Builder(child: child!),
    );
  }
}

class _Builder extends StatefulWidget {
  final Widget child;

  const _Builder({required this.child});

  @override
  State<_Builder> createState() => _BuilderState();
}

class _BuilderState extends State<_Builder> {
  CurrencyFormatter? currencyFormatter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);

    final numberFormat = NumberFormat.simpleCurrency(locale: locale.toString());

    currencyFormatter = CurrencyFormatter(
      locale: locale,
      currencyFormatter: numberFormat,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        currencyFormatterProvider.overrideWithValue(currencyFormatter),
      ],
      child: widget.child,
    );
  }
}
