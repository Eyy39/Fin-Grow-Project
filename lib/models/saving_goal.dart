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
}