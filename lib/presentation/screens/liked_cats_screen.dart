import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/liked_cats/liked_cats_bloc.dart';
import '../bloc/liked_cats/liked_cats_event.dart';
import '../bloc/liked_cats/liked_cats_state.dart';
import 'detail_screen.dart';

class LikedCatsScreen extends StatelessWidget {
  const LikedCatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<LikedCatsBloc>().add(LoadLikedCatsEvent());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Cats'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF64B5F6)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Text('Error', style: TextStyle(color: Color(0xFF1976D2))),
                  content: Text(state.error!, style: Theme.of(context).textTheme.bodyLarge),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK', style: TextStyle(color: Color(0xFF64B5F6))),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<String>(
                    value: state.selectedBreed,
                    hint: const Text('Filter by breed'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All')),
                      ...state.availableBreeds.map((breed) => DropdownMenuItem(
                        value: breed,
                        child: Text(
                          breed,
                          style: TextStyle(
                            color: state.selectedBreed == breed
                                ? const Color(0xFF64B5F6)
                                : null,
                          ),
                        ),
                      )),
                    ],
                    onChanged: (value) =>
                        context.read<LikedCatsBloc>().add(FilterLikedCatsEvent(value)),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF1976D2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF64B5F6)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Expanded(
                  child: state.cats.isEmpty &&
                      state.availableBreeds.isEmpty &&
                      state.error == null
                      ? const Center(
                    child: LinearProgressIndicator(color: Color(0xFF64B5F6)),
                  )
                      : state.cats.isEmpty
                      ? Center(
                    child: Text(
                      'No liked cats yet',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                      : ListView.builder(
                    itemCount: state.cats.length,
                    itemBuilder: (context, index) {
                      final cat = state.cats[index];
                      return Dismissible(
                        key: Key(cat.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => context
                            .read<LikedCatsBloc>()
                            .add(RemoveLikedCatEvent(cat.id)),
                        background: Container(
                          color: const Color(0xFF64B5F6),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(catData: cat),
                            ),
                          ),
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
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
                                        child: CircularProgressIndicator(
                                          color: Color(0xFF64B5F6),
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                    const Icon(Icons.error, color: Colors.red),
                                  ),
                                ),
                              ),
                              title: Text(cat.breedName,
                                  style: Theme.of(context).textTheme.bodyMedium),
                              subtitle: Text(
                                'Liked: ${cat.likedAt!.toString().substring(0, 16)}',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}