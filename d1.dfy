module FinancialOffers {
    class Context {
        var time: int;
        // Other Context properties...
    }

    class YieldCurve {
        var timeBuckets: seq<int>;
        var rates: seq<real>;

        constructor(timeBuckets: seq<int>, rates: seq<real>)
        requires |timeBuckets| == |rates|
        {
            this.timeBuckets := timeBuckets;
            this.rates := rates;
        }

        static method GetFlatRate(rate: real, timeBuckets: seq<int>) returns (yc: YieldCurve)
        {
            var flatRates := seq(|timeBuckets|, i => rate);
            yc := new YieldCurve(timeBuckets, flatRates);
        }
    }

    class Offer {
        var context: Context;
        var curveRelativeTime: YieldCurve;

        method GetRate(dueDate: int) returns (success: bool, rate: real)
        requires dueDate > this.context.time
        {
            var deltaT := dueDate - this.context.time;

            if deltaT > this.curveRelativeTime.timeBuckets[|this.curveRelativeTime.timeBuckets| - 1] {
                return false, 0.0;
            }
            if deltaT < this.curveRelativeTime.timeBuckets[0] {
                return false, 0.0;
            }

            var minIdx := |this.curveRelativeTime.timeBuckets| - 1;
            var maxIdx := 0;

            var i := 0;
            while i < |this.curveRelativeTime.timeBuckets|
            invariant 0 <= i <= |this.curveRelativeTime.timeBuckets|
            invariant 0 <= minIdx < |this.curveRelativeTime.timeBuckets|
            invariant 0 <= maxIdx < |this.curveRelativeTime.timeBuckets|
            {
                if this.curveRelativeTime.timeBuckets[i] <= deltaT && i > minIdx {
                    minIdx := i;
                }
                if this.curveRelativeTime.timeBuckets[i] >= deltaT && i < maxIdx {
                    maxIdx := i;
                }
                i := i + 1;
            }

            var x0, y0 := this.curveRelativeTime.timeBuckets[minIdx], this.curveRelativeTime.rates[minIdx];
            var x1, y1 := this.curveRelativeTime.timeBuckets[maxIdx], this.curveRelativeTime.rates[maxIdx];

            var y;
            if x1 != x0 {
                y := y0 + (y1 - y0) * (dueDate as real - x0 as real) / (x1 as real - x0 as real);
            } else {
                y := y0;
            }

            return true, y;
        }
    }

    class User {
        // User properties...
    }

    class LoanOffer extends Offer {
        var lender: User;
        var maxAmount: real;
        var maxDueDate: int;
    }

    class BorrowOffer extends Offer {
        var borrower: User;
        var maxAmount: real;
        var virtualCollateralLoansIds: seq<int>;

        method GetFV(amount: real, rate: real) returns (fv: real)
        {
            return (1.0 + rate) * amount;
        }
    }
}
