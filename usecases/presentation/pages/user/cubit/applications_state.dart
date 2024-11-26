part of 'applications_cubit.dart';

sealed class ApplicationsState extends Equatable {
  const ApplicationsState();

  @override
  List<Object> get props => [];
}

final class ApplicationsInitial extends ApplicationsState {}

final class ApplicationsLoading extends ApplicationsState {}

final class ApplicationsLoaded extends ApplicationsState {
  final List<UserApplication> applications;

  const ApplicationsLoaded(this.applications);

  @override
  List<Object> get props => [applications];
}

final class ApplicationsError extends ApplicationsState {
  final String message;

  const ApplicationsError(this.message);

  @override
  List<Object> get props => [message];
}
