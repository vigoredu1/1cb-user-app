import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ThemeType {
  light,
  dark,
}

class AppTheme {
  static ThemeType defaultTheme = ThemeType.light;

  //Theme Colors
   bool isDark;
  Color backGroundColorMain;
  Color primaryColor;
  Color btnPrimaryColor;
  Color lightText;
  Color searchBackground;
  Color backGroundColor;
  Color linkErrorColor;
  Color whiteColor;
  Color transparentColor;
  Color txtTransparentColor;
  Color txtColor;
  Color subtextColor;
  Color shadowWhiteColor;
  Color colorDivider;
  Color textColor;
  Color colorContainer;
  Color yellowColor;
  Color containerZone;
  Color colorText;
  Color iconColor;
  Color highLight;
  Color highLightRed;
  Color shadowColor;
  Color shadowColorTwo;
  Color shadowColorThree;
  Color shadowColorFour;
  Color shadowColorFive;
  Color shadowColorSix;

  /// Default constructor
  AppTheme({
    required this.isDark,
    required this.backGroundColorMain,
    required this.primaryColor,
    required this.btnPrimaryColor,
    required this.lightText,
    required this.searchBackground,
    required this.backGroundColor,
    required this.linkErrorColor,
    required this.whiteColor,
    required this.containerZone,
    required this.transparentColor,
    required this.txtTransparentColor,
    required this.highLight,
    required this.highLightRed,
    required this.yellowColor,
    required this.colorText,
    required this.colorContainer,
    required this.iconColor,
    required this.subtextColor,
    required this.shadowWhiteColor,
    required this.colorDivider,
    required this.textColor,
    required this.txtColor,
    required this.shadowColor,
    required this.shadowColorTwo,
    required this.shadowColorThree,
    required this.shadowColorFour,
    required this.shadowColorFive,
    required this.shadowColorSix,
  });

  /// fromType factory constructor
  factory AppTheme.fromType(ThemeType t) {
    switch (t) {
      case ThemeType.light:
        return AppTheme(
          isDark: false,
          backGroundColorMain: const Color(0xffFFFFFF),
          primaryColor: const Color(0xff122636),
          btnPrimaryColor: const Color(0xffFFBA00),
          lightText: const Color(0xff9BA3AA),
          searchBackground: const Color(0xffF6F6F7),
          colorContainer: const Color(0xffFFFFFF),
          backGroundColor: const Color(0xff203342),
          linkErrorColor: const Color(0xffF04949),
          colorText: const Color(0xff051E47),
          whiteColor: const Color(0xffFFFFFF),
          highLight: const Color(0xff198754),
          highLightRed: const Color(0xffFF4C3B),
          transparentColor: const Color(0xff192D3C),
          containerZone: const Color(0xffF6F6F7),
          txtTransparentColor: const Color(0xffA5ADB3),
          txtColor: const Color(0xff203342),
          shadowWhiteColor: const Color(0x000fffff),
          colorDivider: const Color(0xffEDEFF4),
          textColor: const Color(0xff010D21),
          yellowColor: const Color(0xffFFBA00),
          iconColor: const Color(0xff292D32),
          subtextColor: const Color(0xffA0A8AF),
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.07),
          //shadowColorOne: const Color.fromRGBO(18, 38, 54, 0.07),
          shadowColorTwo: const Color.fromRGBO(0, 0, 0, 0.13),
          shadowColorThree: const Color.fromRGBO(0, 0, 0, 0.04),
          shadowColorFour: const Color.fromRGBO(0, 0, 0, 0.03),
          shadowColorFive: const Color.fromRGBO(0, 0, 0, 0.10),
          shadowColorSix: const Color.fromRGBO(155, 163, 170, 0.25),
          /*     shadowColorSeven: const Color.fromRGBO(255, 255, 255, 0.15),//colorConatiner
            shadowColorEight: const Color.fromRGBO(255, 255, 255, 0.12),
            shadowColorNine: const Color.fromRGBO(18, 38, 54, 0.10),
            shadowColorTen: const Color.fromRGBO(18, 38, 54, 0.05),//primary color
            shadowColorEleven: const Color.fromRGBO(18, 38, 54, 0.09)*/
        );
      case ThemeType.dark:
        return AppTheme(
          isDark: true,
          backGroundColorMain: const Color(0xff07141F),
          primaryColor: const Color(0xff122636),
          btnPrimaryColor: const Color(0xffFFBA00),
          lightText: const Color(0xffA5ADB3),
          searchBackground: const Color(0xff122636),
          backGroundColor: const Color(0xff203342),
          linkErrorColor: const Color(0xffF04949),
          whiteColor: const Color(0xffFFFFFF),
          colorContainer: const Color(0xff1F303E),
          highLightRed: const Color(0xffFF4C3B),
          colorText: const Color(0xff051E47),
          transparentColor: const Color(0xff192D3C),
          iconColor: const Color(0xff292D32),
          containerZone: const Color(0xff091D2D),
          txtTransparentColor: const Color(0xffA5ADB3),
          txtColor: const Color(0xff203342),
          shadowWhiteColor: const Color(0x000fffff),
          colorDivider: const Color(0xffEDEFF4),
          yellowColor: const Color(0xffFFBA00),
          textColor: const Color(0xff010D21),
          highLight: const Color(0xff198754),
          subtextColor: const Color(0xffA0A8AF),
          shadowColor: const Color.fromRGBO(0, 0, 0, 0.07),
          // shadowColorOne: const Color.fromRGBO(18, 38, 54, 0.07),
          shadowColorTwo: const Color.fromRGBO(0, 0, 0, 0.13),
          shadowColorThree: const Color.fromRGBO(0, 0, 0, 0.04),
          shadowColorFour: const Color.fromRGBO(0, 0, 0, 0.03),
          shadowColorFive: const Color.fromRGBO(0, 0, 0, 0.10),
          shadowColorSix: const Color.fromRGBO(155, 163, 170, 0.25),
          /* shadowColorSeven: const Color.fromRGBO(255, 255, 255, 0.15),
            shadowColorEight: const Color.fromRGBO(255, 255, 255, 0.12),
            shadowColorNine: const Color.fromRGBO(18, 38, 54, 0.10),
            shadowColorTen: const Color.fromRGBO(18, 38, 54, 0.05),
            shadowColorEleven: const Color.fromRGBO(18, 38, 54, 0.09)*/
        );
    }
  }

  ThemeData get themeData {
    var t = ThemeData.from(
      textTheme: GoogleFonts.poppinsTextTheme(
          (isDark ? ThemeData.dark() : ThemeData.light()).textTheme),
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        secondary: btnPrimaryColor,
        surface: lightText,
        onSurface: primaryColor,
        onError: linkErrorColor,
        onPrimary: btnPrimaryColor,
        tertiary: whiteColor,
        onInverseSurface: whiteColor,
        tertiaryContainer: whiteColor,
        surfaceTint: whiteColor,
        surfaceContainerHighest: whiteColor,
        onSecondary: btnPrimaryColor,
        error: linkErrorColor,
      ),
    );
    return t.copyWith(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Colors.transparent, cursorColor: primaryColor),
      buttonTheme: ButtonThemeData(buttonColor: primaryColor),
      highlightColor: primaryColor,
    );
  }
}
