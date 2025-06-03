import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://demo.smarttrack.live';
  late CookieJar cookieJar;

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = Duration(seconds: 10);
    _dio.options.receiveTimeout = Duration(seconds: 10);

   
    cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(cookieJar));
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/web/session/authenticate',
        data: {
          "params": {
            "db": "smart_track",
            "login": username,
            "password": password
          }
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getAdminDashboard(String date) async {
    try {
      final response = await _dio.post(
        '/web/dataset/call_kw',
        data: {
          "params": {
            "model": "smart.track",
            "method": "get_admin_dashboard",
            "args": [],
            "kwargs": {
              "date": date
            }
          }
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to load admin dashboard: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getParentDashboard(int studentId, String date, int routeId) async {
    try {
      final response = await _dio.post(
        '/web/dataset/call_kw',
        data: {
          "params": {
            "model": "smart.track",
            "method": "get_parent_dashboard",
            "args": [],
            "kwargs": {
              "student_id": studentId,
              "date": date,
              "route_id": routeId
            }
          }
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to load parent dashboard: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getMorningBusStatus(int studentId) async {
    try {
      final response = await _dio.post(
        '/web/dataset/call_kw',
        data: {
          "params": {
            "model": "smart.track",
            "method": "get_details_after_bus_start",
            "args": [],
            "kwargs": {
              "student_id": studentId
            }
          }
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to load morning bus status: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getEveningBusStatus(int studentId) async {
    try {
      final response = await _dio.post(
        '/web/dataset/call_kw',
        data: {
          "params": {
            "model": "smart.track",
            "method": "get_details_after_evening_bus_start",
            "args": [],
            "kwargs": {
              "student_id": studentId
            }
          }
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to load evening bus status: ${e.toString()}');
    }
  }
}
