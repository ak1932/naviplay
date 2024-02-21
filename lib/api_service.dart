import 'package:dio/dio.dart';
import 'constants.dart';
import 'model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DioClient {
  final Dio _dio = Dio();
  Future<Response?> getRequest(Uri url) async {
    print(url);
    Response? response;
    try {
      response = await _dio.getUri(url);
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
      }
      print(e.message);
    }
    return response;
  }

  Future<Album?> getAlbum({required String id}) async {
    Album? album;
    var url = Uri.http(Api.baseUrl, Api.getAlbum, {...Api.auth, 'id': id});

    Response response = (await getRequest(url))!;
    if (response.data['subsonic-response']['status'] == 'ok') {
      album = Album.fromJson(response.data['subsonic-response']['album']);
    }
    return album;
  }


  void star({required String id}) async {
    var url = Uri.http(Api.baseUrl, Api.star, {...Api.auth, 'id': id});

    Response response = (await getRequest(url))!;
    if (response.data['subsonic-response']['status'] == 'ok') {
    }
  }

  void unstar({required String id}) async {
    var url = Uri.http(Api.baseUrl, Api.unstar, {...Api.auth, 'id': id});

    Response response = (await getRequest(url))!;
    if (response.data['subsonic-response']['status'] == 'ok') {
    }
  }

  Future<List<Album>?> getAlbumList(
      {required String type, String size = '25', String offset = '0'}) async {
    List<Album>? albumList;
    var url = Uri.http(Api.baseUrl, Api.getAlbumList,
        {...Api.auth, 'type': type, 'size': size, 'offset': offset});

    Response response = (await getRequest(url))!;
    if (response.data['subsonic-response']['status'] == 'ok') {
      albumList =
          AlbumList.fromJson(response.data['subsonic-response']['albumList'])
              .album;
    }
    return albumList;
  }

  Future<SearchResult3?> search(
      {required String query,
      String artistCount = '20',
      String artistOffset = '0',
      String albumCount = '20',
      String albumOffset = '0',
      String songCount = '20',
      String songOffset = '0'}) async {
      print('query = $query');
    SearchResult3? searchResult3;
    var url = Uri.http(Api.baseUrl, Api.search, {
      ...Api.auth,
      'query': query,
      'artistCount': artistCount,
      'artistOffset': artistOffset,
      'albumCount': albumCount,
      'albumOffset': albumOffset,
      'songCount': songCount,
      'songOffset': songOffset
    });

    Response response = (await getRequest(url))!;
    if (response.data['subsonic-response']['status'] == 'ok') {
      searchResult3 = SearchResult3.fromJson(
          response.data['subsonic-response']['searchResult3']);
    }

    return searchResult3;
  }

  Future<Artist?> getArtist({required String id}) async {
    Artist? artist;
    var url = Uri.http(Api.baseUrl, Api.getArtist, {...Api.auth, 'id': id});

    Response response = (await getRequest(url))!;
    if (response.data['subsonic-response']['status'] == 'ok') {
      artist = Artist.fromJson(response.data['subsonic-response']['artist']);
    }

    return artist;
  }

  CachedNetworkImage cachedImage(
      {required String id, BoxFit? fit, double? width, double? height}) {
    String imageUrl =
        Uri.http(Api.baseUrl, Api.getCoverArt, {...Api.auth, 'id': id})
            .toString();
    return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        width: width,
        height: height,
        errorWidget: (context, hi, bye) {
          return Container();
        });
  }
}
