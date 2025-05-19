import 'package:flutter/material.dart';

class TopicIcon extends StatelessWidget {
  final String topic;
  final Color color;
  final double size;

  const TopicIcon({
    super.key,
    required this.topic,
    required this.color,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Icon(
          _getIconForTopic(topic),
          size: size * 0.6,
          color: color,
        ),
      ),
    );
  }

  IconData _getIconForTopic(String topic) {
    final normalized = topic.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    switch (normalized) {
      case 'javascript':
        return Icons.code;
      case 'nodejs':
        return Icons.storage;
      case 'excel':
        return Icons.table_chart;
      default:
        return Icons.help_outline;
    }
  }
} 