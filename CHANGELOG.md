## [7.0.0]

Bump `package:network_info_plus` to `^8.0.0`

Added manual retry functionality with exponential backoff:
- Introduced `OfflineRetryController` extending `ChangeNotifier` for retry state management
- Configurable retry limits (default: 5) and cooldown periods (default: 2s)
- Exponential backoff retry strategy (2^n seconds: 1, 2, 4, 8, 16...)
- Template method pattern with overridable `onRetry()` and `onRetryError()` methods
- Automatic retry counter reset when connection is restored
- Added `clock` package dependency for testable time operations
- Enhanced demo with retry button and real-time status indicators
- Comprehensive test coverage (32 tests, 100% coverage)

## [6.0.0]

Bump `package:connectivity_plus` to `^7.0.0`
Bump `package:network_info_plus` to `^7.0.0`

## [5.0.0]

Bump `package:connectivity_plus` to `^6.1.4`
Bump `package:network_info_plus` to `^6.1.4`

## [4.0.0]

Bump `package:connectivity_plus` to `^6.0.3`
Bump `package:network_info_plus` to `^5.0.3`

## [3.0.1]

Bump `package:connectivity_plus` to `^5.0.1`

## [3.0.0]

Bumped dependencies to support Flutter 3 with Dart 3

## [2.1.0]

- Migrate dependencies to plus packages. `package:connectivity_plus` and `package:network_info_plus`

## [2.0.0]

- Migrate to null-safety

## [1.0.0]

- Improve network and wifi detection
- Initial stable release
