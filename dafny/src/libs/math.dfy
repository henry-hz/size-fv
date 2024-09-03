module Math {

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

    predicate sorted(a: array<int>)
    reads a {
        forall j, k :: 0 <= j < k < a.Length ==> a[j] <= a[k]
    }

    method BinarySearch(a: array<int>, key: int) returns (l: nat, h: nat)
    //requires sorted(a)
    requires a.Length > 1 {
    //ensures 0 <= index ==> index < a.Length && a[index] == key
    //ensures index < 0 ==> forall k :: 0 <= k < a.Length ==> a[k] != key {
    var low:  nat := 0;
    var high: nat := a.Length - 1;

        while low <= high {
            //invariant 0 <= low <= high <= a.Length
            //invariant forall i ::
            //0 <= i < a.Length && !(low <= i < high) ==> a[i] != key {
            var mid := (low + high) / 2;
            if a[mid] == key {
                return mid, mid;
            } else if a[mid] < key {
                low := mid + 1;
            } else {
                high := mid -1;
            }
        }
        return high, low;
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


}

// -------  TESTS


import opened Math
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

