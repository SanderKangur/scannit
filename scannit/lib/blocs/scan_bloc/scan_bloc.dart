import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc(ScanState initialState) : super(initialState);

  ScanState get initialState => InitialScanState();

  @override
  Stream<ScanState> mapEventToState(
    ScanEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
