//
//  SpriteImageView.swift
//  SpriteImageView
//
//  Created by Hideki Matsuoka on 2018/06/30.
//  Copyright © 2018年 Hideki Matsuoka. All rights reserved.
//

import UIKit

public final class SpriteImageView: UIScrollView {
	private var imageView: UIImageView?
	private var meta: SpriteImageMeta?
	private var sourceImageSize: CGSize?

	private var index: UInt = 0 {
		didSet {
			self.updateViewPort(animated: false)
		}
	}

	public func setup(source: UIImage, meta: SpriteImageMeta) {
		defer { layoutIfNeeded() }

		subviews.forEach { $0.removeFromSuperview() }
		isScrollEnabled = false
		showsVerticalScrollIndicator = false
		showsHorizontalScrollIndicator = false

		let view = UIImageView(image: source)
		addSubview(view)

		self.sourceImageSize = source.size
		self.imageView = view
		self.meta = meta
	}

	public func show(index: UInt) {
		guard let meta = meta, meta.availableIndex.contains(index) else { return }
		updateLayout()
		self.index = index
	}
}

private extension SpriteImageView {
	func updateViewPort(animated: Bool) {
		guard let meta = meta else { return }
		let targetRow = index / meta.matrix.columns
		let targetColumn = index % meta.matrix.columns

		let scaleX: CGFloat = frame.width / meta.unitSize.width
		let scaleY: CGFloat = frame.height / meta.unitSize.height
		let targetX = CGFloat(targetColumn) * meta.unitSize.width * scaleX
		let targetY = CGFloat(targetRow) * meta.unitSize.height * scaleY

		setContentOffset(CGPoint.init(x: targetX, y: targetY), animated: animated)
	}

	func updateLayout() {
		guard let meta = meta
			, let imageView = imageView
			, let sourceSize = sourceImageSize else { return }
		defer { layoutIfNeeded() }

		let scale: CGFloat = frame.width / meta.unitSize.width
		let originalSize = sourceSize * scale

		imageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint(item: imageView,
			attribute: .width,
			relatedBy: .equal,
			toItem: nil,
			attribute: .width,
			multiplier: 1,
			constant: originalSize.width).isActive = true

		NSLayoutConstraint(item: imageView,
			attribute: .height,
			relatedBy: .equal,
			toItem: nil,
			attribute: .height,
			multiplier: 1,
			constant: originalSize.height).isActive = true

		NSLayoutConstraint(item: imageView,
			attribute: .top,
			relatedBy: .equal,
			toItem: self,
			attribute: .top,
			multiplier: 1,
			constant: 0).isActive = true

		NSLayoutConstraint(item: imageView,
			attribute: .leading,
			relatedBy: .equal,
			toItem: self,
			attribute: .leading,
			multiplier: 1,
			constant: 0).isActive = true

		self.contentSize = imageView.frame.size * scale
	}
}

fileprivate func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
	return CGSize.init(width: lhs.width * rhs, height: lhs.height * rhs)
}
