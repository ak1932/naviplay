import 'dart:convert' as convert;
import 'package:crypto/crypto.dart';


class Api {
    static String u = 'ak';
    static String p = '\'';
    static String s = 'navidrome';
    static String c = 'navidrome';
    static String v = '1.16.1';
    static String t = md5.convert(convert.utf8.encode("$p$s")).toString();
    static String f = 'json';

    static Map<String,String> auth = {'u': u, 's': s, 't': t, 'f': f, 'c': c, 'v': v};

    static String baseUrl = '192.168.1.42:4533';
    static String getAlbumList = '/rest/getAlbumList';
    static String getArtist = '/rest/getArtist';
    static String getCoverArt = '/rest/getCoverArt';
    static String getAlbum = '/rest/getAlbum';
    static String stream = '/rest/stream';
    static String search = '/rest/search3';
    static String getPlaylists = '/rest/getPlaylists';
    static String star = '/rest/star';
    static String unstar = '/rest/unstar';
}
