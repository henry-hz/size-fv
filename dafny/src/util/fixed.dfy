include "number.dfy"
include "maps.dfy"
include "tx.dfy"


// Fixed point arithmetic math
// https://github.com/dapphub/ds-math/blob/master/src/math.sol
module Fixed {

import opened Number
import opened Maps
import opened Tx

    const WAD: u256 := 1_000_000_000_000_000_000 // 18 zeros
    const RAY: u256 := 1_000_000_000_000_000_000_000_000_000 // 27
    const PER: u256 := 10_000

    // -- SIMPLE arithmetic

    function Add(x: u256, y: u256) : u256
    requires (x as nat) + (y as nat) <= MAX_U256 {
        x + y
    }

    function Sub(x: u256, y: u256) : u256
    requires (x as int) - (y as int) >= 0 {
        x - y
    }

    function Mul(x: u256, y: u256) : u256
    requires (x as nat) * (y as nat) <= MAX_U256 {
        x * y
    }

    function Div(x: u256, y: u256) : u256
    requires y != 0 {
        x / y
    }

    // -- HIGH PRECISION ARITHMETIC

    function Bps(x: u256, y: u256) : (r: u256)
    requires (x as nat) * (y as nat) <= MAX_U256 as nat {
        Mul(x,y) / PER
    }

    //rounds to zero if x*y < WAD / 2
    function Wmul(x: u256, y: u256) : u256
    requires y == 0 || (x as nat) * (y as nat) <= MAX_U256 as nat
    requires (Mul(x,y) as nat) + ((WAD/2) as nat) <= MAX_U256 as nat
    requires Mul(x,y) as nat <= MAX_U256 {
        var m: u256 := Mul(x,y);
        var w: u256 := WAD / 2;
        (Add(m , w))/WAD
    }

    //rounds to zero if x*y < WAD / 2
    function Wdiv(x: u256, y:u256) : (r: u256)
    requires (x as nat) * (WAD as nat) < MAX_U256
    requires Mul(x,WAD) as nat + (y/2) as nat <= MAX_U256 as nat
    requires y != 0 {
        var m: u256 := Mul(x,WAD);
        var w: u256 := y / 2;
        var z: u256 := Add(m,w);
        z / y
    }
}

// --- TESTS

import opened Fixed
import opened Number
import opened Maps
import opened Tx

method {:test} testFindMax() {
    var j := 1000000000000000000 as u256;
    var i := 1000000000000000000 as u256;
    var r := 1000000000000000000 as u256;

    assert Wmul(j,i) == r;
    assert Wmul(WAD, WAD) == WAD;
    assert Wdiv(j,i) == r;
    assert Wdiv(WAD, WAD) == WAD;
    assert Wdiv(4*WAD, 2*WAD) == 2*WAD;

    var x : nat := 100000000000000000;

    // 10^18 * 10^18 = 10^36
    //print(x*x); // it has 34 zeros ! help

    var x1 : nat := 1000000000000000000;
    var x2 : nat := 1000000000000000000;
    var r1 : nat := 1000000000000000000000000000000000000;
    var r2 : nat := (r1 + (x1/2)) / x1;
    assert x1*x2 == r1;

    print(x1*x2);
    assert r2 == x1;

    // 0.01 percent = 1 BPS
    var y1 := 20_000000000000000000 as u256;  // 20 WAD
    var p1 := 200 as u256;                    // 2% in BPS
    assert Bps(y1, p1) == 400000000000000000; // 0.4

    // dafny automatic convert from nat to int when needed
    var o1 : nat := 3;
    var o2 : nat := 4;
    var o3 : int := o1-o2;
    assert o1 - o2 == -1;

    // use the 'number.dfy'
    assert Div(7,12) == 0;

    assert Div(1*WAD, 2*WAD)  == 0;
    assert Wdiv(1*WAD, 2*WAD) == 500000000000000000;
}




