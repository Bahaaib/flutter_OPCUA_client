
import 'package:ocpua_app/PODO/LocalError.dart';
import 'package:ocpua_app/resources/string.dart';

class AppErrors{

  static const String _TAG_UIALERT = "UIALERT";
  static const String _TAG_SERVER= "SERVER";

  static Map<int, LocalError> _errorMap = {

    /* NO INTERNET CONNECTION */
    //-4: LocalError(-4, AppStrings.error_noInternet, "No Internet", _TAG_UIALERT),
    //-6: LocalError(-6, AppStrings.maximum_size, "Image exceeds allowed size", _TAG_UIALERT),
    //500: LocalError(500,"We seem to have some technical issues and our minions are working on it", "Ouch!", _TAG_SERVER),
  };

  static get name => _errorMap[-1];
  static get invalidEmailOrPassword => _errorMap[-2];
  static get pass => _errorMap[-3];

  static get confirmEmail => _errorMap[-5];

  /* NO INTERNET CONNECTION */
  static get en4 => _errorMap[-4];
  static get en6 => _errorMap[-6];

  static get profileNotFound => _errorMap[-5];
  static get notSubmited => _errorMap[-6];

  static get en14 => _errorMap[-14];

  static get server => _errorMap[500];


}
