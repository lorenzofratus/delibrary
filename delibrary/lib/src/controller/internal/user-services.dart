import 'package:delibrary/src/controller/external/position-services.dart';
import 'package:delibrary/src/controller/services.dart';
import 'package:delibrary/src/model/session.dart';
import 'package:delibrary/src/model/primary/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices extends Services {
  UserServices()
      : super(BaseOptions(
          baseUrl: "https://delibrary.herokuapp.com/v1/users/",
          connectTimeout: 10000,
          receiveTimeout: 10000,
        ));

  void _setCookie(List<String> cookieHeader) {
    if (cookieHeader.isEmpty) return;
    String authToken = cookieHeader[0].split("; ")[0];
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString(customCookie, authToken));
  }

  void _destroyCookie() {
    SharedPreferences.getInstance().then((prefs) => prefs.remove(customCookie));
  }

  Future<void> loginUser(User user, BuildContext context) async {
    if (user == null ||
        (user.username?.isEmpty ?? true) ||
        (user.password?.isEmpty ?? true))
      return showSnackBar(context, ErrorMessage.emptyFields);

    Response response;

    String username = cleanParameter(user.username, caseSensitive: true);
    String password = cleanParameter(user.password, caseSensitive: true);

    try {
      response = await dio.get("login?username=$username&password=$password");
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 404)
          return showSnackBar(context, ErrorMessage.wrongCredentials);
        if (e.response.statusCode == 500)
          return showSnackBar(context, ErrorMessage.serverError);
        // Otherwise, unexpected error, print and raise exception
        errorOnResponse(e);
      } else {
        // Generic error before the request is sent, print
        errorOnRequest(e, false);
        return showSnackBar(context, ErrorMessage.checkConnection);
      }
    }

    // Login successful, set cookie and redirect to home
    _setCookie(response.headers.map["set-cookie"]);
    return navigateTo(context, "/");
  }

  Future<bool> validateUser(BuildContext context) async {
    Function goToLogin = () => navigateTo(context, "/login");

    Response response;

    try {
      response = await dio.get("login/me");
    } on DioError catch (e) {
      _destroyCookie();
      if (e.response != null) {
        if (e.response.statusCode == 404) {
          // Invalid cookie, no need to display this to the user
          goToLogin();
          return false;
        }
        if (e.response.statusCode == 500) {
          showSnackBar(context, ErrorMessage.serverError);
          goToLogin();
          return false;
        }
        // Otherwise, unexpected error, print and raise exception
        errorOnResponse(e);
      } else {
        // Generic error before the request is sent, print
        errorOnRequest(e, false);
        showSnackBar(context, ErrorMessage.checkConnection);
        goToLogin();
        return false;
      }
    }

    // Cookie valid, creating a new session
    Session session = context.read<Session>();
    session.destroy();
    session.user = User.fromJson(response.data);

    // Fetch provinces only if needed
    if (!session.hasProvinces)
      session.provinces = await PositionServices().loadProvinces(context);

    // with the list of provinces/towns. At the moment the user is stuck
    // on the loading page where a snackbar is displayed.
    return session.hasProvinces;
  }

  Future<void> logoutUser(BuildContext context) async {
    try {
      await dio.get("logout");
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 500)
          return showSnackBar(context, ErrorMessage.serverError);
        // Otherwise, unexpected error, print and raise exception
        errorOnResponse(e);
      } else {
        // Generic error before the request is sent, print
        errorOnRequest(e, false);
        return showSnackBar(context, ErrorMessage.checkConnection);
      }
    }

    // Logout successful, destroy cookie and session, redirect to login
    _destroyCookie();
    context.read<Session>().destroy();
    return navigateTo(context, "/login");
  }

  Future<void> registerUser(User user, BuildContext context) async {
    if (user == null ||
        (user.username?.isEmpty ?? true) ||
        (user.password?.isEmpty ?? true) ||
        (user.email?.isEmpty ?? true))
      return showSnackBar(context, ErrorMessage.emptyFields);

    Response response;

    try {
      response = await dio.post("new", data: user.toJson());
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 400)
          return showSnackBar(context, ErrorMessage.emptyFields);
        if (e.response.statusCode == 409)
          return showSnackBar(context, ErrorMessage.usernameInUse);
        if (e.response.statusCode == 500)
          return showSnackBar(context, ErrorMessage.serverError);
        // Otherwise, unexpected error, print and raise exception
        errorOnResponse(e);
      } else {
        // Generic error before the request is sent, print
        errorOnRequest(e, false);
        return showSnackBar(context, ErrorMessage.checkConnection);
      }
    }

    // Registration successful, set cookie and redirect to home
    _setCookie(response.headers.map["set-cookie"]);
    return navigateTo(context, "/");
  }

  // NOT USED YET, MAY NEED SOME CHANGES
  // IN CASE OF ERROR RETURNS NULL
  // PROBABLY SHOULD REDIRECT TO THE USER PAGE
  Future<User> getUser(String username, BuildContext context) async {
    if (username?.isEmpty ?? true) {
      showSnackBar(context, ErrorMessage.emptyUsername);
      return null;
    }

    Response response;

    username = cleanParameter(username, caseSensitive: true);

    try {
      response = await dio.get("$username");
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 404) {
          showSnackBar(context, ErrorMessage.userNotFound);
          return null;
        }
        if (e.response.statusCode == 500) {
          showSnackBar(context, ErrorMessage.serverError);
          return null;
        }
        // Otherwise, unexpected error, print and raise exception
        errorOnResponse(e);
      } else {
        // Generic error before the request is sent, print
        errorOnRequest(e, false);
        showSnackBar(context, ErrorMessage.checkConnection);
        return null;
      }
    }

    // User found, returning it
    return User.fromJson(response.data);
  }

  Future<void> updateUser(User user, BuildContext context) async {
    if (user == null ||
        (user.username?.isEmpty ?? true) ||
        (user.email?.isEmpty ?? true))
      return showSnackBar(context, ErrorMessage.emptyFields);

    Response response;

    String username = cleanParameter(user.username, caseSensitive: true);

    try {
      response = await dio.post("$username", data: user.toJson());
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response.statusCode == 404)
          return showSnackBar(context, ErrorMessage.userNotFound);
        if (e.response.statusCode == 403)
          return showSnackBar(context, ErrorMessage.forbidden);
        if (e.response.statusCode == 500)
          return showSnackBar(context, ErrorMessage.serverError);
        // Otherwise, unexpected error, print and raise exception
        errorOnResponse(e);
      } else {
        // Generic error before the request is sent, print
        errorOnRequest(e, false);
        return showSnackBar(context, ErrorMessage.checkConnection);
      }
    }

    // Update successful, update the session and display a feedback
    context.read<Session>().user = User.fromJson(response.data);
    showSnackBar(
      context,
      user.password == null
          ? ConfirmMessage.userUpdated
          : ConfirmMessage.passwordUpdated,
    );
  }
}
