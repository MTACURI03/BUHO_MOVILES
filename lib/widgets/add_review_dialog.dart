import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service_supabase.dart';
import '../services/review_service_supabase.dart';

class AddReviewDialog extends StatefulWidget {
  final String siteId;

  const AddReviewDialog({Key? key, required this.siteId}) : super(key: key);

  @override
  _AddReviewDialogState createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final ReviewService _reviewService = ReviewService();
  int _rating = 5;
  bool _isLoading = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser!;

      await _reviewService.createReview(
        siteId: widget.siteId,
        userId: user.id,
        userName: user.name,
        comment: _contentController.text.trim(),
        rating: _rating,
      );

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reseña publicada exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al publicar reseña: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Escribir Reseña'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calificación:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                );
              }),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Tu reseña',
                hintText: 'Comparte tu experiencia...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor escribe tu reseña';
                }
                if (value.trim().length < 10) {
                  return 'La reseña debe tener al menos 10 caracteres';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitReview,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text('Publicar'),
        ),
      ],
    );
  }
}
