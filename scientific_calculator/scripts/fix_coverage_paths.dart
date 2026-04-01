import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart fix_coverage_paths.dart <path_to_lcov_info> <project_root_prefix>');
    exit(1);
  }

  final lcovFile = File(args[0]);
  final projectPrefix = args.length > 1 ? args[1] : 'scientific_calculator/';

  if (!lcovFile.existsSync()) {
    print('Error: File ${lcovFile.path} not found.');
    exit(1);
  }

  final lines = lcovFile.readAsLinesSync();
  final fixedLines = <String>[];

  print('Fixing paths in ${lcovFile.path} with prefix: $projectPrefix');

  for (var line in lines) {
    if (line.startsWith('SF:')) {
      final originalPath = line.substring(3);
      String fixedPath;

      // Case 1: Absolute path from GitHub Workspace
      // e.g., SF:/home/runner/work/AI/AI/scientific_calculator/lib/main.dart
      if (originalPath.contains('scientific_calculator/lib/')) {
        final startIndex = originalPath.indexOf('scientific_calculator/lib/');
        fixedPath = originalPath.substring(startIndex);
      } 
      // Case 2: Already relative but missing prefix
      // e.g., SF:lib/main.dart
      else if (originalPath.startsWith('lib/')) {
        fixedPath = '$projectPrefix$originalPath';
      }
      // Case 3: Already correct or unknown
      else {
        fixedPath = originalPath;
      }

      print('  Mapping: $originalPath -> $fixedPath');
      fixedLines.add('SF:$fixedPath');
    } else {
      fixedLines.add(line);
    }
  }

  lcovFile.writeAsStringSync(fixedLines.join('\n'));
  print('Successfully updated ${fixedLines.length} lines in ${lcovFile.path}');
}
