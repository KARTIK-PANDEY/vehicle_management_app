part of 'currentlocation_cubit.dart';

sealed class CurrentlocationState extends Equatable {
  const CurrentlocationState();

  @override
  List<Object> get props => [];
}

class CurrentlocationLoaded extends CurrentlocationState {
  final double latitude;
  final double longitude;

  const CurrentlocationLoaded(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}

class CurrentlocationError extends CurrentlocationState {
  final String message;

  const CurrentlocationError(this.message);

  @override
  List<Object> get props => [message];
}

final class CurrentlocationInitial extends CurrentlocationState {}
