//
//  Line.swift
//  Quiz
//
//  Created by Nahal Khalkhali on 11/30/21.
//

import Foundation
import CoreGraphics
import UIKit

struct Line: Codable {
    var begin = CGPoint.zero
    var end = CGPoint.zero
    var color = 4
    
    init(begin: CGPoint, end: CGPoint, color: Int) {
        self.begin = begin
        self.end = end
        self.color = color
    }
    
    func getColor() -> UIColor{
        switch color{
        case 0: return UIColor.blue
        case 1: return UIColor.red
        case 2: return UIColor.brown
        case 3: return UIColor.magenta
        default: return UIColor.black
        
        }
    }
    
    mutating func setColor(color: UIColor){
        switch color{
        case UIColor.blue: self.color = 0
        case UIColor.red: self.color = 1
        case UIColor.brown: self.color = 2
        case UIColor.magenta: self.color = 3
        default: self.color = 4
        }
    }
}
