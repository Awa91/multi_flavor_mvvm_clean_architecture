//Asset Swapping Script

import 'dart:io';

/// This script moves brand-specific assets into the active folder.
/// Run it using: dart scripts/prepare_assets.dart alpha
void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('❌ Error: Please provide a brand name (alpha or beta).');
    print('Usage: dart scripts/prepare_assets.dart <brand>');
    exit(1);
  }

  final String brand = arguments[0].toLowerCase();
  if (brand != 'alpha' && brand != 'beta') {
    print('❌ Error: "$brand" is not a recognized brand.');
    exit(1);
  }

  print('🚀 Preparing assets for brand: $brand');

  final Directory targetDir = Directory('assets/current_brand');
  final Directory sourceDir = Directory('assets/branding/$brand');

  // 1. Clean or create the target directory
  if (await targetDir.exists()) {
    await targetDir.delete(recursive: true);
  }
  await targetDir.create(recursive: true);

  // 2. Copy brand specific assets
  if (await sourceDir.exists()) {
    await for (final entity in sourceDir.list(recursive: true)) {
      if (entity is File) {
        final String relativePath =
            entity.path.replaceFirst(sourceDir.path, '');
        final String newPath = '${targetDir.path}$relativePath';

        final File newFile = File(newPath);

        // Ensure subdirectories exist within the target
        await newFile.parent.create(recursive: true);

        await entity.copy(newPath);
      }
    }
    print('✅ Assets for "$brand" synced to ${targetDir.path}');
  } else {
    print('❌ Error: Source directory ${sourceDir.path} not found!');
    exit(1);
  }
}
