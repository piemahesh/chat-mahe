// lib/features/user/bloc/user_state.dart
part of 'user_bloc.dart'; // ✅ must be first, and ONLY

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserAuthenticated extends UserState {
  final AppUser user;
  const UserAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class UserUnauthenticated extends UserState {}

class UserAuthError extends UserState {
  final String message;
  const UserAuthError(this.message);
  @override
  List<Object?> get props => [message];
}
