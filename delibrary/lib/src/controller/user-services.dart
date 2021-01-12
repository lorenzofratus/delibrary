import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices extends Services {
  //TODO: manage error codes
  UserServices()
      : super(BaseOptions(
          baseUrl: "http://localhost:8080/v1/users/",
          connectTimeout: 10000,
          receiveTimeout: 10000,
        ));

  void setCookie(List<String> cookieHeader) {
    if (cookieHeader.isEmpty) return;

    String authToken = cookieHeader[0].split("; ")[0];

    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString("delibrary-cookie", authToken));
  }

  void destroyCookie() {
    SharedPreferences.getInstance()
        .then((prefs) => prefs.remove("delibrary-cookie"));
  }

  Future<User> loginUser(User user) async {
    Response response;

    String username = cleanParameter(user.username, caseSensitive: true);
    String password = cleanParameter(user.password, caseSensitive: true);

    try {
      response = await dio.get("login?username=$username&password=$password");
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        throw Exception(
            "Delibrary server responded with ${e.response.statusCode}");
      } else {
        print(e.request);
        print(e.message);
        throw Exception(
            "Error while setting up or sending the request to Delibrary");
      }
    }

    setCookie(response.headers.map["set-cookie"]);

    return User.fromJson(response.data);
  }

  Future<void> logoutUser() async {
    Response response;

    try {
      response = await dio.get("logout");
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        throw Exception(
            "Delibrary server responded with ${e.response.statusCode}");
      } else {
        print(e.request);
        print(e.message);
        throw Exception(
            "Error while setting up or sending the request to Delibrary");
      }
    }

    destroyCookie();
  }

  Future<User> registerUser(User user) async {
    Response response;

    try {
      response = await dio.post("new", data: user.toJson());
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        throw Exception(
            "Delibrary server responded with ${e.response.statusCode}");
      } else {
        print(e.request);
        print(e.message);
        throw Exception(
            "Error while setting up or sending the request to Delibrary");
      }
    }

    setCookie(response.headers.map["set-cookie"]);

    return User.fromJson(response.data);
  }

  Future<User> getUser(String username) async {
    Response response;

    username = cleanParameter(username, caseSensitive: true);

    try {
      response = await dio.get("$username");
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        throw Exception(
            "Delibrary server responded with ${e.response.statusCode}");
      } else {
        print(e.request);
        print(e.message);
        throw Exception(
            "Error while setting up or sending the request to Delibrary");
      }
    }

    return User.fromJson(response.data);
  }

  Future<User> updateUser(User user) async {
    Response response;

    String username = cleanParameter(user.username, caseSensitive: true);

    try {
      response = await dio.post("$username", data: user.toJson());
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        throw Exception(
            "Delibrary server responded with ${e.response.statusCode}");
      } else {
        print(e.request);
        print(e.message);
        throw Exception(
            "Error while setting up or sending the request to Delibrary");
      }
    }

    return User.fromJson(response.data);
  }
}
