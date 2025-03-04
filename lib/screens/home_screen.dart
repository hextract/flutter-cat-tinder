import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../widgets/dislike_button.dart';
import '../widgets/like_button.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final CardSwiperController _swiperController = CardSwiperController();
  final List<Map<String, dynamic>> _cats = [];
  int _likeCounter = 0;
  String? _errorMessage;
  bool _isLoadingMore = false;

  Future<void> _fetchCats() async {
    setState(() {
      _errorMessage = null;
      _isLoadingMore = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.thecatapi.com/v1/images/search?has_breeds=1&limit=10'),
        headers: {'x-api-key': dotenv.env['API_KEY']!},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          _cats.addAll(data.map((cat) => cat as Map<String, dynamic>).toList());
          _isLoadingMore = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load cats: ${response.statusCode}';
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoadingMore = false;
      });
    }
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (direction == CardSwiperDirection.right) {
      setState(() {
        _likeCounter++;
      });
    }
    if (_cats.length - currentIndex! <= 3 && !_isLoadingMore) {
      _fetchCats();
    }

    return true;
  }

  void _onLike() {
    _swiperController.swipe(CardSwiperDirection.right);
  }

  void _onDislike() {
    _swiperController.swipe(CardSwiperDirection.left);
  }

  @override
  void initState() {
    super.initState();
    _fetchCats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat Tinder', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: _cats.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CardSwiper(
                            controller: _swiperController,
                            cardsCount: _cats.length,
                            onSwipe: _onSwipe,
                            onUndo: (int? previousIndex, int? currentIndex,
                                    CardSwiperDirection direction) =>
                                true,
                            numberOfCardsDisplayed: 3,
                            backCardOffset: Offset(40, 40),
                            padding: EdgeInsets.zero,
                            cardBuilder: (
                              context,
                              index,
                              horizontalThresholdPercentage,
                              verticalThresholdPercentage,
                            ) {
                              final cat = _cats[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(catData: cat),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Container(
                                    color: Colors.grey[200],
                                    child: Stack(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: cat['url'],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          placeholder: (context, url) =>
                                              Container(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                        Positioned(
                                          bottom: 16,
                                          left: 16,
                                          child: Text(
                                            cat['breeds'][0]['name'],
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DislikeButton(onPressed: _onDislike),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Likes: $_likeCounter',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      LikeButton(onPressed: _onLike),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
    );
  }
}
