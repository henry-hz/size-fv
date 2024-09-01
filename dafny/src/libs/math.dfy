module Math {

    const WAD: nat := 1_000_000_000_000_000_000 // 18 zeros
    const RAY: nat := 1_000_000_000_000_000_000_000_000_000 // 27
    const PER: nat := 10_000

    function Max(x: nat, y: nat) : nat {
        if x > y then x
                 else y
    }

    function Min(x:nat, y: nat) : nat {
        if x < y then x
                 else y
    }

    function MulDivUp(x:nat, y:nat, z:nat) : nat{
        x
    }

    function MulDivDown(x:nat, y:nat, z:nat) : nat{
        x
    }

    function ToWad(x:nat) : nat {
        x * WAD
    }

    // -- HIGH PRECISION ARITHMETIC

    function Bps(x: nat, y: nat) : (r: nat) {
        x * y / PER
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

}

