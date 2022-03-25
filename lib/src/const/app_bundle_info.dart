// Development

// ignore_for_file: public_member_api_docs, avoid_classes_with_only_static_members

import 'dart:io';

import '../../flavors.dart';

class AppBundleInfo {
  static const String _appstoreId = '1462719760';
  String get appstoreId => _appstoreId;

  static const String _devDynamicLinkHostUrl = 'https://carverauto.page.link';
  static String get devDynamicLinkHostUrl => _devDynamicLinkHostUrl;

  static const String _devIosBundleId = 'com.carverauto.chaseapp.cdev';
  static String get devIosBundleId => _devIosBundleId;

  static const String _devAndroidBundleId = 'com.carverauto.chasedev';
  static String get devAndroidBundleId => _devAndroidBundleId;

// Production

  static const String _prodDynamicLinkHostUrl = 'https://m.chaseapp.tv';
  static String get prodDynamicLinkHostUrl => _prodDynamicLinkHostUrl;

  static const String _prodAndroidBundleId = 'com.carverauto.chaseapp';
  static String get prodAndroidBundleId => _prodAndroidBundleId;

  static const String _prodIosBundleId = 'com.carverauto.chaseapp';
  static String get prodIosBundleId => _prodIosBundleId;

  static String dynamicLinkHostUrl(bool forEmail) {
    final String url = F.appFlavor == Flavor.DEV
        ? devDynamicLinkHostUrl
        : prodDynamicLinkHostUrl;
    return forEmail ? '$url/' : url;
  }

  static String get dynamicLinkPrefix =>
      F.appFlavor == Flavor.DEV ? 'carverauto.com' : 'chaseapp.tv';

  static String get bundleId {
    if (F.appFlavor == Flavor.DEV) {
      if (Platform.isAndroid) {
        return devAndroidBundleId;
      } else {
        return devIosBundleId;
      }
    } else {
      if (Platform.isAndroid) {
        return prodAndroidBundleId;
      } else {
        return prodIosBundleId;
      }
    }
  }

  static String get androidBundleId {
    if (F.appFlavor == Flavor.DEV) {
      return devAndroidBundleId;
    } else {
      return prodAndroidBundleId;
    }
  }

  static String get iosBundleId {
    if (F.appFlavor == Flavor.DEV) {
      return devIosBundleId;
    } else {
      return prodIosBundleId;
    }
  }
}

class EnvVaribales {
  static const String _twitterToken = String.fromEnvironment('Twitter_Token');
  String get twitterToken => _twitterToken;
  static const String _youtubeApiKey = String.fromEnvironment('Youtbe_Api_Key');
  String get youtubeApiKey => _youtubeApiKey;
  static const String _youtubeToken = String.fromEnvironment('Youtube_Token');
  String get youtubeToken => _youtubeToken;
  static const String _devGetStreamChatApiKey =
      String.fromEnvironment('Dev_GetStream_Chat_Api_Key');
  String get devGetStreamChatApiKey => _devGetStreamChatApiKey;
  static const String _prodGetStreamChatApiKey =
      String.fromEnvironment('Prod_GetStream_Chat_Api_Key');
  String get prodGetStreamChatApiKey => _prodGetStreamChatApiKey;
}
