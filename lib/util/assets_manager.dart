import 'package:flutter/foundation.dart';

/// Root directory for all assets.
const String _root = 'assets';

/// Exposes all assets available for this app.
@immutable
class AssetsManager {
  /// root directory for all svg assets.
  final String _svgRoot = '$_root/svg';
  /// root directory for all png assets.
  final String _pngRoot = '$_root/png';
}