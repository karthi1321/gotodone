import 'dart:ui';

class Task {
  int id;
  int status; // 1 for incomplete, 2 for completed
  String title;
  int createdTime;
  String label;
  int modifiedTime;
  bool hasSubtask;
  bool hasAttachment;
  bool isFav;
  int? completedTime;

  // Separate flag for priority color and priority level
  Color? priorityFlag; // Priority flag (color)
  int? priorityLevel; // Priority level (1-5)

  Task({
    required this.id,
    required this.status,
    required this.title,
    required this.createdTime,
    required this.label,
    required this.modifiedTime,
    required this.hasSubtask,
    required this.hasAttachment,
    required this.isFav,
    this.completedTime,
    this.priorityFlag,
    this.priorityLevel,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'title': title,
        'created_time': createdTime,
        'label': label,
        'modified_time': modifiedTime,
        'has_subtask': hasSubtask,
        'has_attachment': hasAttachment,
        'is_fav': isFav,
        'completed_time': completedTime,
        'priority_flag': priorityFlag?.value, // Serialize the color
        'priority_level': priorityLevel, // Serialize the level
      };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      status: json['status'],
      title: json['title'],
      createdTime: json['created_time'],
      label: json['label'],
      modifiedTime: json['modified_time'],
      hasSubtask: json['has_subtask'],
      hasAttachment: json['has_attachment'],
      isFav: json['is_fav'],
      completedTime: json['completed_time'],
      priorityFlag: json['priority_flag'] != null ? Color(json['priority_flag']) : null,
      priorityLevel: json['priority_level'],
    );
  }

  // Getter for priorityFlag
  Color? get getPriorityFlag => priorityFlag;

  // Setter for priorityFlag
  set setPriorityFlag(Color flagColor) {
    priorityFlag = flagColor;
  }
}
