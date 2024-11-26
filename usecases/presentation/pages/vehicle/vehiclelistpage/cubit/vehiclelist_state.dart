part of 'vehiclelist_cubit.dart';

abstract class VehicleListState extends Equatable {
  const VehicleListState();

  @override
  List<Object?> get props => [];
}

class VehicleListInitial extends VehicleListState {}

class VehicleListLoading extends VehicleListState {}

class VehicleListLoaded extends VehicleListState {
  final List<VehicleModel> vehicles;

  const VehicleListLoaded({required this.vehicles});

  @override
  List<Object?> get props => vehicles;
}

class VehicleListError extends VehicleListState {
  final String message;

  const VehicleListError({required this.message});

  @override
  List<Object?> get props => [message];
}
