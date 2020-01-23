import 'package:ocpua_app/bloc/auth/auth_event.dart';
import 'package:ocpua_app/bloc/auth/auth_state.dart';
import 'package:ocpua_app/bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';


class AuthBloc extends BLoC<AuthEvent> {
  static AuthBloc _authBloc;
  //ResourcesAPI _resourcesAPI;

  static AuthBloc instance() {
    if (_authBloc == null) {
      _authBloc = AuthBloc._();
    }
    return _authBloc;
  }

  AuthBloc._();
  PublishSubject<AuthState> authStateSubject = PublishSubject();


  @override
  void dispatch(AuthEvent event) async {
    if(event is Login){
      print("Logged in");
    }
  }

  dispose() {
    //authStateSubject.close();
    _authBloc = null;
  }
}