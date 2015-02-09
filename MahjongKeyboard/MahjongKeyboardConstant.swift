//
//  MahjongKeyboardConstant.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/02/04.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	キーボードアプリ全体で使用する定数を返すユーティリティクラス
*/
class MahjongKeyboardConstant
{
	/**
		牌の画像サイズを返す
		@return 画像サイズ
	*/
	class func getHaiImageSize() -> CGSize
	{
		let imageSize:CGSize = CGSizeMake(24, 36)
		return imageSize
	}

	/**
		画面下の共通ボタンの画像サイズを返す
		@return 画像サイズ
	*/
	class func getCommonButtonImageSize() -> CGSize
	{
		let imageSize:CGSize = CGSizeMake(36, 24)
		return imageSize
	}
	
	/**
		数字ボタン(局目・順目 の指定用)の画像サイズを返す
		@return 画像サイズ
	*/
	class func getNumberButtonImageSize() -> CGSize
	{
		let imageSize:CGSize = CGSizeMake(24, 24)
		return imageSize
	}
}