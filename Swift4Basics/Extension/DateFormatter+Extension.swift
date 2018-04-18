//
//  DateFormatter+Extension.swift
//  Livby
//
//  Created by mac on 17/2/28.
//  Copyright © 2017年 hw. All rights reserved.
//

import Foundation


extension DateFormatter {
    /// 初始化NSDateFormatter时，传递dataFormat属性值
    public convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}
