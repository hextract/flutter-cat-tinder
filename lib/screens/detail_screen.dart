import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> catData;

  const DetailScreen({super.key, required this.catData});

  @override
  Widget build(BuildContext context) {
    final breed = catData['breeds'][0];

    return Scaffold(
      appBar: AppBar(
        title: Text(breed['name']),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                catData['url'],
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              breed['name'],
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              breed['description'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 20),
            _buildInfoRow('Origin', breed['origin']),
            _buildInfoRow('Temperament', breed['temperament']),
            _buildInfoRow('Life Span', breed['life_span']),
            _buildInfoRow('Weight', '${breed['weight']['metric']} kg'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
