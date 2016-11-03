//
//  Number+Extension.swift
//  CowGoods
//
//  Created by ddn on 16/6/24.
//  Copyright © 2016年 ddn. All rights reserved.
//

import Foundation

extension CGFloat {
    func fit() -> CGFloat {
        return self / 2.0
    }
    
    func fitFont() -> UIFont {
        return UIFont.systemFontOfSize(self.fit())
    }
}

extension Float {
    func fit() -> CGFloat {
        return CGFloat(self) / 2.0
    }
    
    func fitFont() -> UIFont {
        return UIFont.systemFontOfSize(self.fit())
    }
}

extension Double {
    func fit() -> CGFloat {
        return CGFloat(self) / 2.0
    }
    
    func fitFont() -> UIFont {
        return UIFont.systemFontOfSize(self.fit())
    }
    
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

extension Int {
    func fit() -> CGFloat {
        return CGFloat(self) / 2.0
    }
    
    func fitFont() -> UIFont {
        return UIFont.systemFontOfSize(self.fit())
    }
}