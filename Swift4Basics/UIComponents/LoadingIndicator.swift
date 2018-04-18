//
//  LoadingIndicator.swift
//  SwiftBasics
//
//  Created by 侯伟 on 17/1/11.
//  Copyright © 2017年 侯伟. All rights reserved.
//

import Foundation

open class LoadingIndicator {
    fileprivate var count = 0
    fileprivate var view: UIView?
    
    open func startLoading() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        async {
            if self.count == 0 {
                if self.view == nil {
                    self.view = UIView(frame: window.bounds)
                } else {
                    self.view!.removeFromSuperview()
                }
                
                window.addSubview(self.view!)
            }
            self.count += 1
        }
    }
    
    open func stopLoading() {
        async {
            self.count -= 1
            if self.count <= 0 {
                self.count = 0
                guard let loadingView = self.view else {
                    return
                }
                loadingView.removeFromSuperview()
            }
        }
    }
}
