import 'package:flutter/material.dart';

enum WallItemType {
  text,
  nail;

  static WallItemType fromName(String value) {
    return WallItemType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => WallItemType.text,
    );
  }
}

class WallItem {
  const WallItem({
    required this.id,
    required this.type,
    required this.content,
    required this.createdAt,
    required this.wallPosition,
    required this.color,
    this.wallId,
  });

  final String id;
  final WallItemType type;
  final String content;
  final DateTime createdAt;
  final Offset wallPosition;
  final Color color;

  /// The personal wall it hangs on; null for "My wall".
  final String? wallId;

  WallItem copyWith({
    String? id,
    WallItemType? type,
    String? content,
    DateTime? createdAt,
    Offset? wallPosition,
    Color? color,
  }) {
    return WallItem(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      wallPosition: wallPosition ?? this.wallPosition,
      color: color ?? this.color,
      wallId: wallId,
    );
  }
}
