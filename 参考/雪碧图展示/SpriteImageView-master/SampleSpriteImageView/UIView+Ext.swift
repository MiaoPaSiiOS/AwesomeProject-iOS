//
//  UIView+Ext.swift
//  SampleSpriteImageView
//
//  Created by Hideki Matsuoka on 2018/06/30.
//  Copyright © 2018年 Hideki Matsuoka. All rights reserved.
//

import UIKit

public extension UIView {
	public func addMarginConstraints(margin: CGFloat = 0) {
		guard let superView = self.superview else { return }
		translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint(item: self,
			attribute: .top,
			relatedBy: .equal,
			toItem: superView,
			attribute: .top,
			multiplier: 1,
			constant: margin).isActive = true

		NSLayoutConstraint(item: self,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: superView,
			attribute: .bottom,
			multiplier: 1,
			constant: margin).isActive = true

		NSLayoutConstraint(item: self,
			attribute: .leading,
			relatedBy: .equal,
			toItem: superView,
			attribute: .leading,
			multiplier: 1,
			constant: margin).isActive = true

		NSLayoutConstraint(item: self,
			attribute: .trailing,
			relatedBy: .equal,
			toItem: superView,
			attribute: .trailing,
			multiplier: 1,
			constant: margin).isActive = true
	}
}
