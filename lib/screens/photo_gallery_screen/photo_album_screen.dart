import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';

class PhotoAlbumScreen extends StatelessWidget {
  final String albumTitle;
  final List<String> imageUrls;

  const PhotoAlbumScreen({
    super.key,
    required this.albumTitle,
    this.imageUrls = const [],
  });

  void _showImageDialog(BuildContext context, int initialIndex, List<String> photos) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.95),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: PageView.builder(
                  itemCount: photos.length,
                  controller: PageController(initialPage: initialIndex),
                  itemBuilder: (context, index) {
                    return InteractiveViewer(
                      child: CachedNetworkImage(
                        imageUrl: photos[index],
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator(color: Colors.white)),
                        errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.white, size: 50),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final photos = imageUrls.isNotEmpty ? imageUrls : <String>[];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryGreen,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(
          albumTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner
            Container(
              width: double.infinity,
              color: primaryGreen,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  Text(
                    albumTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "High-resolution photos from official activities and public gatherings.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            if (photos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: Text("No photos uploaded to this album yet.")),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    final photoUrl = photos[index];
                    return GestureDetector(
                      onTap: () => _showImageDialog(context, index, photos),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: photoUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
