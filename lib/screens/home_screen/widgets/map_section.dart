import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/services/providers/api_providers.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapSection extends ConsumerStatefulWidget {
  const MapSection({super.key});

  @override
  ConsumerState<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends ConsumerState<MapSection> {
  int _selectedLocationIndex = 0;
  WebViewController? _webViewController;
  bool _isLoadingMap = true;
  String? _currentLoadedUrl;

  List<Map<String, String>> _parseMapLocations(String? rawMapInput, String? fallbackAddress, bool isBangla) {
    if (rawMapInput == null || rawMapInput.trim().isEmpty) {
      return [
        {
          'name': isBangla ? 'প্রধান কার্যালয়' : 'Head Office',
          'embedUrl': 'https://maps.google.com/maps?q=${Uri.encodeComponent(fallbackAddress ?? "Dhaka, Bangladesh")}&t=&z=14&ie=UTF8&iwloc=&output=embed',
          'externalUrl': 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(fallbackAddress ?? "Dhaka, Bangladesh")}',
        }
      ];
    }

    final segments = rawMapInput.split(RegExp(r'",\s*|,\s*http'));
    final List<Map<String, String>> list = [];

    for (int i = 0; i < segments.length; i++) {
      var item = segments[i].trim();
      if (!item.startsWith('http://') && !item.startsWith('https://')) {
        item = 'https://$item';
      }
      item = item.replaceAll('"', '').replaceAll("'", '').trim();

      String label = '';
      if (item.contains('Kalmakanda') || item.contains('kalmakanda')) {
        label = isBangla ? 'কলমাকান্দা কার্যালয়' : 'Kalmakanda Office';
      } else if (item.contains('Durgapur') || item.contains('durgapur')) {
        label = isBangla ? 'দুর্গাপুর কার্যালয়' : 'Durgapur Office';
      } else {
        label = isBangla ? 'অফিস ${i + 1}' : 'Office ${i + 1}';
      }

      // Format clean HTML embed or direct map
      final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<style>
  html, body { margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; background: #e8eaed; }
  iframe { border: 0; width: 100%; height: 100%; }
</style>
</head>
<body>
<iframe src="$item" allowfullscreen loading="lazy"></iframe>
</body>
</html>
''';

      // For external Google Maps app launch
      String externalUrl = item;
      if (item.contains('Kalmakanda')) {
        externalUrl = 'https://www.google.com/maps/search/?api=1&query=Kalmakanda+Upazila+Parishad+Complex';
      } else if (item.contains('Durgapur')) {
        externalUrl = 'https://www.google.com/maps/search/?api=1&query=Durgapur+Netrokona';
      } else {
        externalUrl = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(fallbackAddress ?? "Dhaka, Bangladesh")}';
      }

      list.add({
        'name': label,
        'html': htmlContent,
        'embedUrl': item,
        'externalUrl': externalUrl,
      });
    }

    if (list.isEmpty) {
      list.add({
        'name': isBangla ? 'প্রধান কার্যালয়' : 'Head Office',
        'embedUrl': 'https://maps.google.com/maps?q=${Uri.encodeComponent(fallbackAddress ?? "Dhaka, Bangladesh")}&t=&z=14&ie=UTF8&iwloc=&output=embed',
        'externalUrl': 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(fallbackAddress ?? "Dhaka, Bangladesh")}',
      });
    }

    return list;
  }

  void _initWebViewController(String htmlOrUrl) {
    if (_webViewController == null) {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFFE8EAED))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) {
              if (mounted) setState(() => _isLoadingMap = true);
            },
            onPageFinished: (_) {
              if (mounted) setState(() => _isLoadingMap = false);
            },
            onWebResourceError: (_) {
              if (mounted) setState(() => _isLoadingMap = false);
            },
          ),
        );
      if (htmlOrUrl.contains('<!DOCTYPE html>')) {
        controller.loadHtmlString(htmlOrUrl, baseUrl: "https://www.google.com");
      } else {
        controller.loadRequest(Uri.parse(htmlOrUrl));
      }
      _webViewController = controller;
      _currentLoadedUrl = htmlOrUrl;
    } else if (_currentLoadedUrl != htmlOrUrl) {
      if (htmlOrUrl.contains('<!DOCTYPE html>')) {
        _webViewController!.loadHtmlString(htmlOrUrl, baseUrl: "https://www.google.com");
      } else {
        _webViewController!.loadRequest(Uri.parse(htmlOrUrl));
      }
      _currentLoadedUrl = htmlOrUrl;
    }
  }

  Future<void> _launchExternalMap(String externalUrl, String? address) async {
    try {
      final uri = Uri.parse(externalUrl);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      try {
        final fallback = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address ?? "Dhaka, Bangladesh")}');
        await launchUrl(fallback, mode: LaunchMode.externalApplication);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final lightGreen = AppColors.instance.lightGreen;
    final primaryGreen = AppColors.instance.primaryGreen;
    final setting = ref.watch(websiteSettingProvider).asData?.value;
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);

    final address = setting?.address?.isNotEmpty == true
        ? setting!.address!
        : tr.defaultAddress;

    final locations = _parseMapLocations(setting?.googleMap, address, isBangla);

    if (_selectedLocationIndex >= locations.length) {
      _selectedLocationIndex = 0;
    }

    final activeLocation = locations[_selectedLocationIndex];
    final htmlOrUrl = activeLocation['html'] ?? activeLocation['embedUrl']!;
    _initWebViewController(htmlOrUrl);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.15), blurRadius: 6, spreadRadius: 1),
        ],
      ),
      child: Column(
        children: [
          // Header Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isBangla ? "অফিসের অবস্থান: $address" : "Office Location: $address",
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Location Selector Tabs (if multiple locations configured)
                if (locations.length > 1) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: List.generate(locations.length, (index) {
                        final isSelected = index == _selectedLocationIndex;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedLocationIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? primaryGreen : Colors.transparent,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.place,
                                    size: 16,
                                    color: isSelected ? Colors.white : Colors.grey[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      locations[index]['name']!,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.grey[800],
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],

                // Live Embedded Google Map inside the Box
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EAED),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Stack(
                      children: [
                        if (_webViewController != null)
                          WebViewWidget(controller: _webViewController!),
                        if (_isLoadingMap)
                          Container(
                            color: Colors.white70,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: primaryGreen,
                                strokeWidth: 2.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Button to Open in Full Google Maps App
                ElevatedButton.icon(
                  onPressed: () => _launchExternalMap(activeLocation['externalUrl']!, address),
                  icon: const Icon(Icons.directions, color: Colors.white, size: 18),
                  label: Text(
                    "${tr.viewOnGoogleMaps} (${activeLocation['name']})",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
