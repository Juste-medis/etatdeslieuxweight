// 🎯 Dart imports:
import 'dart:ui';

abstract class AcnooAppColors {
  //---------------Base Colors---------------//
  static const kBlackColor = Color(0xff000000);
  static const kWhiteColor = Color(0xffffffff);
  //---------------Base Colors---------------//

  //---------------Primary Colors---------------//
  static const kPrimary50 = Color(0xffFFF8EB);
  static const kPrimary100 = Color(0xffFEEBC7);
  static const kPrimary200 = Color(0xffFDDC9F);
  static const kPrimary300 = Color(0xffFDCD77);
  static const kPrimary400 = Color(0xffFDBE4F);
  static const kPrimary500 = Color(0xffFCAF27);
  static const kPrimary600 = Color(0xffF5A216);
  static const kPrimary700 = Color(0xffE8950D);
  static const kPrimary800 = Color(0xffDB8909);
  static const kPrimary900 = Color(0xffF48A05); // Your specified color
  //---------------Primary Colors---------------//

  //---------------Neutral Colors---------------//
  static const kNeutral50 = Color(0xffF6F6F6);
  static const kNeutral100 = Color(0xffF5F5F5);
  static const kNeutral200 = Color(0xffE5E5E5);
  static const kNeutral300 = Color(0xffD4D4D4);
  static const kNeutral400 = Color(0xffA3A3A3);
  static const kNeutral500 = Color(0xff737373);
  static const kNeutral600 = Color(0xff525252);
  static const kNeutral700 = Color(0xff404040);
  static const kNeutral800 = Color(0xff262626);
  static const kNeutral900 = Color(0xff171717);
  //---------------Neutral Colors---------------//

  //---------------Success Colors---------------//
  static const kSuccess = Color(0xff00B243);
  static final kSuccess20Op = kSuccess.withOpacity(0.20);
  //---------------Success Colors---------------//

  //---------------Info Colors---------------//
  static const kInfo = Color(0xff1D4ED8);
  static final kInfo20Op = kInfo.withOpacity(0.20);
  //---------------Info Colors---------------//

  //---------------Warning Colors---------------//
  static const kWarning = Color(0xffFD7F0B);
  static final kWarning20Op = kWarning.withOpacity(0.20);
  //---------------Warning Colors---------------//

  //---------------Error Colors---------------//
  static const kError = Color(0xffE40F0F);
  static final kError20Op = kError.withOpacity(0.20);
  //---------------Error Colors---------------//

  //---------------Dark Colors---------------//
  static const kDark1 = Color(0xff0F172A);
  static const kDark2 = Color(0xff1E293B);
  static const kDark3 = Color(0xff334155);
  //---------------Dark Colors---------------//

  //---------------Other Colors---------------//
  static const kSecondaryBtnColor = Color(0xff3577F1);
  //---------------Other Colors---------------//
}
