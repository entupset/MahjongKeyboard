//
//  BaseHaiSelectView.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/28.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	牌選択ビュー
*/
class BaseHaiSelectView: UIScrollView
{
	var haiButtons: Array< UIButton! > = []  //!< 牌ボタン群
	
	/**
		入力用の牌ボタン群を生成します
	*/
	func setupHaiSelectButtons()
	{
		self.haiButtons.removeAll( keepCapacity: false )
		
		let arrayHaiCategory:Array<String> = Hai.getHaiCategoryArray()
		let arrayHaiCategoryButtonTag:Array<Int> =
			[	HaiType.manzu_1.rawValue, HaiType.pinzu_1.rawValue,
				HaiType.souzu_1.rawValue, HaiType.other_1.rawValue ]
		
		let btnLayoutParameter = self.getButtonLayoutParameter()
		let imageSize = MahjongKeyboardConstant.getHaiImageSize()
		let imageTopOffset:CGFloat = 5
		let imageHeightInterval:CGFloat = 5
		
		for ( index, haiCategoryName ) in enumerate( arrayHaiCategory )
		{
			var buttonTag = arrayHaiCategoryButtonTag[ index ]

			let haiEndIndex = Hai.getHaiCategoryCount( haiCategoryName )
			for haiIndex in 1...haiEndIndex
			{
				// ボタンに画像・色設定
				//let haiTypeValue:Int = ( buttonTag - 1 + haiIndex )
				//let haiType:HaiType = HaiType( rawValue: haiTypeValue )!
				let haiType:HaiType = HaiType( rawValue: buttonTag )!
				let hai:Hai = Hai( _haiType: haiType, _isRed: false )
				let resourceName = hai.getResourceName()
				
				let image = UIImage( named: resourceName ) as UIImage!
				let haiButton = UIButton.buttonWithType( UIButtonType.Custom ) as UIButton
				haiButton.setImage( image, forState: .Normal )
				haiButton.backgroundColor = UIColor.clearColor();
				
				// ボタンにコールバック設定
				haiButton.addTarget(
					self,
					action: Selector( "onPushHaiButton:"),
					forControlEvents: .TouchUpInside )
				
				let longPressGesture = UILongPressGestureRecognizer(
					target: self, action: "onLongPressHaiButton:" )
				haiButton.addGestureRecognizer( longPressGesture )
				
				// ボタンに識別用のタグ(HaiType)設定
				haiButton.tag = buttonTag
				buttonTag++
				
				// ボタン配置位置を算出
				let btnLeft:CGFloat =
					btnLayoutParameter.leftMargin +
					( CGFloat( haiIndex - 1 ) * ( imageSize.width + btnLayoutParameter.horizontalInterval ) )
				
				let btnTop:CGFloat =
					imageTopOffset +
					( CGFloat( index ) * ( imageSize.height + imageHeightInterval ) )
				haiButton.frame = CGRectMake( btnLeft, btnTop, imageSize.width, imageSize.height )

				Layout.addSubView(haiButton, superview: self )
					.top(btnTop).fromSuperviewTop()
					.left(btnLeft).fromSuperviewLeft()
				
				self.haiButtons.append( haiButton )
			}
		}
		LogUtility.debug( self, log: "setupHaiSelectButtons")
	}

	/**
		ボタンの配置位置(左端・水平ボタン間隔)をデバイスに応じた値で返します
		@return tuple leftMargin 左端
		@return tuple horizontalInterval 水平ボタン間隔
	*/
	private func getButtonLayoutParameter() -> (leftMargin: CGFloat, horizontalInterval: CGFloat )
	{
		let deviceType:DeviceType = DeviceUtility.getDeviceType()
		
		var leftMargin:CGFloat = 0
		var horizontalInterval:CGFloat = 8
		
		if( deviceType == DeviceType.iPhone4s || deviceType == DeviceType.iPhone5 )
		{
			leftMargin = 4
			horizontalInterval = 12
		}
		else if( deviceType == DeviceType.iPhone6 )
		{
			leftMargin = 24
			horizontalInterval = 14
		}
		else if( deviceType == DeviceType.iPhone6Plus )
		{
			leftMargin = 26
			horizontalInterval = 18
		}
		else
		{
			leftMargin = 4
			horizontalInterval = 12
		}
		return ( leftMargin, horizontalInterval )
	}
}
