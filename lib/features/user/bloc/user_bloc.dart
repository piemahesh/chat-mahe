import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_my_app/data/models/index.dart';
import 'package:flutter_my_app/data/repositories/user_repository.dart';

part 'user_event.dart'; // ✅ include
part 'user_state.dart'; // ✅ include

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<UserState> emit,
  ) async {
    final user = await userRepository.getCurrentUser();
    if (user != null) {
      emit(UserAuthenticated(user));
    } else {
      emit(UserUnauthenticated());
    }
  }

  Future<void> _onLoginWithGoogle(
    LoginWithGoogleEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final user = await userRepository.loginWithGoogle();
      emit(UserAuthenticated(user));
    } catch (e) {
      emit(UserAuthError(e.toString()));
    }
  }

  Future<void> _onLoginWithEmail(
    LoginWithEmailEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final user = await userRepository.loginWithEmail(
        event.email,
        event.password,
      );
      emit(UserAuthenticated(user));
    } catch (e) {
      emit(UserAuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<UserState> emit) async {
    await userRepository.logout();
    emit(UserUnauthenticated());
  }
}
