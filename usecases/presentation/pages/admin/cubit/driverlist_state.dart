part of 'driverlist_cubit.dart';

sealed class DriverlistDartState extends Equatable {
  const DriverlistDartState();

  @override
  List<Object> get props => [];
}

final class DriverlistDartInitial extends DriverlistDartState {}

final class DriverlistDartLoading extends DriverlistDartState {}

final class DriverlistDartLoaded extends DriverlistDartState {
  final List<DriverModel> drivers;

  const DriverlistDartLoaded(this.drivers);

  @override
  List<Object> get props => drivers;
}

final class DriverlistDartError extends DriverlistDartState {
  final String message;

  const DriverlistDartError(this.message);

  @override
  List<Object> get props => [message];
}
