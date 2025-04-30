import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edumi_mobile_app/models/blog_post.dart';
import 'consultation_scheduling_screen.dart';
import 'notifications_screen.dart';
import 'my_profile_screen.dart';
import 'application_status_screen.dart';
import 'blog_post_detail_screen.dart';
import 'career_advice_screen.dart'; // Import the new CareerAdviceScreen
import '../widgets/bottom_nav_bar.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentIndex = 0;
  List<BlogPost> _blogPosts = [];
  bool _isLoading = true;

  // Define the base URL based on the environment
  final bool _isDevelopment = true; // Set to false for production
  String get _baseUrl =>
      _isDevelopment
          ? 'http://10.0.2.2:80/blog_api/get_posts.php' // XAMPP (development, Android emulator)
          : 'https://edumi.pythonanywhere.com/blog_api'; // PythonAnywhere (production)

  void _onNavBarTap(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ApplicationStatusScreen(),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyProfileScreen()),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBlogPosts();
  }

  Future<void> _fetchBlogPosts() async {
    try {
      String url = '$_baseUrl/get_posts.php';
      print('Fetching blog posts from: $url');
      final response = await http.get(Uri.parse(url));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Parsed blog posts: $data'); // Log the parsed data
        if (mounted) {
          setState(() {
            _blogPosts = data.map((json) => BlogPost.fromJson(json)).toList();
            _isLoading = false;
          });
        }
      } else {
        throw Exception(
          'Failed to load blog posts: Status code ${response.statusCode}',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print('Error fetching blog posts: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load blog posts: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome!',
                  style:
                      Theme.of(context).textTheme.headlineLarge ??
                      const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Let's Find Your Perfect (Product)",
                  style:
                      Theme.of(context).textTheme.bodyLarge ??
                      const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                Text(
                  'Services',
                  style:
                      Theme.of(context).textTheme.headlineMedium ??
                      const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildServiceCard(
                      context,
                      'Consultation Scheduling',
                      'Book Now',
                      'https://images.unsplash.com/photo-1553877522-43269d4ea984?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const ConsultationSchedulingScreen(),
                        ),
                      ),
                    ),
                    _buildServiceCard(
                      context,
                      'Career Advice',
                      'Seek Advice',
                      'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CareerAdviceScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Blogposts',
                  style:
                      Theme.of(context).textTheme.headlineMedium ??
                      const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _blogPosts.isEmpty
                    ? const Center(child: Text('No blog posts found'))
                    : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.55,
                          ),
                      itemCount: _blogPosts.length,
                      itemBuilder: (context, index) {
                        final post = _blogPosts[index];
                        return _buildBlogCard(post);
                      },
                    ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    String buttonText,
    String imageUrl,
    VoidCallback onTap,
  ) {
    print('Service image URL: $imageUrl');
    return Container(
      width: MediaQuery.of(context).size.width * 0.42,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 100,
                  width: double.infinity,
                  color: const Color(0xFFE5E7EB),
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                print('Failed to load service image: $imageUrl, error: $error');
                return Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.broken_image, size: 50),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style:
                Theme.of(context).textTheme.headlineMedium ??
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          PageTransitionSwitcher(
            transitionBuilder:
                (child, primaryAnimation, secondaryAnimation) =>
                    FadeThroughTransition(
                      animation: primaryAnimation,
                      secondaryAnimation: secondaryAnimation,
                      child: child,
                    ),
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogCard(BlogPost post) {
    print('Blog post image URL: ${post.photoMain}');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child:
                post.photoMain.isNotEmpty
                    ? Image.network(
                      post.photoMain,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 100,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 100,
                          width: double.infinity,
                          color: const Color(0xFFE5E7EB),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print(
                          'Failed to load blog image: ${post.photoMain}, error: $error',
                        );
                        return Container(
                          color: const Color(0xFFE5E7EB),
                          child: const Icon(Icons.broken_image, size: 50),
                        );
                      },
                    )
                    : Container(
                      color: const Color(0xFFE5E7EB),
                      child: const Icon(Icons.image, size: 50),
                    ),
          ),
          const SizedBox(height: 8),
          Text(
            post.title,
            style:
                Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(fontSize: 16) ??
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlogPostDetailScreen(post: post),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
            child: const Text(
              'Continue reading',
              style: TextStyle(color: Color(0xFF3B82F6)),
            ),
          ),
        ],
      ),
    );
  }
}
