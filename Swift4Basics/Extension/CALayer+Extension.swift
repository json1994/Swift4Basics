//
//  CALayer+Extension.swift
//  SwiftBasics
//
//  Created by 侯伟 on 17/1/11.
//  Copyright © 2017年 侯伟. All rights reserved.
//

import Foundation
import UIKit
extension CALayer {
    func setBorderUIColor(_ color: UIColor) {
        self.borderColor = color.cgColor
    }
}
