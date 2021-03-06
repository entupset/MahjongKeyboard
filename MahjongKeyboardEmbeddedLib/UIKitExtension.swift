//
//  UIKitExtension.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/02/04.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	UIKit の拡張を行う実装をこのソースにまとめる
*/

extension UIColor
{
	/*
	16進数で UIColor を指定
	http://qiita.com/reoy/items/a4223cebf312beeed6e9
	を使わせていただきました
	*/
	class func hexStr (var hexStr : NSString, var alpha : CGFloat) -> UIColor
	{
		hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
		let scanner = NSScanner(string: hexStr)
		var color: UInt32 = 0
		if scanner.scanHexInt(&color) {
			let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
			let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
			let b = CGFloat(color & 0x0000FF) / 255.0
			return UIColor(red:r,green:g,blue:b,alpha:alpha)
		} else {
			print("invalid hex string")
			return UIColor.whiteColor();
		}
	}
}
