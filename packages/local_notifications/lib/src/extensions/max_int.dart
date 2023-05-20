

import 'dart:math';

extension MaxInt on int {
  int get max32BitInt => 0x7fffffff;

  int random({List<int>? notEqualTo}) {
    int randomNum = Random().nextInt(max32BitInt);

    while (notEqualTo?.contains(randomNum) ?? false) {
      randomNum = Random().nextInt(max32BitInt);
    }

    return randomNum;
  }
}