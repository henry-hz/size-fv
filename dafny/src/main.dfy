
include "libs/math.dfy"

import opened Math2

method Main() {
    var arr := new int[5] [1, 2, 4, 7, 9];
    var key := 1;
    var index :nat := BinarySearch2(arr, key);
    print index;
    print "\n";
}
