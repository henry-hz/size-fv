module Math2 {

    const TWO_256 : int := 0x1_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000
    const WAD:      nat := 1_000_000_000_000_000_000 // 18 zeros
    const RAY:      nat := 1_000_000_000_000_000_000_000_000_000 // 27
    const PERCENT:  nat := 1_000_000_000_000_000_000 // 18 zeros
    const YEAR: nat := 30758400 // year in seconds
    const MAX_U256: int := TWO_256 - 1

    function Max(x: nat, y: nat) : nat {
        if x > y then x
                 else y
    }

    function Min(x:nat, y: nat) : nat {
        if x < y then x
                 else y
    }

    /// Returns `ceil(x * y / d)`. [arredonda para cima]
    /// Reverts if `x * y` overflows, or `d` is zero.
    //  z := add(iszero(iszero(mod(mul(x, y), d))), div(mul(x, y), d))
    function MulDivUp(x:nat, y:nat, z:nat) : (r: nat)
    requires z > 0
    ensures r == (x * y + z - 1) / z{
        (x * y + z - 1) / z
    }

    /// @dev Returns `floor(x * y / d)`. [arredonda para baixo]
    /// Reverts if `x * y` overflows, or `d` is zero.
    function MulDivDown(x:nat, y:nat, z:nat) : (r: nat)
    requires z > 0
    ensures r == (x * y) / z {
        (x * y) / z
    }


    //rounds to zero if x*y < WAD / 2
    function Wmul(x: nat, y: nat) : nat {
        var m: nat := x * y;
        var w: nat := WAD / 2;
        (m + w)/WAD
    }

    //rounds to zero if x*y < WAD / 2
    function Wdiv(x: nat, y:nat) : (r: nat)
    requires y != 0 {
        var m: nat := x * WAD;
        var w: nat := y / 2;
        var z: nat := m + w;
        z / y
    }

    function ToWad(x:nat) : nat {
        x * WAD
    }


    // 1. Correctness of the search result:
    //    - If the value is found in the array, the function should return the correct index range (low, high) where low == high.
    //    - If the value is not found in the array, the function should return the correct index range (high,
    //      low) where high < low and array[high] < value < array[low].
    //
    // 2. Bounds of the returned indices:
    //    - The returned low and high indices should always be within the valid range of the array indices, i.e., 0 <= low <= high < array.length.
    //    - If the value is outside the range of the array (value < array[0] or value > array[array.length - 1]), the function
    //      should return (type(uint256).max, type(uint256).max).
    //
    // 3. Monotonicity of the array:
    //    - The input array should be sorted in non-decreasing order. You can assert that for all i < j, array[i] <= array[j].
    //    - If the array is not sorted, the behavior of the binary search is undefined.
    //
    // 4. Termination:
    //    - The function should always terminate and not enter an infinite loop.
    //    - You can verify that the loop condition (low <= high) eventually becomes false, and the function returns.
    //
    // 5. Gas cost and overflow safety:
    //    - Ensure that the arithmetic operations, such as (low + high) / 2, do not cause integer overflows.
    //    - Analyze the gas cost of the function and ensure it stays within acceptable limits, especially for large arrays.
    //
    // 6. Edge cases:
    //    - Test the function with edge cases, such as an empty array, an array with a single element,
    //    - or an array where the value is at the beginning or end.
    //    - Verify that the function behaves correctly and returns the expected results in these cases.
    //
    // 7. Invariants:
    //    - Define and check any invariants that should hold throughout the execution of the function.
    //    - For example, you can assert that low <= high holds at the beginning of each loop iteration.
    //
    // 8. Postconditions:
    //    - Define and verify the postconditions that should be true after the function returns.
    //    - For example, you can assert that if the function returns (low, high), then either low == high (value found) or high < low (value not found).

    // 1. because of return MAX_U256, we can't ensure  0 <= low <= high < curve.Length
    // 2. this algo is solving different problems at the same time, and not only
    //    searching, once it's looking for exact values and also a value in the middle

    // Let's go through the binary search algorithm step by step with
    // the given array [100, 300, 400, 900, 1500] and the target value of 500.
    //
    // Initialization:
    // - low = 0
    // - high = array.length - 1 = 4
    // - The target value 500 is within the range of the array, so we proceed with the binary search.
    //
    // Iteration 1:
    // - mid = (low + high) / 2 = (0 + 4) / 2 = 2
    // - array[mid] = array[2] = 400
    // - Since 400 < 500, we update low to mid + 1.
    // - low = 3
    // - high = 4
    //
    // Iteration 2:
    // - mid = (low + high) / 2 = (3 + 4) / 2 = 3
    // - array[mid] = array[3] = 900
    // - Since 900 > 500, we update high to mid - 1.
    // - low = 3
    // - high = 2
    //
    // At this point, low > high, so the while loop terminates.
    //
    // Final values:
    // - low = 3
    // - high = 2
    //
    // The function returns (high, low) = (2, 3), substituting the output low to the high
    // and high to the low, low becomes higher than high. A rename would be good here.

    predicate sorted(a: array<nat>)
    reads a {
        forall j, k :: 0 <= j < k < a.Length ==> a[j] <= a[k]
    }

    predicate out_of_range(curve: array<nat>, value: nat)
    requires curve.Length >= 1
    reads curve {
        (value < curve[0] || value > curve[curve.Length - 1])
    }

    predicate in_range(curve: array<nat>, value: nat)
    requires curve.Length >= 1
    reads curve {
        (value >= curve[0] && value <= curve[curve.Length - 1])
    }

    method BinarySearch(curve: array<nat>, value: nat) returns (low: nat, high: nat)
    // to satisfy the a.Length - 1
    requires curve.Length >= 1
    // Curve must be sorted in ascending order [in fact, it works also out of the order]
    requires forall j, k :: 0 <= j < k < curve.Length ==> curve[j] <= curve[k]
    // if the value is outside the range of the array, both low and high should be set to uint256.max
    ensures out_of_range(curve, value) ==> (low == MAX_U256 && high == MAX_U256)
    // The output index is always inside the range
    ensures low == 0 && high == 0 ==> value < curve[0] || value > curve[curve.Length - 1]
    // This guarantees that 'low' and 'high' are valid indices for 'curve'
    ensures in_range(curve, value) ==> 0 <= low <= high <= curve.Length - 1
    // Check value beyond the ends when in the spectrum
    ensures in_range(curve, value) && low > 0 ==> curve[0] <= value
    // Check value beyond the ends when in the spectrum
    ensures in_range(curve, value) &&  high < curve.Length - 1 ==> value <= curve[curve.Length - 1]
    // When the algo find the exact value
    ensures in_range(curve, value) && low == high ==> curve[low] == value && curve[high] == value
    // When the the value is in between two values inside the array
    ensures in_range(curve, value) && sorted(curve) && low < high  ==> curve[low] < value < curve[high]
    //ensures 0 < low == high <= curve.Length ==> curve[low - 1] <= value
    //ensures 0 < low < high <= curve.Length ==> curve[low - 1] <= value < curve[high - 1]
    //ensures 1 <= value ==> value < curve.Length && curve[value] == value
    //ensures value < 0 ==> forall k :: 0 <= k < curve.Length ==> curve[k] != value
    // If the value is within the range, low should be less than or equal to high,
    // and the value should be between curve[low] and curve[high], inclusive.
    // ensures (value >= curve[0] && value <= curve[curve.Length - 1]) ==> (low <= high && curve[low] <= value <= curve[high])
    {

        low  := 0;
        high := curve.Length - 1;
        if (value < curve[low] || value > curve[high]) {
            return MAX_U256, MAX_U256;
        }
        // we can't say invariant 0 <= low <= high <= curve.Length - 1
        // because low will bypass high sometimes
        while low <= high
        invariant 0 <= low  <= curve.Length - 1
        invariant 0 <= high <= curve.Length - 1
        invariant high == low ==> curve[low] == curve[high]
        //invariant low > high ==> (low == high + 1 && curve[high] < value < curve[low])
        {
            var mid :nat := (low + high) / 2;
            assume {:axiom} mid > 0 && mid <= curve.Length - 1;
            if curve[mid] == value {
                return mid, mid;
            } else if curve[mid] < value {
                low := mid + 1;
            } else {
                high := mid - 1;
            }
        }
        // the correct would be: low, high, and in Dafny as in Solidity, both reassign
        // the output following the order proposed on the return value, overriding the
        // original name, so here and in Solidity the high will be assigned to low
        // and the low assigned to high
        return high, low;
    }

}


// -------  TESTS


import opened Math2
// low = 0 and high = 1
method TestBinarySearchMatchMiddle() {
    var arr := new nat[2] [86400, 259200];
    var key := 99400;
    var low, high := BinarySearch(arr, key);
    //assert low == 0;
    //assert high == 1;
}

method testBinarySearch() {
    var arr := new nat[5] [1, 2, 4, 7, 9];
    var key := 2;

    var low, high := BinarySearch(arr, key);

    //assert low == 0;
    //assert low == 2 && high == 2;
    //assert arr[low - 1] == key;
}

method TestDiv1() {
    assert MulDivUp(7, 3, 4) == 6;
    assert MulDivUp(3, 5, 4) == 4;
    assert MulDivUp(4, 5, 4) == 5;

}
method TestDiv2() {
    assert MulDivUp(10, 5, 2) == 25;
    assert MulDivUp(15, 1, 2) == 8;
}
method TestDiv3() {
    assert MulDivDown(7, 3, 4) == 5;
    assert MulDivDown(3, 5, 4) == 3;
    assert MulDivDown(4, 5, 4) == 5;
}

method Main() {
    var arr := new nat[2] [86400, 259200];
    var key := 99400;
    var low, high := BinarySearch(arr, key);
    print "Low  index: ", low, "\n";
    print "High index: ", high, "\n";

    // arredonda pra baixo
    var n := 1/2;
    print "n: ", n, "\n";
}
