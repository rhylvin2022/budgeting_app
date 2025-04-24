part of 'sample_bloc_bloc.dart';

@immutable
abstract class SampleBlocState extends Equatable {}

class SampleBlocStateInitial extends SampleBlocState {
  @override
  List<Object?> get props => [];
}

class GetSampleBlocSuccess extends SampleBlocState {
  GetSampleBlocSuccess(this.response);
  final SampleRepositoryResponse response;

  @override
  List<Object?> get props => [response];
}

class GetSampleBlocFail extends SampleBlocState {
  GetSampleBlocFail(this.errorObject);
  final Object errorObject;

  @override
  List<Object?> get props => [errorObject];
}
