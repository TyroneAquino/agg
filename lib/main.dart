// This is your app. It runs as it is: press run and you get the screen below.
//
// Nothing here is precious. Change the title, change the colors, delete the
// counter, add your own screens. It exists so that the repository is a working
// Flutter app from minute one instead of an empty folder.
//
// Everything in this file is Module 4 and 5 material: StatelessWidget,
// StatefulWidget, setState, Scaffold, AppBar, Column, Card, FilledButton.

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:agg/widgets/widgets.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/enums/enums.dart';

void main() {
  runApp(
    // DevicePreview draws a phone frame around your app, so it is judged at the
    // size it was designed for instead of stretched across a laptop window.
    //
    // It is left ON in the deployed build on purpose: your live link is opened
    // on a desktop browser, and a phone layout at full desktop width looks
    // broken when it is not. The toolbar also lets a visitor switch device and
    // orientation.
    //
    // Want the clean app with no frame instead (for a portfolio, or because
    // you made the layout properly responsive)? Add
    //   import 'package:flutter/foundation.dart' show kReleaseMode;
    // and set `enabled: !kReleaseMode`, which drops the frame in release builds.
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Final Project',
      debugShowCheckedModeBanner: false,

      // These two lines are what make the DevicePreview toolbar actually
      // change the app. Keep them.
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      // Your design system starts here. One seed color generates a full
      // Material palette; swap in your own and every screen follows.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
      ),   

      home: const HomeScreen(),
    );
  }
}

/// The first screen. Replace it with yours.
///
/// It is a StatefulWidget because it remembers something that changes: the
/// counter. A screen that never changes can be a StatelessWidget instead.

class HomeScreen extends StatefulWidget{
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
    
    @override
    Widget build(BuildContext context){
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.bs),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[

                SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text('A.GG', style: AppTextTheme.mainlogo),
                      Positioned(
                        right: AppSpacing.sm,
                        top: 0,
                        child: IconButton(
                          onPressed: (){
                            showDialog(
                              context: context,
                              builder: (context) {
                                return DialogBox(title:DialogType.settings);
                              },
                            );
                          },
                          icon: Icon(appIcons['settings'], size: 40, color: AppColors.subBorder),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.xxl),
                Text('Choose a Minigame', style: AppTextTheme.bodyLarge),

                SizedBox(height:AppSpacing.xl),
                MinigameButton(minigame: MinigameType.anime),

                SizedBox(height:AppSpacing.xl),
                MinigameButton(minigame: MinigameType.character),

                SizedBox(height:AppSpacing.xl),
                MinigameButton(minigame: MinigameType.soundtrack),

              ],
            ),
          ),
        ),
      );
    }
}