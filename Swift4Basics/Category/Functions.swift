//
//  Functions.swift
//  SwiftBasics
//
//  Created by 侯伟 on 17/1/11.
//  Copyright © 2017年 侯伟. All rights reserved.
//

import Foundation

/// 延迟执行代码
public func delay(_ seconds: UInt64, task: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(seconds * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: task)
}

/// 异步执行代码块（先非主线程执行，再返回主线程执行）
public func async(_ backgroundTask: @escaping () -> AnyObject?, mainTask: @escaping (AnyObject?) -> Void) {
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
        let result = backgroundTask()
        DispatchQueue.main.sync {
            mainTask(result)
        }
    }
}

/// 异步执行代码块（主线程执行）
public func async(_ mainTask: @escaping () -> Void) {
    DispatchQueue.main.async(execute: mainTask)
}

/// 顺序执行代码块（在队列中执行）
public func sync(_ task: () -> Void) {
    DispatchQueue(label: "com.hw.LockQueue", attributes: []).sync(execute: task)
}

public func alert(_ message: String, title: String! = nil, completion: (() -> Void)? = nil) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "我知道了", style: .default) { action in
        controller.dismiss(animated: true, completion: nil)
        completion?()
        })
    UIViewController.topViewController?.present(controller, animated: true, completion: nil)
}

public func confirm(_ message: String, title: String! = nil, completion: @escaping (Bool) -> Void) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "否", style: .cancel) { action in
        controller.dismiss(animated: true, completion: nil)
        completion(false)
        })
    controller.addAction(UIAlertAction(title: "是", style: .default) { action in
        controller.dismiss(animated: true, completion: nil)
        completion(true)
        })
    UIViewController.topViewController?.present(controller, animated: true, completion: nil)
}

public func prompt(_ message: String, title: String! = nil, text: String! = nil, placeholder: String! = nil, completion: @escaping (String?) -> Void) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "取消", style: .cancel) { action in
        controller.dismiss(animated: true, completion: nil)
        completion(nil)
        })
    controller.addAction(UIAlertAction(title: "确定", style: .default) { action in
        controller.dismiss(animated: true, completion: nil)
        completion(controller.textFields?[0].text ?? "")
        })
    controller.addTextField { textField in
        if let value = text {
            textField.text = value
        }
        if let ph = placeholder {
            textField.placeholder = ph
        }
    }
    UIViewController.topViewController?.present(controller, animated: true, completion: nil)
}

public func toast(_ message: String?, in view: UIView? = nil, duration: TimeInterval? = nil, position: ToastPosition? = nil, title: String? = nil, image: UIImage? = nil, style: ToastStyle? = nil, completion: ((_ didTap: Bool) -> Void)? = nil) {
    guard let view = view ?? UIApplication.shared.keyWindow else { return }
    let manager = ToastManager.shared
    view.makeToast(message, duration: duration ?? manager.duration, position: position ?? manager.position, title: title, image: image, style: style, completion: completion)
}

public func spin(in view: UIView?, at position: ToastPosition = .center) {
    guard let _ = view else {
        return
    }
    view?.makeToastActivity(position)
}

public func spin(in view: UIView?, at position: CGPoint) {
    guard let _ = view else {
        return
    }
    view?.makeToastActivity(position)
}

public func spin(in view: UIView?, stop: Bool) {
    guard let _ = view else {
        return
    }
    if stop {
        view?.hideToastActivity()
    } else {
        spin(in: view)
    }
}
