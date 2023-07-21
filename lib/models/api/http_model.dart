import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import "package:http_parser/http_parser.dart" as http_parser;

import 'api_errors.dart';

/// Class for handling requests to the api. All
/// methods may throw an APIError.
class RequestHandler {
  static const String baseURL = "emmanueld.pythonanywhere.com";
  // Uri.http does will throw an error if there is a `/` in the base url
  // (authority). So I had to separate them
  static const String firstPath = "/api";

  /// Checks for 201, 200, 400, 401, throwing the errors as necessary
  static Map<String, dynamic> _checkResponse(http.Response response) {
    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      var msg = jsonDecode(response.body)["error"];
      throw BadRequest(msg);
    } else if (response.statusCode == 401) {
      var msg = jsonDecode(response.body)["error"];
      throw AuthorizationError(msg);
    } else if (response.statusCode == 404) {
      var msg = jsonDecode(response.body)["error"];
      throw NotFound(msg);
    } else {
      throw ServerError();
    }
  }

  /// Fetches a list of posts posts on the home page
  static Future<List> getHomePosts() async {
    Uri url = Uri.http(baseURL, firstPath);

    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["home"];
    } else {
      throw ServerError();
    }
  }

  static Future<List> getPopularPosts() async {
    Uri url = Uri.http(baseURL, "$firstPath/popular");

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["popular"];
    } else {
      throw ServerError();
    }
  }

  static Future<Map<String, dynamic>> uploadImage(File image) async {
    Uri url = Uri.http(baseURL, "$firstPath/upload/");
    var request = http.MultipartRequest("POST", url);
    String imageExtension =
        image.path.substring(image.path.lastIndexOf(".") + 1);

    request.files.add(
      http.MultipartFile.fromBytes(
        "image",
        image.readAsBytesSync(),
        filename: image.path,
        contentType: http_parser.MediaType("image", imageExtension),
      ),
    );
    http.StreamedResponse response = await request.send();

    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return jsonDecode(responseBody)["url"];
    } else if (response.statusCode >= 400) {
      var msg = jsonDecode(responseBody)["error"];
      throw BadRequest(msg);
    } else {
      throw ServerError();
    }
  }

  static Future<Map<String, dynamic>> signUp(
      {required Map<String, String> requestBody}) async {
    Uri url = Uri.http(baseURL, "$firstPath/signup/");
    var response = await http.post(url, body: jsonEncode(requestBody));

    return _checkResponse(response);
  }

  static Future<Map<String, dynamic>> login(
      {required Map<String, String> requestBody}) async {
    var url = Uri.http(baseURL, "$firstPath/login/");
    var response = await http.post(url, body: jsonEncode(requestBody));

    return _checkResponse(response);
  }

  static Future<Map<String, dynamic>> updateUser(
      {required Map<String, Object> requestBody,
      required int id,
      required String token}) async {
    var url = Uri.http(baseURL, "$firstPath/users/$id/");
    var authorization = {"Authorization": "Bearer $token"};

    var response = await http.patch(url,
        headers: authorization, body: jsonEncode(requestBody));

    return _checkResponse(response);
  }

  static Future<Map<String, dynamic>> getUser(int id) async {
    var url = Uri.http(baseURL, "$firstPath/users/$id/");
    var response = await http.get(url);

    return _checkResponse(response);
  }

  static Future<List> getUserSubreddits(int id) async {
    var url = Uri.http(baseURL, "$firstPath/users/$id/subreddits/");

    var response = await http.get(url);

    return _checkResponse(response)["subreddits"];
  }

  static Future<List> getUserPosts(int id) async {
    var url = Uri.http(baseURL, "$firstPath/users/$id/posts/");

    var response = await http.get(url);

    return _checkResponse(response)["posts"];
  }

  static Future<List> getUserComments(int id) async {
    var url = Uri.http(baseURL, "$firstPath/users/$id/comments/");

    var response = await http.get(url);

    return _checkResponse(response)["comments"];
  }

  static Future<List> getUserUpvotedPosts(int id) async {
    var url = Uri.http(baseURL, "$firstPath/users/$id/posts/upvoted/");

    var response = await http.get(url);

    return _checkResponse(response)["upvotedPosts"];
  }

  static Future<List> getUserDownvotedPosts(int id) async {
    var url = Uri.http(baseURL, "$firstPath/users/$id/posts/downvoted/");

    var response = await http.get(url);

    return _checkResponse(response)["downvotedPosts"];
  }

  static Future<List> getUserUpvotedComments(int id) async {
    var url = Uri.http(baseURL, "$firstPath/users/$id/comments/upvoted/");

    var response = await http.get(url);

    return _checkResponse(response)["upvotedComments"];
  }

  static Future<List> getUserDownvotedComments(int id) async {
    var url = Uri.http(baseURL, "$firstPath/users/$id/comments/downvoted/");

    var response = await http.get(url);

    return _checkResponse(response)["downvotedComments"];
  }

  static Future<Map<String, dynamic>> createSubreddit(
      {required Map<String, Object> requestBody, required String token}) async {
    var url = Uri.http(baseURL, "$firstPath/subreddit/");

    var authorization = {"Authorization": "Bearer $token"};

    var response = await http.post(url,
        headers: authorization, body: jsonEncode(requestBody));

    return _checkResponse(response);
  }

  static Future<Map<String, dynamic>> getSubreddit(int id) async {
    var url = Uri.http(baseURL, "$firstPath/subreddit/$id/");

    var response = await http.get(url);

    return _checkResponse(response);
  }

  static Future<List<dynamic>> getSubredditPosts(int id) async {
    var url = Uri.http(baseURL, "$firstPath/subreddit/$id/posts/");

    var response = await http.get(url);

    return _checkResponse(response)["posts"];
  }

  static Future<Map<String, dynamic>> subscribeToSubreddit(
      {required int uid, required int sid, required String token}) async {
    var url =
        Uri.http(baseURL, "$firstPath/users/$uid/subreddit/$sid/subscribe/");

    var authorization = {"Authorization": "Bearer $token"};

    var response = await http.post(url, headers: authorization);

    return _checkResponse(response);
  }

  static Future<Map<String, dynamic>> unsubscribeToSubreddit(
      {required int uid, required int sid, required String token}) async {
    var url =
        Uri.http(baseURL, "$firstPath/users/$uid/subreddit/$sid/unsubscribe/");

    var authorization = {"Authorization": "Bearer $token"};

    var response = await http.post(url, headers: authorization);

    return _checkResponse(response);
  }

  static Future<Map<String, dynamic>> createPost(
      {required Map<String, Object> requestBody, required String token}) async {
    var url = Uri.http(baseURL, "$firstPath/posts/");

    var authorization = {"Authorization": "Bearer $token"};

    var response = await http.post(url,
        headers: authorization, body: jsonEncode(requestBody));

    return _checkResponse(response);
  }

  static Future<Map<String, dynamic>> getPost(int id) async {
    var url = Uri.http(baseURL, "$firstPath/posts/");

    var response = await http.get(url);

    return _checkResponse(response);
  }

  static Future<Map<String, dynamic>> upvotePost(
      {required int uid, required int pid, required String token}) async {
    var url = Uri.http(baseURL, "$firstPath/users/$uid/posts/$pid/upvote/");

    var authorization = {"Authorization": "Bearer $token"};

    var response = await http.post(url, headers: authorization);

    return _checkResponse(response);
  }

  static Future<Map<String, dynamic>> downvotePost(
      {required int uid, required int pid, required String token}) async {
    var url = Uri.http(baseURL, "$firstPath/users/$uid/posts/$pid/downvote/");

    var authorization = {"Authorization": "Bearer $token"};

    var response = await http.post(url, headers: authorization);

    return _checkResponse(response);
  }

  static Future<Map<String, dynamic>> resetPostVote(
      {required int uid, required int pid, required String token}) async {
    var url =
        Uri.http(baseURL, "$firstPath/users/$uid/posts/$pid/votes/reset/");

    var authorization = {"Authorization": "Bearer $token"};

    var response = await http.post(url, headers: authorization);

    return _checkResponse(response);
  }

  static Future<Map<String, dynamic>> createComment(
      {required Map<String, Object> requestBody,
      required int pid,
      required String token}) async {
    var url = Uri.http(baseURL, "$firstPath/posts/$pid/comment/");
    var authorization = {"Authorization": "Bearer $token"};

    var response = await http.post(url,
        headers: authorization, body: jsonEncode(requestBody));

    return _checkResponse(response);
  }

  static Future<Map<String, dynamic>> getComment(
      {required int pid, required int cid}) async {
    var url = Uri.http(baseURL, "$firstPath/posts/$pid/comments/$cid/");

    var response = await http.get(url);

    return _checkResponse(response);
  }

  static Future<List<dynamic>> getAllPostComments(int pid) async {
    var url = Uri.http(baseURL, "$firstPath/posts/$pid/comments/");

    var response = await http.get(url);

    return _checkResponse(response)["comments"];
  }

  static Future<Map<String, dynamic>> upvoteComment(
      {required int uid, required int cid, required String token}) async {
    var url = Uri.http(baseURL, "$firstPath/users/$uid/comments/$cid/upvote/");

    var authorization = {"Authorization": "Bearer $token"};

    var response = await http.post(url, headers: authorization);

    return _checkResponse(response);
  }

  static Future<Map<String, dynamic>> downvoteComment(
      {required int uid, required int cid, required String token}) async {
    var url =
        Uri.http(baseURL, "$firstPath/users/$uid/comments/$cid/downvote/");

    var authorization = {"Authorization": "Bearer $token"};

    var response = await http.post(url, headers: authorization);

    return _checkResponse(response);
  }

  static Future<Map<String, dynamic>> resetCommentVote(
      {required int uid, required int cid, required String token}) async {
    var url =
        Uri.http(baseURL, "$firstPath/users/$uid/comments/$cid/votes/reset/");

    var authorization = {"Authorization": "Bearer $token"};

    var response = await http.post(url, headers: authorization);

    return _checkResponse(response);
  }
}
