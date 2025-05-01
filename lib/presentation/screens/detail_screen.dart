import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/cat.dart';

class DetailScreen extends StatefulWidget {
  final Cat catData;

  const DetailScreen({super.key, required this.catData});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: widget.catData.url,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _buildCustomPlaceholder(),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.error, size: 50, color: Colors.red),
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF64B5F6)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.catData.breedName,
                          style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 12),
                      Text(widget.catData.breedDescription,
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 20),
                      _buildInfoCard('Origin', widget.catData.origin),
                      _buildInfoCard('Temperament', widget.catData.temperament),
                      _buildInfoCard('Life Span', widget.catData.lifeSpan),
                      _buildInfoCard('Weight', '${widget.catData.weight} kg'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF64B5F6), strokeWidth: 3),
            Icon(Icons.pets, color: Color(0xFF1976D2), size: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Poppins'),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: 'Poppins'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
