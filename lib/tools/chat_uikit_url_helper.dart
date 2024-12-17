import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../chat_uikit_settings.dart';
import 'package:html/parser.dart';

int maxRedirects = 5;
int connectionTimeout = 5;

class ChatUIKitURLHelper {
  static ChatUIKitURLHelper? _instance;

  static clear() {
    _instance?._fetchingIds.clear();
    _instance = null;
  }

  factory ChatUIKitURLHelper() {
    return _instance ??= ChatUIKitURLHelper._();
  }

  final List<String> _fetchingIds = [];

  ChatUIKitURLHelper._();

  bool isFetching(String msgId) {
    return _fetchingIds.contains(msgId);
  }

  Future<ChatUIKitPreviewObj?> fetchPreview(String url,
      {String? messageId}) async {
    try {
      final response = await fetchWithRedirects(url);
      final document = parse(await response.transform(utf8.decoder).join());
      if (messageId != null) {
        _fetchingIds.add(messageId);
      }
      String? title = document.head?.querySelector('title')?.text;
      String? desc = document.head
          ?.querySelector("meta[name='description']")
          ?.attributes['content'];
      String? image = document.body?.querySelector('img')?.attributes['src'];

      return title?.isNotEmpty == true
          ? ChatUIKitPreviewObj(
              title: title,
              description: desc ?? '',
              imageUrl: image ?? '',
              url: url,
            )
          : null;
    } catch (e) {
      return null;
    }
  }

  String? getUrlFromText(String text) {
    String? url;
    Iterable<RegExpMatch> match =
        ChatUIKitSettings.defaultUrlRegExp.allMatches(text);
    if (match.isNotEmpty) {
      url = text.substring(match.first.start, match.first.end);
    }
    return url;
  }

  Future<HttpClientResponse> fetchWithRedirects(
    String url, {
    Map<String, String> headers = const {},
  }) async {
    String userAgent =
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0';
    String lowerURL = url.toLowerCase();
    if (!lowerURL.startsWith('http')) {
      url = 'https://$url';
    }
    HttpClient client = HttpClient();
    client.connectionTimeout = Duration(seconds: connectionTimeout);
    final request = await client.getUrl(Uri.parse(url));
    request.headers.add('User-Agent', userAgent);
    request.headers.add('Content-Type', 'application/x-www-form-urlencoded');
    var response = await request.close();

    int redirectCount = 0;

    // print(_isRedirect(response));
    while (_isRedirect(response) && redirectCount < maxRedirects) {
      Uri location = response.redirects.last.location;

      final request = await client.getUrl(location);
      request.headers.add('Content-Type', 'application/x-www-form-urlencoded');
      request.headers.add('User-Agent',
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0');
      response = await request.close();

      redirectCount++;
    }

    if (redirectCount >= maxRedirects) {
      throw Exception('Maximum redirect limit reached');
    }
    client.close();
    return response;
  }

  bool _isRedirect(HttpClientResponse response) {
    if (response.redirects.isNotEmpty) {
      return [301, 302, 303, 307, 308]
          .contains(response.redirects.last.statusCode);
    }
    return false;
  }
}

class ChatUIKitPreviewObj {
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? url;

  ChatUIKitPreviewObj({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
  });

  Map<String, String>? toJson() {
    Map<String, String> map = {};
    if (title != null) {
      map['title'] = title!;
    }

    if (description != null) {
      map['description'] = description!;
    }

    if (imageUrl != null) {
      map['imageUrl'] = imageUrl!;
    }

    if (url != null) {
      map['url'] = url!;
    }

    return map.isEmpty ? null : map;
  }

  factory ChatUIKitPreviewObj.fromJson(Map<String, dynamic> json) {
    return ChatUIKitPreviewObj(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      url: json['url'],
    );
  }
}
