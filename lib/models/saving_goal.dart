class SavingGoal {
  String id;
  String name;
  double targetAmount;
  double savedAmount;
  DateTime createdAt;
  DateTime deadline;

  SavingGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.createdAt,
    required this.deadline,
  });

  double get remainingAmount {
    return (targetAmount - savedAmount)
      .clamp(0.0, double.infinity)
      .toDouble();
  }

  double get progressPercent {
    if (targetAmount <= 0) return 0;

    return ((savedAmount / targetAmount) * 100)
      .clamp(0.0, 100.0)
      .toDouble();
  }

  bool get isCompleted {
    return savedAmount >= targetAmount;
  }
}