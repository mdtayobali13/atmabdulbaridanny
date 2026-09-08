import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;

    return Container(
      width: double.infinity,
      color: primaryGreen,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Profile Info
          _buildProfileInfo(),
          const SizedBox(height: 32),
          
          // Section 2: Important Links
          _buildImportantLinks(),
          const SizedBox(height: 32),
          
          // Section 3: Facebook Page Mock
          _buildFacebookPageMock(),
          const SizedBox(height: 32),
          
          // Copyright
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              "© 2026 Barrister Kayser Kamal. All rights reserved.",
              style: TextStyle(color: Colors.white54, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://ui-avatars.com/api/?name=Kayser+Kamal&background=random&size=100', // Replaced due to picsum.photos timeout
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Barrister Kayser Kamal",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Law Affairs Secretary, BNP\nAdvocate, Bangladesh Supreme Court\nDhaka, Bangladesh.",
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _socialIcon(Icons.facebook),
              const SizedBox(width: 12),
              _socialIcon(Icons.ondemand_video), // Youtube
              const SizedBox(width: 12),
              _socialIcon(Icons.alternate_email), // Twitter/X replacement
            ],
          ),
          const SizedBox(height: 24),
          const Text("Visitor Stats:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _statBox(Icons.person_outline, "Today Visitors", "42"),
          const SizedBox(height: 8),
          _statBox(Icons.people_outline, "Total Visitors", "2681"),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _statBox(IconData icon, String title, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white70)),
            ],
          ),
          Text(count, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildImportantLinks() {
    final links = [
      "Parliament of Bangladesh",
      "Bangladesh Supreme Court",
      "Bangladesh Police",
      "Dhaka Bar Association",
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Important Links",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...links.map((link) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_right, color: Colors.white54, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(link, style: const TextStyle(color: Colors.white70, fontSize: 14))),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildFacebookPageMock() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Facebook Page",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Cover Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: CachedNetworkImage(
                    imageUrl: 'https://placehold.co/400x150/png',
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          color: Colors.grey[200],
                        ),
                        child: CachedNetworkImage(
                          imageUrl: 'https://ui-avatars.com/api/?name=Kayser+Kamal&background=random&size=50', 
                          width: 40, 
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Barrister Kayser Kamal",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                            ),
                            Text(
                              "233,425 followers",
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.facebook, color: Colors.blue, size: 16),
                            SizedBox(width: 4),
                            Text("Follow", style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Text(
                    "Recent updates and statements from the desk of Barrister Kayser Kamal regarding national issues and legal affairs...",
                    style: TextStyle(fontSize: 12, color: Colors.black87),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          )
        ],
      ),
    );
  }
}
