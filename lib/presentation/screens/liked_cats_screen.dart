import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/cat.dart';
import '../bloc/liked_cats/liked_cats_bloc.dart';
import '../bloc/liked_cats/liked_cats_event.dart';
import '../bloc/liked_cats/liked_cats_state.dart';
import 'detail_screen.dart';

class LikedCatsScreen extends StatefulWidget {
  const LikedCatsScreen({super.key});

  @override
  State<LikedCatsScreen> createState() => _LikedCatsScreenState();
}

class _LikedCatsScreenState extends State<LikedCatsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<LikedCatsBloc>().add(LoadLikedCatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Cats'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<LikedCatsBloc, LikedCatsState>(
          listener: (context, state) {
            if (state.error != null) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.error!, style: Theme.of(context).textTheme.bodyLarge),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
            _isLoading = false;
          },
          builder: (context, state) {
            if (_isLoading) {
              return const Center(child: LinearProgressIndicator());
            }
            return Column(
              children: [
                _BreedFilter(
                  selectedBreed: state.availableBreeds.contains(state.selectedBreed) ? state.selectedBreed : null,
                  availableBreeds: state.availableBreeds,
                  onChanged: (value) => context.read<LikedCatsBloc>().add(FilterLikedCatsEvent(value)),
                ),
                _CatList(cats: state.cats),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BreedFilter extends StatelessWidget {
  final String? selectedBreed;
  final List<String> availableBreeds;
  final ValueChanged<String?> onChanged;

  const _BreedFilter({
    required this.selectedBreed,
    required this.availableBreeds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField<String>(
        value: selectedBreed,
        hint: Text('Filter by breed', style: Theme.of(context).textTheme.bodyMedium),
        items: [
          DropdownMenuItem(value: null, child: Text('All', style: Theme.of(context).textTheme.bodyMedium)),
          ...availableBreeds.map((breed) => DropdownMenuItem(
            value: breed,
            child: Text(
              breed,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: selectedBreed == breed ? Theme.of(context).primaryColor : null,
              ),
            ),
          )),
        ],
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).iconTheme.color!),
          ),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class _CatList extends StatelessWidget {
  final List<Cat> cats;

  const _CatList({required this.cats});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: cats.isEmpty
          ? Center(child: Text('No liked cats yet', style: Theme.of(context).textTheme.bodyLarge))
          : ListView.builder(
        itemCount: cats.length,
        itemBuilder: (context, index) {
          if (index >= cats.length) return const SizedBox.shrink();
          final cat = cats[index];
          return Dismissible(
            key: Key(cat.id),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => context.read<LikedCatsBloc>().add(RemoveLikedCatEvent(cat.id)),
            background: Container(
              color: Theme.of(context).iconTheme.color,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, color: Theme.of(context).scaffoldBackgroundColor),
            ),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(catData: cat))),
              child: Card(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: CachedNetworkImage(
                        imageUrl: cat.url,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error, color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ),
                  title: Text(cat.breedName, style: Theme.of(context).textTheme.bodyMedium),
                  subtitle: Text('Liked: ${cat.likedAt!.toString().substring(0, 16)}', style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}