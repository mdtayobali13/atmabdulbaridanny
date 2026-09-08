import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/screens/print_media_screen/print_media_screen.dart';
import 'package:flutter_riverpod_template/screens/life_history_screen/life_history_screen.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/complaint_form.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/map_section.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/appointment_form.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/card_item.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/grid_list.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/horizontal_list.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/news_item.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/photo_gallery.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/section_title.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/video_gallery.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner Section
            CarouselSlider(
              options: CarouselOptions(
                height: 250.0,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                autoPlayInterval: const Duration(seconds: 4),
              ),
              items:
                  [
                    'https://picsum.photos/seed/b1/800/400',
                    'https://picsum.photos/seed/b2/800/400',
                    'https://picsum.photos/seed/b3/800/400',
                  ].map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 5),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),

            const SizedBox(height: 20),

            // Section: Life & Success Records
            SectionTitle(
              title: "Life & Success Records",
              onViewAllPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LifeHistoryScreen()));
              },
            ),
            const HorizontalList(
              items: [
                CardItem(
                  title: "Lawyers' Rally at Supreme Court",
                  btnText: "Read More",
                  imageUrl: 'https://picsum.photos/seed/l1/300/200',
                  sourceScreenName: "Life & Success Records",
                ),
                CardItem(
                  title: "BNP Law Affairs Secretary",
                  btnText: "Read More",
                  imageUrl: 'https://picsum.photos/seed/l2/300/200',
                  sourceScreenName: "Life & Success Records",
                ),
                CardItem(
                  title: "BNP National Executive Committee",
                  btnText: "Read More",
                  imageUrl: 'https://picsum.photos/seed/l3/300/200',
                  sourceScreenName: "Life & Success Records",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Section: For Appointment
            const AppointmentForm(),

            const SizedBox(height: 20),

            // Section: News & Activities
            SectionTitle(
              title: "News & Activities",
              onViewAllPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PrintMediaScreen()));
              },
            ),
            const GridList(
              items: [
                NewsItem(
                  title: "Oath taking of new BNP committee",
                  time: "1 hour ago",
                  imageUrl: 'https://picsum.photos/seed/n1/300/200',
                  sourceScreenName: "News & Activities",
                ),
                NewsItem(
                  title: "Discussion meeting at National Press Club",
                  time: "2 hours ago",
                  imageUrl: 'https://picsum.photos/seed/n2/300/200',
                  sourceScreenName: "News & Activities",
                ),
                NewsItem(
                  title: "Exchange of views with lawyers",
                  time: "5 hours ago",
                  imageUrl: 'https://picsum.photos/seed/n3/300/200',
                  sourceScreenName: "News & Activities",
                ),
                NewsItem(
                  title: "Exchange of views with youth",
                  time: "1 day ago",
                  imageUrl: 'https://picsum.photos/seed/n4/300/200',
                  sourceScreenName: "News & Activities",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Section: Blog
            SectionTitle(
              title: "Blog",
              onViewAllPressed: () {
                AppRoutes.instance.go("/blog_screen");
              },
            ),
            const HorizontalList(
              items: [
                CardItem(
                  title: "Our role in protecting democracy",
                  btnText: "Read More",
                  imageUrl: 'https://picsum.photos/seed/b11/300/200',
                  sourceScreenName: "Blog",
                ),
                CardItem(
                  title: "What to do to establish rule of law",
                  btnText: "Read More",
                  imageUrl: 'https://picsum.photos/seed/b22/300/200',
                  sourceScreenName: "Blog",
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Section: Photo Gallery
            SectionTitle(
              title: "Photo Gallery",
              onViewAllPressed: () {
                AppRoutes.instance.go("/photo_gallery_screen");
              },
            ),
            const PhotoGallery(),

            const SizedBox(height: 20),

            // Section: Video Gallery
            SectionTitle(
              title: "Video Gallery",
              onViewAllPressed: () {
                AppRoutes.instance.go("/video_gallery_screen");
              },
            ),
            const VideoGallery(),

            const SizedBox(height: 20),

            // Section: Complaint Form
            const ComplaintForm(),

            const SizedBox(height: 20),

            // Section: Maps
            const MapSection(),

            const SizedBox(height: 20),

            // Footer Section
            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
