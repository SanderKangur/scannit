import 'package:equatable/equatable.dart';

abstract class ScanState extends Equatable {
  const ScanState();
}

class InitialScanState extends ScanState {
  @override
  List<Object> get props => [];
}
