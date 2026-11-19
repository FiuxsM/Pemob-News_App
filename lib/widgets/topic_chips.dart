import 'package:flutter/cupertino.dart';

import '../config/news_topics.dart';
import '../utils/app_colors.dart';
import 'pressable_opacity.dart';

/// Baris pilihan kata kunci yang bisa digeser horizontal (pil ala iOS).
class TopicChips extends StatelessWidget {
  final List<NewsTopic> topics;
  final String selectedId;
  final ValueChanged<NewsTopic> onSelected;

  const TopicChips({
    super.key,
    required this.topics,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: topics.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final topic = topics[index];
          final selected = topic.id == selectedId;
          return Semantics(
            selected: selected,
            child: PressableOpacity(
              onTap: () => onSelected(topic),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.accent(context) : AppColors.fill(context),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  topic.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? CupertinoColors.white
                        : AppColors.label(context),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
