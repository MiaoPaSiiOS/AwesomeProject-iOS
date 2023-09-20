//
//  CGRect+Extension.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/8/16.
//

import Foundation

extension CGRect {
    func containsVisibleRect(_ rect: CGRect) -> Bool {
        let intersection = intersection(rect)//创建一个只包含两个公共值的新集合
        return (intersection.width > 0 && intersection.height > 0)
    }
}
