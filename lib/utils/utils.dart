import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const defaultRadius = BorderRadius.all(Radius.circular(18));
const defaultRadiusFirst = BorderRadius.vertical(top: Radius.circular(18));
const defaultRadiusLast = BorderRadius.vertical(bottom: Radius.circular(18));

// code from: https://github.com/gokadzev/Musify/blob/52008c283c0763135a66e8fa22fb688c4dd6e7a3/lib/utilities/utils.dart#L5
BorderRadius getItemBorderRadius(int index, int totalLength) {
  const baseRadius = BorderRadius.zero;
  if (totalLength == 1) {
    return defaultRadius; // only one item
  } else if (index == 0) {
    return defaultRadiusFirst; // first item
  } else if (index == totalLength - 1) {
    return defaultRadiusLast; // last item
  }
  return baseRadius; // default for middle items
}

Future<(bool, String)> getArchiveUrl(String url) async {
  Dio dio = Dio();

  if (kDebugMode) {
    print("Querying archive.org api for url: $url");
  }
  String archiveUrl = "";
  bool archived = false;
  try {
    var res = await dio.get("https://archive.org/wayback/available?url=$url");

    if (res.statusCode == 200) {
      if (kDebugMode) {
        print("Archive.org result for url $url: ${res.data}");
      }
      if (res.data["archived_snapshots"] != null &&
          res.data["archived_snapshots"]["closest"] != null &&
          res.data["archived_snapshots"]["closest"]["available"]) {
        archiveUrl = res.data["archived_snapshots"]["closest"]["url"];
        archived = true;
        if (kDebugMode) {
          print("Archived URL $archiveUrl for base url: $url");
        }
      } else {
        if (kDebugMode) {
          print("No archived resulsts found for url: $url");
        }
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print(error);
    }
  }

  return (archived, archiveUrl);
}
