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
