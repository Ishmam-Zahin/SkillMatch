List<String> normalizeSkills(dynamic value) {
  if (value is! List) {
    return <String>[];
  }

  return value
      .whereType<String>()
      .map((skill) => skill.trim())
      .where((skill) => skill.isNotEmpty)
      .toSet()
      .toList();
}

int calculateSkillMatchScore(
  Iterable<String> userSkills,
  Iterable<String> requiredSkills,
) {
  final normalizedUserSkills = userSkills
      .map((skill) => skill.trim().toLowerCase())
      .where((skill) => skill.isNotEmpty)
      .toSet();
  final normalizedRequiredSkills = requiredSkills
      .map((skill) => skill.trim().toLowerCase())
      .where((skill) => skill.isNotEmpty)
      .toSet();

  return normalizedUserSkills.intersection(normalizedRequiredSkills).length;
}
