import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/blog.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';

  // Sign in or log in a user
  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('error')) {
        throw Exception(data['error']);
      }
      return User.fromJson(data);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Sign up a new user
  Future<void> signup({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
    required String telephone,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'password': password,
        'telephone': telephone,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('error')) {
        throw Exception(data['error']);
      }
    } else {
      throw Exception('Failed to signup: ${response.body}');
    }
  }

  // Fetch all published blogs
  Future<List<Blog>> fetchBlogs() async {
    final response = await http.get(Uri.parse('$baseUrl/blogs.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Blog.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch blogs: ${response.body}');
    }
  }

  // Fetch user profile
  Future<Map<String, dynamic>> fetchProfile(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/profile.php?userId=$userId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('error')) {
        throw Exception(data['error']);
      }
      return data;
    } else {
      throw Exception('Failed to fetch profile: ${response.body}');
    }
  }

  // Update user profile
  Future<void> updateProfile({
    required int userId,
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String telephone,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/profile.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'email': email,
        'telephone': telephone,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('error')) {
        throw Exception(data['error']);
      }
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }
}