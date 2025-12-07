class Step {
  final String description;
  final Duration? duration; 

  Step({
    required this.description,
    this.duration,
  });

  /// JSON parsing
  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      description: json['description'] as String,
      duration: json['duration'] != null
          ? Duration(minutes: json['duration'])
          : null,
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'description': description,
      'duration': duration?.inMinutes,
    };
  }

  @override
  String toString() =>
      'Step(description: "$description", duration: ${duration?.inMinutes} min)';
}
