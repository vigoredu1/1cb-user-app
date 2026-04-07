import 'dart:convert';
import 'dart:io';

final RegExp _identifierPattern = RegExp(r'^[A-Za-z_][A-Za-z0-9_]*$');

void main() {
  final projectRoot = Directory.current;
  final themesDir = Directory.fromUri(projectRoot.uri.resolve('lib/themes/'));

  if (!themesDir.existsSync()) {
    stderr.writeln(
        'Could not find lib/themes/. Run this script from the project root.');
    exitCode = 1;
    return;
  }

  final manifests = themesDir
      .listSync()
      .whereType<Directory>()
      .map((directory) => File('${directory.path}/theme_manifest.json'))
      .where((file) => file.existsSync())
      .map(_ThemeManifest.parse)
      .toList()
    ..sort((a, b) => a.folderName.compareTo(b.folderName));

  if (manifests.isEmpty) {
    stderr.writeln(
        'No theme manifests found under lib/themes/*/theme_manifest.json.');
    exitCode = 1;
    return;
  }

  final outputFile = File(
    projectRoot.uri
        .resolve('lib/themes/generated/theme_modules.g.dart')
        .toFilePath(),
  );
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync(_buildOutput(manifests));
  stdout.writeln(
      'Generated ${outputFile.path} for ${manifests.length} theme(s).');
}

String _buildOutput(List<_ThemeManifest> manifests) {
  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln(
        '// Run `dart run tool/generate_theme_modules.dart` to regenerate.')
    ..writeln()
    ..writeln("import 'package:flutter/widgets.dart';")
    ..writeln("import 'package:get/get.dart';")
    ..writeln(
        "import 'package:one_click_builder/GlobalSplash/Model/model.dart';")
    ..writeln(
        "import 'package:one_click_builder/themes/core/theme_module.dart';");

  for (final manifest in manifests) {
    buffer.writeln("import '${manifest.mainImport}' as ${manifest.mainAlias};");
    buffer.writeln(
        "import '${manifest.vendorImport}' as ${manifest.vendorAlias};");
  }

  buffer.writeln();

  for (final manifest in manifests) {
    buffer
      ..writeln('class ${manifest.generatedClassName} extends ThemeModule {')
      ..writeln('  const ${manifest.generatedClassName}();')
      ..writeln()
      ..writeln('  @override')
      ..writeln(
          '  Set<String> get serverKeys => {${manifest.serverKeys.map(_quote).join(', ')}};')
      ..writeln()
      ..writeln('  @override')
      ..writeln(
          '  Widget build() => ${manifest.mainAlias}.${manifest.mainClass}();')
      ..writeln()
      ..writeln('  @override')
      ..writeln('  void cacheVendorData(LogoModel logoModel) {')
      ..writeln(
        '    Get.put(${manifest.vendorAlias}.${manifest.vendorController}(), permanent: true).setVendorData(',
      )
      ..writeln("      vendor: logoModel.vendorId ?? '',")
      ..writeln("      logo: logoModel.logoUrl ?? '',")
      ..writeln('      emailValue: logoModel.email,')
      ..writeln('      mobileValue: logoModel.mobile,')
      ..writeln('      addressValue: logoModel.address,')
      ..writeln('      copyRightsValue: logoModel.copyRights,')
      ..writeln('      theme: logoModel.currentTheme,')
      ..writeln('    );')
      ..writeln('  }')
      ..writeln('}')
      ..writeln();
  }

  buffer
    ..writeln('const List<ThemeModule> registeredThemeModules = [')
    ..writeln(
      manifests
          .map((manifest) => '  ${manifest.generatedClassName}(),')
          .join('\n'),
    )
    ..writeln('];');

  return buffer.toString();
}

String _quote(String value) => "'${value.replaceAll("'", "\\'")}'";

class _ThemeManifest {
  const _ThemeManifest({
    required this.folderName,
    required this.serverKeys,
    required this.mainImport,
    required this.mainClass,
    required this.vendorImport,
    required this.vendorController,
  });

  final String folderName;
  final List<String> serverKeys;
  final String mainImport;
  final String mainClass;
  final String vendorImport;
  final String vendorController;

  String get generatedClassName =>
      '${_pascalCase(folderName)}GeneratedThemeModule';

  String get mainAlias => '${_snakeCase(folderName)}_main_lib';

  String get vendorAlias => '${_snakeCase(folderName)}_vendor_lib';

  static _ThemeManifest parse(File file) {
    final json = jsonDecode(file.readAsStringSync());
    if (json is! Map<String, dynamic>) {
      throw FormatException('Manifest must be a JSON object: ${file.path}');
    }

    final folderName =
        file.parent.uri.pathSegments[file.parent.uri.pathSegments.length - 2];
    final serverKeys = _readServerKeys(json['serverKeys'], file.path);
    final mainImport = _readImport(json['mainImport'], file.path, 'mainImport');
    final mainClass =
        _readIdentifier(json['mainClass'], file.path, 'mainClass');
    final vendorImport =
        _readImport(json['vendorImport'], file.path, 'vendorImport');
    final vendorController = _readIdentifier(
      json['vendorController'],
      file.path,
      'vendorController',
    );

    return _ThemeManifest(
      folderName: folderName,
      serverKeys: serverKeys,
      mainImport: mainImport,
      mainClass: mainClass,
      vendorImport: vendorImport,
      vendorController: vendorController,
    );
  }

  static List<String> _readServerKeys(dynamic value, String path) {
    if (value is! List || value.isEmpty) {
      throw FormatException('`serverKeys` must be a non-empty array in $path');
    }

    final keys = value
        .map((item) {
          if (item is! String) {
            throw FormatException(
                '`serverKeys` must only contain strings in $path');
          }
          final normalized =
              item.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
          if (normalized.isEmpty) {
            throw FormatException(
                '`serverKeys` contains an empty key in $path');
          }
          return normalized;
        })
        .toSet()
        .toList()
      ..sort();

    return keys;
  }

  static String _readImport(dynamic value, String path, String fieldName) {
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('`$fieldName` must be a non-empty string in $path');
    }
    return value.trim();
  }

  static String _readIdentifier(dynamic value, String path, String fieldName) {
    if (value is! String || !_identifierPattern.hasMatch(value)) {
      throw FormatException(
          '`$fieldName` must be a valid Dart identifier in $path');
    }
    return value;
  }

  static String _pascalCase(String input) {
    final parts =
        input.split(RegExp(r'[^A-Za-z0-9]+')).where((part) => part.isNotEmpty);
    return parts
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join();
  }

  static String _snakeCase(String input) {
    final withBoundaries = input
        .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (match) => '${match.group(1)}_${match.group(2)}',
        )
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
        .toLowerCase();
    return withBoundaries
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }
}
