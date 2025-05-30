// lib/features/user/bloc/user_event.dart
part of 'user_bloc.dart'; // ✅ must be first, and ONLY

abstract class UserEvent extends Equatable {
  const UserEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends UserEvent {}

class LoginWithGoogleEvent extends UserEvent {}

class LoginWithEmailEvent extends UserEvent {
  final String email;
  final String password;
  const LoginWithEmailEvent(this.email, this.password);
}

class LogoutEvent extends UserEvent {}
