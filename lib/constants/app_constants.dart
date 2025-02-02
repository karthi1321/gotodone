import 'package:flutter/material.dart';
import 'package:gotodone/screens/roadmap_page.dart';

class AppConstants {
  static const String assetsPath = '/lib/assets';

  static String getAssetPath(String filePath) {
    return '$assetsPath/$filePath';
  }
}

class RoadmapItems {
  static const String all = "all";

  // Git-specific roadmap groups
  static const String  intro = "intro";
  static const String basic = "basic";
  static const String settings = "settings";

  static const String branches = "branch-management";
  static const String workflow = "git-workflow";
  static const String collaboration = "collaboration";
  static const String conflicts = "merge-conflicts";
  static const String advanced = "advanced";
  static const String viewing_logs = "viewing-logs";
  static const String tagging = "tagging";
  static const String hooks = "hooks";
  static const String remote = "remote-management";
  static const String undo_changes = "undo-changes";

  static final List<RoadmapItem> gitBasics = [
    RoadmapItem(
      title: 'Introduction to Git',
      group: RoadmapItems.intro,
      subtitle: 'Understand version control and Git basics',
      icon: Icons.info,
      color: const Color.fromARGB(255, 238, 165, 57),
    ),
    RoadmapItem(
      title: 'Setting Up Git',
      group: RoadmapItems.settings,
      subtitle: 'Install Git, configure user and email',
      icon: Icons.settings,
      color: Colors.green,
    ),
    RoadmapItem(
      title: 'Basic Git Commands',
      group: RoadmapItems.basic,
      subtitle: 'Initialize repository, stage changes, commit',
      icon: Icons.terminal,
      color: Colors.blue,
    ),
    RoadmapItem(
      title: 'Working with Branches',
      group: RoadmapItems.branches,
      subtitle: 'Create, switch, merge, and delete branches',
      icon: Icons.fork_right,
      color: Colors.purple,
    ),
    // RoadmapItem(
    //   title: 'Understanding Git Workflow',
    //   group: RoadmapItems.workflow,
    //   subtitle: 'Staging area, working directory, and commit history',
    //   icon: Icons.work,
    //   color: Colors.teal,
    // ),
    RoadmapItem(
      title: 'Collaborating with Git',
      group: RoadmapItems.collaboration,
      subtitle: 'Understand pull, push, and fetch',
      icon: Icons.group,
      color: Colors.cyan,
    ),
    RoadmapItem(
      title: 'Resolving Merge Conflicts',
      group: RoadmapItems.conflicts,
      subtitle: 'Identify and resolve merge conflicts',
      icon: Icons.error_outline,
      color: Colors.indigo,
    ),
    // RoadmapItem(
    //   title: 'Rebasing vs Merging',
    //   group: RoadmapItems.advanced,
    //   subtitle: 'Understand the difference between rebase and merge',
    //   icon: Icons.compare_arrows,
    //   color: Colors.red,
    // ),
    // RoadmapItem(
    //   title: 'Git Stash',
    //   group: RoadmapItems.advanced,
    //   subtitle: 'Save and apply unfinished work with stash',
    //   icon: Icons.save,
    //   color: Colors.brown,
    // ),
    RoadmapItem(
      title: 'Viewing Commit History',
      group: RoadmapItems.viewing_logs,
      subtitle: 'Explore commit logs and histories',
      icon: Icons.history,
      color: Colors.deepOrange,
    ),
    RoadmapItem(
      title: 'Tagging in Git',
      group: RoadmapItems.tagging,
      subtitle: 'Create and manage tags for versions',
      icon: Icons.label,
      color: Colors.amber,
    ),
    // RoadmapItem(
    //   title: 'Git Hooks',
    //   group: RoadmapItems.hooks,
    //   subtitle: 'Automate actions with pre-commit and other hooks',
    //   icon: Icons.auto_fix_high,
    //   color: Colors.lime,
    // ),
    RoadmapItem(
      title: 'Working with Remote Repositories',
      group: RoadmapItems.remote,
      subtitle: 'Clone, pull, push, and track remote repositories',
      icon: Icons.cloud_sync,
      color: Colors.lightBlue,
    ),
    RoadmapItem(
      title: 'Undoing Changes',
      group: RoadmapItems.undo_changes,
      subtitle: 'Reset, revert, and checkout changes',
      icon: Icons.undo,
      color: Colors.deepPurple,
    ),
  ];
}
