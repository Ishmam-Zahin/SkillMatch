import 'package:flutter_test/flutter_test.dart';
import 'package:skillmatch/data/model/skill_matching.dart';

void main() {
  test('normalizes missing, blank, and duplicate skills', () {
    expect(normalizeSkills([' Flutter ', 'Dart', 'Flutter', '', 42]), [
      'Flutter',
      'Dart',
    ]);
    expect(normalizeSkills(null), isEmpty);
  });

  test('calculates case-insensitive skill intersections', () {
    expect(
      calculateSkillMatchScore(
        ['Flutter', 'Dart', 'Dart'],
        ['flutter', 'Backend Development'],
      ),
      1,
    );
  });

  test('returns zero for empty requirements', () {
    expect(calculateSkillMatchScore(['Flutter'], []), 0);
  });
}
