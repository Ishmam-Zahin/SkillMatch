import 'package:flutter/material.dart';

const List<String> skillOptions = [
  'Flutter',
  'Dart',
  'UI/UX Design',
  'Backend Development',
  'Graphic Design',
  'Content Writing',
  'SEO',
  'Video Editing',
];

class SkillChipSelector extends StatelessWidget {
  final List<String> selectedSkills;
  final ValueChanged<List<String>> onChanged;
  final String label;

  const SkillChipSelector({
    super.key,
    required this.selectedSkills,
    required this.onChanged,
    this.label = 'Select skills',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: skillOptions.map((skill) {
            return FilterChip(
              label: Text(skill),
              selected: selectedSkills.contains(skill),
              onSelected: (selected) {
                final updatedSkills = List<String>.from(selectedSkills);
                if (selected) {
                  updatedSkills.add(skill);
                } else {
                  updatedSkills.remove(skill);
                }
                onChanged(updatedSkills);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
