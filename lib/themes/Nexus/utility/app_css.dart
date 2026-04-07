import 'dart:ui';

import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

FontWeight thin = FontWeight.w100;
FontWeight extraLight = FontWeight.w200;
FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.normal;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;
FontWeight extraThickBold = FontWeight.bold;

//dmPoppins font
 TextStyle dmPoppins({double? fontsize, fontWeight}) =>
     GoogleFonts.poppins(fontSize: fontsize, fontWeight: fontWeight);

 TextStyle dmArsenal({double? fontsize, fontWeight}) =>
    GoogleFonts.arsenal(fontSize: fontsize, fontWeight: fontWeight);


class AppCss {

//Text Style dmArsenal
  TextStyle dmArsenalSemiBold22= dmPoppins(fontWeight: semiBold,fontsize:22);

//Text Style dmPoppins extra bold
  TextStyle dmPoppinsExtraBold70 = dmPoppins( fontWeight: extraBold,fontsize:70);
  TextStyle dmPoppinsExtraBold65 = dmPoppins( fontWeight:extraBold ,fontsize:65);
  TextStyle dmPoppinsExtraBold60 = dmPoppins( fontWeight: extraBold,fontsize:60);
  TextStyle dmPoppinsExtraBold40 = dmPoppins( fontWeight: extraBold,fontsize:40);
  TextStyle dmPoppinsExtraBold20 = dmPoppins( fontWeight: extraBold,fontsize:20);
  TextStyle dmPoppinsExtraBold25 = dmPoppins( fontWeight:extraBold ,fontsize:25);
  TextStyle dmPoppinsExtraBold30 = dmPoppins( fontWeight: extraBold,fontsize:30);


  //Text Style dmPoppins bold
  TextStyle dmPoppinsExtraBold22 = dmPoppins(fontWeight: extraBold,fontsize:22);
  TextStyle dmPoppinsExtraBold18 = dmPoppins(fontWeight: extraBold,fontsize:18);
  TextStyle dmPoppinsExtraBold16 = dmPoppins(fontWeight: extraBold,fontsize:16);
  TextStyle dmPoppinsExtraBold14 = dmPoppins(fontWeight: extraBold,fontsize:14);
  TextStyle dmPoppinsExtraBold12 = dmPoppins(fontWeight: extraBold,fontsize:12);

  //Text Style semi dmPoppins bold
  TextStyle dmPoppinsBold50 = dmPoppins(fontWeight: bold,fontsize:50);
  TextStyle dmPoppinsBold38 = dmPoppins(fontWeight: bold,fontsize:38);
  TextStyle dmPoppinsBold35 = dmPoppins(fontWeight: bold,fontsize:35);
  TextStyle dmPoppinsBold24 = dmPoppins(fontWeight: bold,fontsize:24);
  TextStyle dmPoppinsBold20 = dmPoppins(fontWeight: bold,fontsize:20);
  TextStyle dmPoppinsBold18 = dmPoppins(fontWeight: bold,fontsize:18);
  TextStyle dmPoppinsBold16 = dmPoppins(fontWeight: bold,fontsize:16);
  TextStyle dmPoppinsBold15 = dmPoppins(fontWeight: bold,fontsize:15);
  TextStyle dmPoppinsBold17 = dmPoppins(fontWeight: bold,fontsize:17);
  TextStyle dmPoppinsBold14 = dmPoppins(fontWeight: bold,fontsize:14);
  TextStyle dmPoppinsBold13 = dmPoppins(fontWeight: bold,fontsize:13);
  TextStyle dmPoppinsBold12 = dmPoppins(fontWeight: bold,fontsize:12);
  TextStyle dmPoppinsBold10 = dmPoppins(fontWeight: bold,fontsize:10);

  TextStyle dmPoppinsSemiBold26= dmPoppins(fontWeight: semiBold,fontsize:26);
  TextStyle dmPoppinsSemiBold24= dmPoppins(fontWeight: semiBold,fontsize:24);
  TextStyle dmPoppinsSemiBold23= dmPoppins(fontWeight: semiBold,fontsize:23);
  TextStyle dmPoppinsSemiBold22= dmPoppins(fontWeight: semiBold,fontsize:22);
  TextStyle dmPoppinsSemiBold20= dmPoppins(fontWeight: semiBold,fontsize:20);
  TextStyle dmPoppinsSemiBold18= dmPoppins(fontWeight: semiBold,fontsize:18);
  TextStyle dmPoppinsSemiBold16= dmPoppins(fontWeight: semiBold,fontsize:16);
  TextStyle dmPoppinsSemiBold15= dmPoppins(fontWeight: semiBold,fontsize:15);
  TextStyle dmPoppinsSemiBold13= dmPoppins(fontWeight: semiBold,fontsize:13);
  TextStyle dmPoppinsSemiBold14= dmPoppins(fontWeight: semiBold,fontsize:14);
  TextStyle dmPoppinsSemiBold12= dmPoppins(fontWeight: semiBold,fontsize:12);
  TextStyle dmPoppinsSemiBold10= dmPoppins(fontWeight: semiBold,fontsize:10);
  TextStyle dmPoppinsSemiBold9= dmPoppins(fontWeight: semiBold,fontsize:9);


  //Text Style dmPoppins medium
  TextStyle dmPoppinsMedium28 = dmPoppins(fontWeight: medium,fontsize:28);
  TextStyle dmPoppinsMedium22 = dmPoppins(fontWeight: medium,fontsize:22);
  TextStyle dmPoppinsMedium20 = dmPoppins(fontWeight: medium,fontsize:20);
  TextStyle dmPoppinsMedium18 = dmPoppins(fontWeight: medium,fontsize:18);
  TextStyle dmPoppinsMedium16 = dmPoppins(fontWeight: medium,fontsize:16);
  TextStyle dmPoppinsMedium15 = dmPoppins(fontWeight: medium,fontsize:15);
  TextStyle dmPoppinsMedium14 = dmPoppins(fontWeight: medium,fontsize:14);
  TextStyle dmPoppinsMedium13 = dmPoppins(fontWeight: medium,fontsize:13);
  TextStyle dmPoppinsMedium12 = dmPoppins(fontWeight: medium,fontsize:12);
  TextStyle dmPoppinsMedium11 = dmPoppins(fontWeight: medium,fontsize:11);
  TextStyle dmPoppinsMedium10 = dmPoppins(fontWeight: medium,fontsize:10);
  TextStyle dmPoppinsMedium8 = dmPoppins(fontWeight: medium,fontsize:8);
  TextStyle dmPoppinsMedium6 = dmPoppins(fontWeight: medium,fontsize:6);

  //Text Style dmPoppins regular

  TextStyle dmPoppinsRegular18 = dmPoppins(fontWeight: regular,fontsize:18);
  TextStyle dmPoppinsRegular16 = dmPoppins(fontWeight: regular,fontsize:16);
  TextStyle dmPoppinsRegular14 = dmPoppins(fontWeight: regular,fontsize:14);
  TextStyle dmPoppinsRegular13 = dmPoppins(fontWeight: regular,fontsize:13);
  TextStyle dmPoppinsRegular12 = dmPoppins(fontWeight: regular,fontsize:12);
  TextStyle dmPoppinsRegular11 = dmPoppins(fontWeight: regular,fontsize:11);
  TextStyle dmPoppinsRegular10 = dmPoppins(fontWeight: regular,fontsize:10);


  TextStyle dmPoppinsLight16 = dmPoppins(fontWeight: light,fontsize:16);
  TextStyle dmPoppinsLight14 = dmPoppins(fontWeight: light,fontsize:14);
  TextStyle dmPoppinsLight12 = dmPoppins(fontWeight: light,fontsize:12);

}
