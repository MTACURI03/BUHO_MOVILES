import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/review.dart';

class ReviewService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();

  Future<List<Review>> getReviews(String siteId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select()
          .eq('site_id', siteId)
          .order('created_at', ascending: false);

      return response
          .map<Review>((data) => Review.fromMap(data))
          .toList();
    } catch (e) {
      print('Error getting reviews: $e');
      return [];
    }
  }

  Future<List<Review>> getReviewsByUser(String userId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response
          .map<Review>((data) => Review.fromMap(data))
          .toList();
    } catch (e) {
      print('Error getting user reviews: $e');
      return [];
    }
  }

  Future<Review?> getReviewById(String reviewId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select()
          .eq('id', reviewId)
          .single();

      return Review.fromMap(response);
    } catch (e) {
      print('Error getting review by ID: $e');
      return null;
    }
  }

  Future<String?> createReview({
    required String siteId,
    required String userId,
    required String userName,
    required String comment,
    required int rating,
  }) async {
    try {
      final review = Review(
        id: _uuid.v4(),
        siteId: siteId,
        userId: userId,
        userName: userName,
        comment: comment,
        rating: rating,
        createdAt: DateTime.now(),
      );

      await _supabase.from('reviews').insert(review.toMap());
      return null; // Éxito
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateReview({
    required String reviewId,
    required String comment,
    required int rating,
  }) async {
    try {
      await _supabase
          .from('reviews')
          .update({
            'comment': comment,
            'rating': rating,
          })
          .eq('id', reviewId);

      return null; // Éxito
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> deleteReview(String reviewId) async {
    try {
      await _supabase
          .from('reviews')
          .delete()
          .eq('id', reviewId);

      return null; // Éxito
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> addResponse({
    required String reviewId,
    required String response,
  }) async {
    try {
      await _supabase
          .from('reviews')
          .update({'response': response})
          .eq('id', reviewId);

      return null; // Éxito
    } catch (e) {
      return e.toString();
    }
  }

  Future<double> getAverageRating(String siteId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('rating')
          .eq('site_id', siteId);

      if (response.isEmpty) return 0.0;

      final ratings = response.map((r) => r['rating'] as int).toList();
      final average = ratings.reduce((a, b) => a + b) / ratings.length;
      
      return double.parse(average.toStringAsFixed(1));
    } catch (e) {
      print('Error getting average rating: $e');
      return 0.0;
    }
  }

  Future<int> getReviewCount(String siteId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('id')
          .eq('site_id', siteId);

      return response.length;
    } catch (e) {
      print('Error getting review count: $e');
      return 0;
    }
  }

  Future<bool> hasUserReviewed(String siteId, String userId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('id')
          .eq('site_id', siteId)
          .eq('user_id', userId);

      return response.isNotEmpty;
    } catch (e) {
      print('Error checking user review: $e');
      return false;
    }
  }
}
