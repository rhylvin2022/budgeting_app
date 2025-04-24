// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:base_code/repositories/sample_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:swagger/api.dart';

part 'sample_bloc_event.dart';

part 'sample_bloc_state.dart';

class SampleBlocBloc extends Bloc<SampleBlocEvent, SampleBlocState> {
  final SampleRepository sampleRepository;

  SampleBlocBloc({required this.sampleRepository})
      : super(SampleBlocStateInitial());

  @override
  Stream<SampleBlocState> mapEventToState(SampleBlocEvent event) async* {
    if (event is GetSampleBloc) {
      yield* _onGetSampleBloc(event);
    }
  }

  Stream<SampleBlocState> _onGetSampleBloc(GetSampleBloc event) async* {
    try {
      final response = await sampleRepository.getSampleRepositoryRequest();
      yield GetSampleBlocSuccess(response);
    } catch (e) {
      yield GetSampleBlocFail(e);
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }
}
