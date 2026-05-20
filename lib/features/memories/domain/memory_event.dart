import 'package:flutter/material.dart';

import 'memory_category.dart';
import 'memory_feeling.dart';
import 'memory_type.dart';

class MemoryEvent {
  const MemoryEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.memoryType,
    required this.feeling,
    required this.occurredAt,
    required this.createdAt,
    required this.coverColor,
    required this.wallPosition,
    required this.rotation,
    required this.locationLabel,
    this.latitude,
    this.longitude,
    this.coverPhotoPath,
  });

  final String id;
  final String title;
  final String description;
  final MemoryCategory category;
  final MemoryType memoryType;
  final MemoryFeeling feeling;
  final DateTime occurredAt;
  final DateTime createdAt;
  final Color coverColor;
  final Offset wallPosition;
  final double rotation;
  final String locationLabel;
  final double? latitude;
  final double? longitude;
  final String? coverPhotoPath;

  MemoryEvent copyWith({
    String? id,
    String? title,
    String? description,
    MemoryCategory? category,
    MemoryType? memoryType,
    MemoryFeeling? feeling,
    DateTime? occurredAt,
    DateTime? createdAt,
    Color? coverColor,
    Offset? wallPosition,
    double? rotation,
    String? locationLabel,
    double? latitude,
    double? longitude,
    String? coverPhotoPath,
  }) {
    return MemoryEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      memoryType: memoryType ?? this.memoryType,
      feeling: feeling ?? this.feeling,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
      coverColor: coverColor ?? this.coverColor,
      wallPosition: wallPosition ?? this.wallPosition,
      rotation: rotation ?? this.rotation,
      locationLabel: locationLabel ?? this.locationLabel,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      coverPhotoPath: coverPhotoPath ?? this.coverPhotoPath,
    );
  }
}
