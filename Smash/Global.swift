import Foundation
import UIKit

struct Global_Variables {
    static var score: Int = 0
}

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
    static let DownBorder: UInt32 = 0b11      // 3
}


func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func randomizer (_ lower: Int , upper: Int) -> CGFloat {
    return CGFloat(lower + Int(arc4random_uniform(UInt32(upper - lower + 1))))
}

func randomizer_Int (_ lower:Int, upper: Int) -> Int {
    return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
}
