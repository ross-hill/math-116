//
//  MillerRabin.swift
//  SwiftCrypto
//
//  Created by Ross Hill on 09/03/2017.
//  Copyright © 2017 Ross Hill. All rights reserved.
//

import Foundation

class FastPoweringAlgorithm {
    var N:Double
    var b:Double
    var a:Double
    var powers:[Double] = []
    var computedPowers:[Double] = []
    var answer:Double
    
    init(N:Double,b:Double,a:Double) {
        self.N = N
        self.b = b
        self.a = a
        self.answer = 1
    }
    
    func compute(){
        // Get binary expansion in Array
        binaryPowers(a: b)
        // return a*a for a^2
        if b == 2{
            self.answer = fmod(a*a,N)
            return
        }
        // interate through each binary power
        for i in 0..<powers.count {
            if i > 0 {
                // compute number of times to multipl
                let diff = powers[i] - powers[i-1]
                var np = computedPowers[i-1]
                for i in 0..<Int(diff) {
                    np = fmod(np*np, self.N)
                }
                computedPowers.append(np)
            }else{
                let pwr = pow(a, pow(2,powers[i]))
                computedPowers.append(fmod(pwr,self.N))
            }
        }
        for i in computedPowers {
            self.answer = fmod(answer*i, self.N)
        }
    }
    
    func binaryPowers(a:Double) {
        var powers:[Double] = []
        var total:Double = 0
        var diff:Double = a
        while(total < a){
            let minVal = maxTwoPower(a: diff)
            powers.append(minVal.i)
            total += minVal.ai
            diff -= minVal.ai
        }
        powers.sort()
        self.powers = powers
    }
    
    func modularPower(a:Double,power p: Double, mod N: Double) -> Double {
        if ceil(p) == 0 {
            var pod = a
            var iter = 0
            while(iter < Int(p)){
                pod = fmod(pod*a, N)
                iter+=1
            }
            return pod
        }else{
            print("p not int")
            return 0
        }
    }
    
    private func maxTwoPower(a:Double)->(i: Double, ai:Double){
        var prevPow:Double = 1
        if a == 1 {
            return (0,1)
        }else{
            for i in 1...1000{
                let tp = pow(Double(2),Double(i))
                if tp > a {
                    if prevPow <= a {
                        let np = Double(i-1)
                        return (np, prevPow)
                    }
                }else{
                    prevPow = tp
                }
            }
        }
        return (0,0)
    }
    
    func gcd(_ a: Double, _ b: Double) -> Double {
        let r = fmod(a,b)
        if r != 0 {
            return gcd(b, r)
        } else {
            return b
        }
    }
}
