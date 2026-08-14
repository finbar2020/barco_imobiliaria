import 'package:flutter/material.dart';
import 'package:lib_facedetection/lib_facedetection.dart';

import 'package:essentials/essentials.dart' hide Image;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face Detection Example',
      theme: LelloTheme.light,
      themeMode: ThemeMode.light,
      home: const MyHomePage(title: 'Face Detection'),
      localizationsDelegates: const [
        AppLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'BR'),
        Locale('en', 'US'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        //final result = supportedLocales.first;
        final result = supportedLocales.firstWhere(
            (element) =>
                (element.countryCode == locale!.countryCode &&
                    element.languageCode == locale.languageCode) ||
                (locale.countryCode == null &&
                    element.languageCode == locale.languageCode),
            orElse: () => supportedLocales.first);

        Intl.defaultLocale = '${result.languageCode}_${result.countryCode}';
        return result;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void goToCameraView() async {
    var cameras = await availableCameras();
    final CameraViewPickerResult result = await handleUseCase(
      GetImageFromCameraViewPickerUsecase(),
      ParamsGetImageFromCameraViewPickerUsecase(
        context: context,
        cameras: cameras,
        captureEnum: TypeCaptureEnum.lifeValidation,
        isRandomActionsLifeValidation: true,
        qteActionsLifeValidation: 1,
        isDebug: true,
      ),
    );
    // ignore: use_build_context_synchronously
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageResultPage(
          photo: result.file,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text(
          'Clique para ir para Face Detection',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToCameraView,
        tooltip: 'Face Detection',
        child: const Icon(Icons.add_a_photo),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ImageResultPage extends StatelessWidget {
  final XFile? photo;
  const ImageResultPage({
    super.key,
    this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          photo != null
              ? FutureBuilder<Uint8List>(
                  future: photo!.readAsBytes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.memory(
                        snapshot.data!,
                        fit: BoxFit.contain,
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                )
              : const SizedBox(),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              iconSize: 40,
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
