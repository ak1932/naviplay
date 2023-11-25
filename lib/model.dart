// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    SubsonicResponse? subsonicResponse;

    Welcome({
        this.subsonicResponse,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        subsonicResponse: json["subsonic-response"] == null ? null : SubsonicResponse.fromJson(json["subsonic-response"]),
    );

    Map<String, dynamic> toJson() => {
        "subsonic-response": subsonicResponse?.toJson(),
    };
}

class SubsonicResponse {
    String? status;
    String? version;
    String? type;
    String? serverVersion;
    AlbumList? albumList;
    Album? album;
    SearchResult3? searchResult3;


    SubsonicResponse({
        this.status,
        this.version,
        this.type,
        this.serverVersion,
        this.albumList,
        this.album,
        this.searchResult3,
    });

    factory SubsonicResponse.fromJson(Map<String, dynamic> json) => SubsonicResponse(
        status: json["status"],
        version: json["version"],
        type: json["type"],
        serverVersion: json["serverVersion"],
        albumList: json["albumList"] == null ? null : AlbumList.fromJson(json["albumList"]),
        album: json["album"] == null ? null : Album.fromJson(json["album"]),
        searchResult3: json["searchResult3"] == null ? null : SearchResult3.fromJson(json["searchResult3"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "version": version,
        "type": type,
        "serverVersion": serverVersion,
        "albumList": albumList?.toJson(),
        "album": album?.toJson(),
        "searchResult3": searchResult3?.toJson(),
    };
}

class SearchResult3 {
    List<Artist>? artist;
    List<Album>? album;
    List<Song>? song;

    SearchResult3({
        this.artist,
        this.album,
        this.song,
    });

    factory SearchResult3.fromJson(Map<String, dynamic> json) => SearchResult3(
        artist: json["artist"] == null ? [] : List<Artist>.from(json["artist"]!.map((x) => Artist.fromJson(x))),
        album: json["album"] == null ? [] : List<Album>.from(json["album"]!.map((x) => Album.fromJson(x))),
        song: json["song"] == null ? [] : List<Song>.from(json["song"]!.map((x) => Song.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "artist": artist == null ? [] : List<dynamic>.from(artist!.map((x) => x.toJson())),
        "album": album == null ? [] : List<dynamic>.from(album!.map((x) => x.toJson())),
        "song": song == null ? [] : List<dynamic>.from(song!.map((x) => x.toJson())),
    };
}

class Artist {
    String? id;
    String? name;
    String? coverArt;
    int? albumCount;
    String? artistImageUrl;
    List<Album>? album;


    Artist({
        this.id,
        this.name,
        this.coverArt,
        this.albumCount,
        this.artistImageUrl,
        this.album,
    });

    factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        id: json["id"],
        name: json["name"],
        coverArt: json["coverArt"],
        albumCount: json["albumCount"],
        artistImageUrl: json["artistImageUrl"],
        album: json["album"] == null ? [] : List<Album>.from(json["album"]!.map((x) => Album.fromJson(x))),

    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "coverArt": coverArt,
        "albumCount": albumCount,
        "artistImageUrl": artistImageUrl,
        "album": album == null ? [] : List<dynamic>.from(album!.map((x) => x.toJson())),
    };
}

class AlbumList {
    List<Album>? album;

    AlbumList({
        this.album,
    });

    factory AlbumList.fromJson(Map<String, dynamic> json) => AlbumList(
        album: json["album"] == null ? [] : List<Album>.from(json["album"]!.map((x) => Album.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "album": album == null ? [] : List<dynamic>.from(album!.map((x) => x.toJson())),
    };
}

class Album {
    String? id;
    String? parent;
    bool? isDir;
    String? title;
    String? name;
    String? album;
    String? artist;
    int? year;
    String? genre;
    String? coverArt;
    int? duration;
    DateTime? created;
    String? artistId;
    int? songCount;
    bool? isVideo;
    int? playCount;
    DateTime? played;
    List<Song>? song;

    Album({
        this.id,
        this.parent,
        this.isDir,
        this.title,
        this.name,
        this.album,
        this.artist,
        this.year,
        this.genre,
        this.coverArt,
        this.duration,
        this.created,
        this.artistId,
        this.songCount,
        this.isVideo,
        this.playCount,
        this.played,
        this.song,
    });

    factory Album.fromJson(Map<String, dynamic> json) => Album(
        id: json["id"],
        parent: json["parent"],
        isDir: json["isDir"],
        title: json["title"],
        name: json["name"],
        album: json["album"],
        artist: json["artist"],
        year: json["year"],
        genre: json["genre"],
        coverArt: json["coverArt"],
        duration: json["duration"],
        created: json["created"] == null ? null : DateTime.parse(json["created"]),
        artistId: json["artistId"],
        songCount: json["songCount"],
        isVideo: json["isVideo"],
        playCount: json["playCount"],
        played: json["played"] == null ? null : DateTime.parse(json["played"]),
        song: json["song"] == null ? [] : List<Song>.from(json["song"]!.map((x) => Song.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "parent": parent,
        "isDir": isDir,
        "title": title,
        "name": name,
        "album": album,
        "artist": artist,
        "year": year,
        "genre": genre,
        "coverArt": coverArt,
        "duration": duration,
        "created": created?.toIso8601String(),
        "artistId": artistId,
        "songCount": songCount,
        "isVideo": isVideo,
        "playCount": playCount,
        "played": played?.toIso8601String(),
        "song": song == null ? [] : List<dynamic>.from(song!.map((x) => x.toJson())),
    };
}

class Song {
    String? id;
    String? parent;
    bool? isDir;
    String? title;
    String? album;
    String? artist;
    int? track;
    int? year;
    String? genre;
    String? coverArt;
    int? size;
    String? contentType;
    String? suffix;
    int? duration;
    int? bitRate;
    String? path;
    DateTime? created;
    DateTime? starred;
    String? albumId;
    String? type;
    bool? isVideo;
    int? discNumber;

    Song({
        this.id,
        this.parent,
        this.isDir,
        this.title,
        this.album,
        this.artist,
        this.track,
        this.year,
        this.genre,
        this.coverArt,
        this.size,
        this.contentType,
        this.suffix,
        this.duration,
        this.bitRate,
        this.path,
        this.created,
        this.starred,
        this.albumId,
        this.type,
        this.isVideo,
        this.discNumber,
    });

    factory Song.fromJson(Map<String, dynamic> json) => Song(
        id: json["id"],
        parent: json["parent"],
        isDir: json["isDir"],
        title: json["title"],
        album: json["album"],
        artist: json["artist"],
        track: json["track"],
        year: json["year"],
        genre: json["genre"],
        coverArt: json["coverArt"],
        size: json["size"],
        contentType: json["contentType"],
        suffix: json["suffix"],
        duration: json["duration"],
        bitRate: json["bitRate"],
        path: json["path"],
        created: json["created"] == null ? null : DateTime.parse(json["created"]),
        starred: json["starred"] == null ? null : DateTime.parse(json["starred"]),
        albumId: json["albumId"],
        type: json["type"],
        isVideo: json["isVideo"],
        discNumber: json["discNumber"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "parent": parent,
        "isDir": isDir,
        "title": title,
        "album": album,
        "artist": artist,
        "track": track,
        "year": year,
        "genre": genre,
        "coverArt": coverArt,
        "size": size,
        "contentType": contentType,
        "suffix": suffix,
        "duration": duration,
        "bitRate": bitRate,
        "path": path,
        "created": created?.toIso8601String(),
        "starred": created?.toIso8601String(),
        "albumId": albumId,
        "type": type,
        "isVideo": isVideo,
        "discNumber": discNumber,
    };
}
