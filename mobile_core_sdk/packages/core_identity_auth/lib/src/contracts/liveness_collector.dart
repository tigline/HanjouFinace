class LivenessCollectResult {
  const LivenessCollectResult({required this.photoBase64, this.errorMessage});

  final String photoBase64;
  final String? errorMessage;

  bool get isSuccess => photoBase64.trim().isNotEmpty;
}

abstract class LivenessCollector {
  Future<LivenessCollectResult> collect();
}
