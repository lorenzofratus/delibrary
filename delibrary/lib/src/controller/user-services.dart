import 'package:delibrary/src/controller/envelope.dart';
import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/user.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices extends Services {
  UserServices()
      : super(BaseOptions(
          // baseUrl: "https://delibrary.herokuapp.com/v1/users/",
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

  Future<Envelope<User>> loginUser(User user) async {
    if (user == null ||
        (user.username?.isEmpty ?? true) ||
        (user.password?.isEmpty ?? true))
      return Envelope(error: ErrorMessage.emptyFields);

    Response response;

    String username = cleanParameter(user.username, caseSensitive: true);
    String password = cleanParameter(user.password, caseSensitive: true);

    try {
      response = await dio.get("login?username=$username&password=$password");
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 404)
          return Envelope(error: ErrorMessage.wrongCredentials);
        if (e.response.statusCode == 500)
          return Envelope(error: ErrorMessage.serverError);
        errorOnResponse(e);
      } else {
        errorOnRequest(e, false);
        return Envelope(error: ErrorMessage.checkConnection);
      }
    }

    setCookie(response.headers.map["set-cookie"]);
    return Envelope(payload: User.fromJson(response.data));
  }

  Future<Envelope<User>> validateUser() async {
    Response response;

    try {
      response = await dio.get("login/me");
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 404) {
          destroyCookie();
          return Envelope(error: ErrorMessage.wrongCredentials);
        }
        if (e.response.statusCode == 500)
          return Envelope(error: ErrorMessage.serverError);
        errorOnResponse(e);
      } else {
        errorOnRequest(e, false);
        return Envelope(error: ErrorMessage.checkConnection);
      }
    }

    return Envelope(payload: User.fromJson(response.data));
  }

  Future<Envelope<String>> logoutUser() async {
    try {
      await dio.get("logout");
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 500)
          return Envelope(error: ErrorMessage.serverError);
        errorOnResponse(e);
      } else {
        errorOnRequest(e, false);
        return Envelope(error: ErrorMessage.checkConnection);
      }
    }

    destroyCookie();
    return Envelope(payload: "OK");
  }

  Future<Envelope<User>> registerUser(User user) async {
    if (user == null ||
        (user.username?.isEmpty ?? true) ||
        (user.password?.isEmpty ?? true) ||
        (user.email?.isEmpty ?? true))
      return Envelope(error: ErrorMessage.emptyFields);

    Response response;

    try {
      response = await dio.post("new", data: user.toJson());
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 400)
          return Envelope(error: ErrorMessage.emptyFields);
        if (e.response.statusCode == 409)
          return Envelope(error: ErrorMessage.usernameInUse);
        if (e.response.statusCode == 500)
          return Envelope(error: ErrorMessage.serverError);
        errorOnResponse(e);
      } else {
        errorOnRequest(e, false);
        return Envelope(error: ErrorMessage.checkConnection);
      }
    }

    setCookie(response.headers.map["set-cookie"]);
    return Envelope(payload: User.fromJson(response.data));
  }

  Future<Envelope<User>> getUser(String username) async {
    if (username?.isEmpty ?? true)
      return Envelope(error: ErrorMessage.userNotFound);

    Response response;

    username = cleanParameter(username, caseSensitive: true);

    try {
      response = await dio.get("$username");
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 404)
          return Envelope(error: ErrorMessage.userNotFound);
        if (e.response.statusCode == 500)
          return Envelope(error: ErrorMessage.serverError);
        errorOnResponse(e);
      } else {
        errorOnRequest(e, false);
        return Envelope(error: ErrorMessage.checkConnection);
      }
    }

    return Envelope(payload: User.fromJson(response.data));
  }

  Future<Envelope<User>> updateUser(User user) async {
    if (user == null ||
        (user.username?.isEmpty ?? true) ||
        (user.email?.isEmpty ?? true))
      return Envelope(error: ErrorMessage.emptyFields);

    Response response;

    String username = cleanParameter(user.username, caseSensitive: true);

    try {
      response = await dio.post("$username", data: user.toJson());
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 404)
          return Envelope(error: ErrorMessage.userNotFound);
        if (e.response.statusCode == 403)
          return Envelope(error: ErrorMessage.forbidden);
        if (e.response.statusCode == 500)
          return Envelope(error: ErrorMessage.serverError);
        errorOnResponse(e);
      } else {
        errorOnRequest(e, false);
        return Envelope(error: ErrorMessage.checkConnection);
      }
    }

    return Envelope(payload: User.fromJson(response.data));
  }
}
