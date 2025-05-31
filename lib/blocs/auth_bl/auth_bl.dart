import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redarko/models/user_m.dart';
import 'package:redarko/services/supabase_serv.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SupabaseService supabaseService;

  AuthBloc(this.supabaseService) : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);
    on<RegisterRequested>(_onRegister);
    on<LogoutRequested>(_onLogOut);
  }
  //loging
  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await supabaseService.login(event.email, event.password);
      final user = await supabaseService.getCurrentUserData();

      if (user == null) {
        emit(AuthFailure("Korisnik nije pronađen"));
        return;
      }
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  //register
  Future<void> _onRegister(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      //šta upisuje
      final newUser = UserModel(
        uid: '',
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        phoneNumber: event.phone,
        role: 'redar',
      );

      await supabaseService.register(newUser, event.password);

      //dodavanje korisnika iz get user data
      final user = await supabaseService.getCurrentUserData();

      if (user == null) {
        emit(AuthFailure("Registracija uspešna, ali korisnik nije pronađen."));
        return;
      }

      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  //trigeruje se kad kliknem logout dugme
  Future<void> _onLogOut(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await supabaseService.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
