import 'dart:convert' as convert;
import 'package:crypto/crypto.dart';


class Api {
    static String u = 'ak';
    static String p = 'a!Md2@Rm#3Zb&Y#';
    static String s = 'navidrome';
    static String c = 'navidrome';
    static String v = '1.16.1';
    static String t = md5.convert(convert.utf8.encode("$p$s")).toString();
    static String f = 'json';

    static Map<String,String> auth = {'u': u, 's': s, 't': t, 'f': f, 'c': c, 'v': v};

    static String baseUrl = 'ak1932-pi';
    static String music = '/music/rest';
    static String getAlbumList = '$music/getAlbumList';
    static String getArtist = '$music/getArtist';
    static String getCoverArt = '$music/getCoverArt';
    static String getAlbum = '$music/getAlbum';
    static String stream = '$music/stream';
    static String search = '$music/search3';
    static String getPlaylists = '$music/getPlaylists';
    static String star = '$music/star';
    static String unstar = '$music/unstar';
}
