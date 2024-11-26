part of 'maintenance_cubit.dart';

sealed class MiantenanceState extends Equatable {
  const MiantenanceState();

  @override
  List<Object> get props => [];
}

final class MiantenanceInitial extends MiantenanceState {}

final class MiantenanceLoading extends MiantenanceState {}

final class MiantenanceLoaded extends MiantenanceState {
  final List<MaintenanceRecord> maintenances;

  const MiantenanceLoaded(this.maintenances);

  @override
  List<Object> get props => [maintenances];
}

final class MiantenanceError extends MiantenanceState {
  final String message;

  const MiantenanceError(this.message);

  @override
  List<Object> get props => [message];
}
