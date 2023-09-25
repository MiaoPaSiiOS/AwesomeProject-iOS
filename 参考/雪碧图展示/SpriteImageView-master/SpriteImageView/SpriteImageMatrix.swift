//
//  SpriteImageMatrix.swift
//  SpriteImageView
//
//  Created by Hideki Matsuoka on 2018/06/30.
//  Copyright © 2018年 Hideki Matsuoka. All rights reserved.
//

import Foundation

public struct SpriteImageMatrix {
	let rows: UInt
	let columns: UInt

	public init(rows: UInt, columns: UInt) {
		assert(rows != 0)
		assert(columns != 0)
		self.rows = rows
		self.columns = columns
	}
}
