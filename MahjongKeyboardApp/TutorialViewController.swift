//
//  TutorialViewController.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/23.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	使い方解説画面
*/
class TutorialViewController: UIViewController
{
	/// 使い方画像
	var currentImageView:UIImageView = UIImageView()
	
	/// 現在表示中のページインデックス
	var currentIndex:Int = 0
	
	/// 前のページボタン
	var buttonPrev:UIButton = UIButton()

	/// 次のページボタン
	var buttonNext:UIButton = UIButton()
	
	/*
		ビュー表示完了後に呼ばれます
		@see UIViewController
	*/
	override func viewDidLoad()
	{
		self.title = "使い方"
		self.view.backgroundColor = UIColor.hexStr("F9F9F9", alpha: 1)

		self.setupTutorialImage()
		self.setupButtons()
		
		LogUtility.debug( self, log: "viewDidLoad")
	}
	
	/*
		使い方画像を表示します
	*/
	private func setupTutorialImage()
	{
		self.currentImageView.removeFromSuperview()
		var resourceName :String = self.getCurrentResourceName()
		var image = UIImage(named: resourceName) as UIImage!

		var imageRect = self.getTutorialImageRect( image )
		self.currentImageView = UIImageView( frame: imageRect )

		self.currentImageView.image = image
		self.view.addSubview( self.currentImageView )

		LogUtility.debug( self, log: "setupTutorialImage")
	}
	
	/*
		使い方画像の実表示サイズを算出します
		@param  image  使い方画像
		@return  実表示サイズ
	*/
	private func getTutorialImageRect( image:UIImage ) -> CGRect
	{
		let navBarHeight: CGFloat  = (self.navigationController?.navigationBar.frame.size.height)!
		let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.height
		let offsetHeight: CGFloat = navBarHeight + statusBarHeight

		let widthRate = self.view.frame.width / image.size.width

		let tutorialImageRect =
		CGRectMake( 0, offsetHeight ,
			image.size.width * widthRate, image.size.height * widthRate )
		
		return tutorialImageRect
	}
	
	/*
		画像ファイル名を返します
		@return  画像ファイル名を返します
	*/
	private func getCurrentResourceName() -> String
	{
		let currentResourceName = NSString(format: "tutorial_%02d.png", self.currentIndex)
		return currentResourceName
	}
	
	/*
		ボタンをビュー上に配置します
	*/
	private func setupButtons()
	{
		self.buttonPrev.removeFromSuperview()

		let buttonBottomOffset:CGFloat = 10
		let buttonOffset = self.getButtonOffset()
		
		if( self.isDisplayPrevButton() )
		{
			self.buttonPrev = UIButton.buttonWithType(.System) as UIButton
			
			let itemName = "前のページ"
			self.buttonPrev.setTitle(NSLocalizedString(itemName, comment: itemName), forState: .Normal)
			self.buttonPrev.addTarget(self,
				action: "onButtonPrev",
				forControlEvents: .TouchUpInside)

			Layout.addSubView(self.buttonPrev, superview: self.view )
				.bottom( buttonBottomOffset ).fromSuperviewBottom()
				.left( buttonOffset.prevButtonLeftMargin ).fromSuperviewLeft()
		}

		self.buttonNext.removeFromSuperview()

		if( self.isDisplayNextButton() )
		{
			self.buttonNext = UIButton.buttonWithType(.System) as UIButton
			
			let itemNameNext = "次のページ"
			self.buttonNext.setTitle(NSLocalizedString(itemNameNext, comment: itemNameNext), forState: .Normal)
			self.buttonNext.addTarget(self,
				action: "onButtonNext",
				forControlEvents: .TouchUpInside)

			Layout.addSubView(self.buttonNext, superview: self.view )
				.bottom( buttonBottomOffset ).fromSuperviewBottom()
				.right( buttonOffset.nextButtonRightMargin ).fromSuperviewRight()
		}
		
		LogUtility.debug( self, log: "setupButtons")
	}

	/*
		前のページボタンを表示すべきか判定します
	*/
	private func isDisplayPrevButton() -> Bool
	{
		var isDisplay = true
		if( 0 == self.currentIndex )
		{
			isDisplay = false
		}
		return isDisplay
	}

	/*
		次のページボタンを表示すべきか判定します
	*/
	private func isDisplayNextButton() -> Bool
	{
		var isDisplay = true
		if( self.currentIndex == ( TutorialMenuController.getMenuList().count - 1 ) )
		{
			isDisplay = false
		}
		return isDisplay
	}

	/*
		前のページボタン押下時の処理を行います
	*/
	func onButtonPrev()
	{
		if( 0 < self.currentIndex )
		{
			self.currentIndex--
			self.setupTutorialImage()
			self.setupButtons()
		}
		LogUtility.debug( self, log: "onButtonPrev")
	}

	/*
		次のページボタン押下時の処理を行います
	*/
	func onButtonNext()
	{
		if( self.currentIndex < TutorialMenuController.getMenuList().count )
		{
			self.currentIndex++
			self.setupTutorialImage()
			self.setupButtons()
		}
		LogUtility.debug( self, log: "onButtonNext")
	}
	
	/**
		ボタンの配置位置(左端・右端の間隔)をデバイスに応じた値で返します
		@return tuple prevButtonLeftMargin  左端から前へボタンまでの距離
		@return tuple nextButtonRightMargin 右端から次へボタンまでの距離
	*/
	private func getButtonOffset() -> (prevButtonLeftMargin: CGFloat, nextButtonRightMargin: CGFloat )
	{
		let deviceType:DeviceType = DeviceUtility.getDeviceType()
		
		var prevButtonLeftMargin:CGFloat = 0
		var nextButtonRightMargin:CGFloat = 8
		
		if( deviceType == DeviceType.iPhone4s || deviceType == DeviceType.iPhone5 )
		{
			prevButtonLeftMargin = 10
			nextButtonRightMargin = 10
		}
		else if( deviceType == DeviceType.iPhone6 )
		{
			prevButtonLeftMargin = 20
			nextButtonRightMargin = 20
		}
		else if( deviceType == DeviceType.iPhone6Plus )
		{
			prevButtonLeftMargin = 30
			nextButtonRightMargin = 30
		}
		else
		{
			prevButtonLeftMargin = 10
			nextButtonRightMargin = 10
		}
		return ( prevButtonLeftMargin, nextButtonRightMargin )
	}
	
}
