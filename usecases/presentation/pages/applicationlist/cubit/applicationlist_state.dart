part of 'applicationlist_cubit.dart';

sealed class ApplicationlistState extends Equatable {
  const ApplicationlistState();

  @override
  List<Object> get props => [];
}

final class ApplicationlistInitial extends ApplicationlistState {}

final class ApplicationlistLoading extends ApplicationlistState {}

final class ApplicationlistLoaded extends ApplicationlistState {
  final List<List<UserApplication>> applications;

  const ApplicationlistLoaded(this.applications);

  @override
  List<Object> get props => [applications];
}

final class ApplicationlistError extends ApplicationlistState {
  final String message;

  const ApplicationlistError(this.message);

  @override
  List<Object> get props => [message];
}
