//
//  SpriteImageMeta.swift
//  SpriteImageView
//
//  Created by Hideki Matsuoka on 2018/06/30.
//  Copyright © 2018年 Hideki Matsuoka. All rights reserved.
//

import Foundation

public struct SpriteImageMeta {
	public let matrix: SpriteImageMatrix
	public let unitSize: CGSize

	public init(matrix: SpriteImageMatrix, unitSize: CGSize) {
		self.matrix = matrix
		self.unitSize = unitSize
	}

	public var availableIndex: ClosedRange<UInt> {
		return 0...(matrix.columns * matrix.rows - 1)
	}
}
