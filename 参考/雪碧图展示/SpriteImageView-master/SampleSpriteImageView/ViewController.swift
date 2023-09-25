//
//  ViewController.swift
//  SampleSpriteImageView
//
//  Created by Hideki Matsuoka on 2018/06/30.
//  Copyright © 2018年 Hideki Matsuoka. All rights reserved.
//

import UIKit

import SpriteImageView

final class ViewController: UIViewController {

	private struct Constants {
		static var animationDuration = TimeInterval(0.3)

		static var popUpBottomActiveConstant = CGFloat(20)
		static var popUpActiveAlpha = CGFloat(1.0)

		static var popUpBottomInactiveConstant = CGFloat(0)
		static var popUpInactiveAlpha = CGFloat(0)
	}

	@IBOutlet private weak var slider: UISlider!
	@IBOutlet private weak var originalSizeSpriteViewContainer: UIView!
	@IBOutlet private weak var scaledSizeSpriteViewContainer: UIView!
	@IBOutlet private weak var popUpSpriteViewContainer: UIView!

	private let imageMeta = SpriteImageMeta(matrix: SpriteImageMatrix(rows: 10, columns: 10), unitSize: CGSize(width: 80, height: 45))

	weak var originalSizeSpriteImageView: SpriteImageView?
	weak var scaledSizeSpriteImageView: SpriteImageView?
	weak var popUpSpriteImageView: SpriteImageView?

	@IBOutlet weak var popUpCenterAlignmentConstraint: NSLayoutConstraint!
	@IBOutlet weak var popUpBottomConstraint: NSLayoutConstraint!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		sliderChanged(slider)
	}

	@IBAction func sliderChanged(_ sender: UISlider) {
		let index = UInt(sender.value)
		show(index: index)
		updatePopupPosition(sender)
	}
}

private extension ViewController {
	func setupViews() {
		setupScaledSizeSpriteView()
		setupOriginalSizeSpriteView()
		setupPopUpSpriteView()

		slider.maximumValue = Float(imageMeta.availableIndex.upperBound)
		slider.minimumValue = Float(imageMeta.availableIndex.lowerBound)
		slider.value = 0

		slider.addTarget(self, action: #selector(startSeek), for: .touchDown)
		slider.addTarget(self, action: #selector(endSeek), for: .touchUpInside)
		slider.addTarget(self, action: #selector(endSeek), for: .touchUpOutside)
	}

	func setupOriginalSizeSpriteView() {
		let originalSizeSpriteImageView = SpriteImageView()
		let image = UIImage(named: "SpriteSource")!
		originalSizeSpriteViewContainer.addSubview(originalSizeSpriteImageView)
		originalSizeSpriteImageView.addMarginConstraints()
		originalSizeSpriteImageView.setup(source: image, meta: imageMeta)
		self.originalSizeSpriteImageView = originalSizeSpriteImageView
	}

	func setupScaledSizeSpriteView() {
		let scaledSizeSpriteImageView = SpriteImageView()
		let image = UIImage(named: "SpriteSource")!
		scaledSizeSpriteViewContainer.addSubview(scaledSizeSpriteImageView)
		scaledSizeSpriteImageView.addMarginConstraints()
		scaledSizeSpriteImageView.setup(source: image, meta: imageMeta)
		self.scaledSizeSpriteImageView = scaledSizeSpriteImageView
	}

	func setupPopUpSpriteView() {
		let popUpSpriteImageView = SpriteImageView()
		let image = UIImage(named: "SpriteSource")!
		popUpSpriteViewContainer.addSubview(popUpSpriteImageView)
		popUpSpriteImageView.addMarginConstraints()
		popUpSpriteImageView.setup(source: image, meta: imageMeta)
		self.popUpSpriteImageView = popUpSpriteImageView
		popUpBottomConstraint.constant = Constants.popUpBottomInactiveConstant
		popUpSpriteViewContainer.alpha = Constants.popUpInactiveAlpha
	}

	func show(index: UInt) {
		scaledSizeSpriteImageView?.show(index: index)
		originalSizeSpriteImageView?.show(index: index)
		popUpSpriteImageView?.show(index: index)
	}

	func updatePopupPosition(_ sender: UISlider) {
		defer { popUpSpriteImageView?.layoutIfNeeded() }
		let width = sender.frame.width
		let halfIndex = sender.maximumValue / 2.0
		let position = sender.value - halfIndex
		let positionToConstant = width / CGFloat((sender.maximumValue - sender.minimumValue)) * CGFloat(position)

		popUpCenterAlignmentConstraint.constant = positionToConstant
	}
}


// MARK: - Animation to appear and disappear popup thumbnail
extension ViewController {
	@objc func startSeek() {
		showPopup()
	}

	@objc func endSeek() {
		hidePopup()
	}

	func showPopup() {
		popUpBottomConstraint.constant = Constants.popUpBottomActiveConstant

		UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: .curveEaseOut, animations: { [weak self] in
			guard let weakSelf = self else { return }
			defer { weakSelf.view.layoutIfNeeded() }
			weakSelf.popUpSpriteViewContainer.alpha = Constants.popUpActiveAlpha

		}, completion: nil)
	}

	func hidePopup() {
		popUpBottomConstraint.constant = Constants.popUpBottomInactiveConstant

		UIView.animate(withDuration: Constants.animationDuration, delay: 0, options: .curveEaseOut, animations: { [weak self] in
			guard let weakSelf = self else { return }
			defer { weakSelf.view.layoutIfNeeded() }
			weakSelf.popUpSpriteViewContainer.alpha = Constants.popUpInactiveAlpha
		}, completion: nil)
	}
}
