import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/cat.dart';
import '../bloc/detail/detail_bloc.dart';

class DetailScreen extends StatelessWidget {
  final Cat catData;

  const DetailScreen({super.key, required this.catData});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailBloc(catData)..add(LoadDetailEvent()),
      child: Scaffold(
        body: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF64B5F6)));
            }
            if (state.error != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: const Text('Error',
                        style: TextStyle(color: Color(0xFF1976D2))),
                    content: Text(state.error!,
                        style: Theme.of(context).textTheme.bodyLarge),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK',
                            style: TextStyle(color: Color(0xFF64B5F6))),
                      ),
                    ],
                  ),
                );
              });
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: CachedNetworkImage(
                      imageUrl: state.cat.url,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(
                        child:
                            CircularProgressIndicator(color: Color(0xFF64B5F6)),
                      ),
                      errorWidget: (_, __, ___) => const Icon(Icons.error),
                    ),
                  ),
                  leading: IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFF64B5F6)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.cat.breedName,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.cat.breedDescription,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 20),
                        _buildInfoCard('Origin', state.cat.origin),
                        _buildInfoCard('Temperament', state.cat.temperament),
                        _buildInfoCard('Life Span', state.cat.lifeSpan),
                        _buildInfoCard('Weight', '${state.cat.weight} kg'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) => Card(
        margin: const EdgeInsets.only(bottom: 8),
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
                    color: Color(0xFF1976D2),
                    fontFamily: 'Poppins',
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF0D47A1),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
