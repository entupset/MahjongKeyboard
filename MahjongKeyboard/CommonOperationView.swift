//
//  CommonOperationView.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/16.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	キーボード下側の共通操作画面
*/
class CommonOperationView: UIView, ModeChangedDelegate
{
	/// 共通操作依頼を受け受けるデリゲード
	var commonOperationDelegate:CommonOperationDelegate!
	
	var nextKeyboardButton: UIButton! //!< 次のキーボードボタン
	var inputModeButton:	UIButton! //!< 入力モード切り替えボタン
	var sortModeButton:		UIButton! //!< 自動整列切り替えボタン
	var backCursolButton:	UIButton! //!< カーソル前移動ボタン
	var forwardCursolButton:UIButton! //!< カーソル後移動ボタン
	var removeWordButton:	UIButton! //!< 文字削除に移動ボタン
	var inputConfirmButton: UIButton! //!< 文字出力ボタン

	var keyRepeatTimer:		NSTimer?  //!< ボタン長押しリピート用タイマ
	
	/**
		ビューの高さを返します(高さは環境にかかわらず固定)
	*/
	class func getViewHeight() -> CGFloat
	{
		return 32
	}
	
	/**
		画面の初期化を行います
	*/
	func setupScreen()
	{
		//背景色設定 whitesmoke
		self.backgroundColor = UIColor.hexStr("f5f5f5", alpha: 1)

		var btnArray = Array<UIButton>()
		
		//------------------
		// 次のキーボードボタン
		self.nextKeyboardButton = UIButton.buttonWithType(.Custom) as UIButton
		let imageNextKeyboardButton = UIImage(named: "common_edit_01.png") as UIImage!
		self.nextKeyboardButton.setImage(imageNextKeyboardButton, forState: .Normal)
		self.nextKeyboardButton.addTarget(self, action: "onPushNextKeyboard", forControlEvents: .TouchUpInside)
		btnArray.append( self.nextKeyboardButton )
		
		//------------------
		// 入力モード切り替えボタン
		self.inputModeButton = UIButton.buttonWithType(.Custom) as UIButton
		let imageinputModeButton = UIImage(named: "common_edit_02.png") as UIImage!
		self.inputModeButton.setImage(imageinputModeButton, forState: .Normal)
		self.inputModeButton.addTarget(self, action: "onPushInputModeChange", forControlEvents: .TouchUpInside)
		btnArray.append( self.inputModeButton )
		
		//------------------
		// 整列有効・無効切り替えボタン
		self.sortModeButton = UIButton.buttonWithType(.Custom) as UIButton
		let imageSortModeButton = UIImage(named: "common_edit_05.png") as UIImage!
		self.sortModeButton.setImage(imageSortModeButton, forState: .Normal)
		self.sortModeButton.addTarget(self, action: "onPushSortModeChange", forControlEvents: .TouchUpInside)
		btnArray.append( self.sortModeButton )

		//------------------
		//カーソル移動 後方 ボタン
		self.backCursolButton = UIButton.buttonWithType(.Custom) as UIButton
		let imageBackCursolButton = UIImage(named: "common_edit_08.png") as UIImage!
		self.backCursolButton.setImage(imageBackCursolButton, forState: .Normal)
		self.backCursolButton.addTarget(self, action: "onPushBackCursol", forControlEvents: .TouchUpInside)
		btnArray.append( self.backCursolButton )
		
		let backCursolLongPressGesture = UILongPressGestureRecognizer(
			target: self, action: "onLongPressBackCursolButton:")
		self.backCursolButton.addGestureRecognizer( backCursolLongPressGesture )

		//------------------
		//カーソル移動 前方 ボタン
		self.forwardCursolButton = UIButton.buttonWithType(.Custom) as UIButton
		let imageForwardCursolButton = UIImage(named: "common_edit_07.png") as UIImage!
		self.forwardCursolButton.setImage(imageForwardCursolButton, forState: .Normal)
		self.forwardCursolButton.addTarget(self, action: "onPushForwardCursol", forControlEvents: .TouchUpInside)
		btnArray.append( self.forwardCursolButton )
		
		let forwardCursolLongPressGesture = UILongPressGestureRecognizer(
			target: self, action: "onLongPressForwardCursolButton:")
		self.forwardCursolButton.addGestureRecognizer( forwardCursolLongPressGesture )
		
		//------------------
		//文字削除 ボタン
		self.removeWordButton = UIButton.buttonWithType(.Custom) as UIButton
		let imageRemoveButton = UIImage(named: "common_edit_06.png") as UIImage!
		self.removeWordButton.setImage(imageRemoveButton, forState: .Normal)
		self.removeWordButton.addTarget(self, action: "onPushRemoveWord", forControlEvents: .TouchUpInside)
		btnArray.append( self.removeWordButton )

		let removeWordLongPressGesture = UILongPressGestureRecognizer(
			target: self, action: "onLongPressRemoveWordButton:")
		self.removeWordButton.addGestureRecognizer( removeWordLongPressGesture )
		
		//------------------
		//入力 ボタン
		self.inputConfirmButton = UIButton.buttonWithType(.Custom) as UIButton
		let imageConfirmButton = UIImage(named: "common_edit_13.png") as UIImage!
		self.inputConfirmButton.setImage(imageConfirmButton, forState: .Normal)
		self.inputConfirmButton.addTarget(self, action: "onPushInputConfirm", forControlEvents: .TouchUpInside)
		btnArray.append( self.inputConfirmButton )
		
		
		//------------------
		// ボタンを配置
		let btnLayoutParameter = self.getButtonLayoutParameter()

		let topoffset:CGFloat = 4
		let commonButtonWidth:CGFloat  = 36
		let commonButtonHeight:CGFloat = 24
		
		for ( index, button ) in enumerate( btnArray )
		{
			let left = btnLayoutParameter.leftMargin +
				( CGFloat(index) * commonButtonWidth ) +
				( CGFloat(index) * btnLayoutParameter.horizontalInterval )
			
			button.frame = CGRectMake( left, topoffset, commonButtonWidth, commonButtonHeight)
			self.addSubview( button )
		}

		LogUtility.debug( self, log: "setupEditKeyboardBtn ")
	}

	/**
		「次のキーボード」ボタン押下時に呼ばれます
	*/
	func onPushNextKeyboard()
	{
		self.commonOperationDelegate.requestNextKeuboard()

		LogUtility.debug( self, log: "onPushNextKeyboard called")
	}
	
	/**
		「入力モード変更」ボタン押下時に呼ばれます
	*/
	func onPushInputModeChange()
	{
		self.commonOperationDelegate.requestTextOutputModeChange()

		LogUtility.debug( self, log: "onPushInputModeChange called")
	}
	
	/**
		「整列有効・無効切り替え」ボタン押下時に呼ばれます
	*/
	func onPushSortModeChange()
	{
		self.commonOperationDelegate.requestSortModeChange()
		
		LogUtility.debug( self, log: "onPushSortModeChange ")
	}
	
	/**
		「カーソル前移動」ボタン押下時に呼ばれます
	*/
	func onPushBackCursol()
	{
		self.commonOperationDelegate.requestCursolPositionChange(-1)
		
		LogUtility.debug( self, log: "onPushBackCursol ")
	}

	/**
		「カーソル前移動」ボタン長押し時に呼ばれます
	*/
	func onLongPressBackCursolButton(sender: UILongPressGestureRecognizer)
	{
		self.onLongPress( sender, selectorName: "onPushBackCursol")

		LogUtility.debug( self, log: "onLongPressBackCursolButton ")
	}

	/**
		「カーソル後ろ移動」ボタン押下時に呼ばれます
	*/
	func onPushForwardCursol()
	{
		self.commonOperationDelegate.requestCursolPositionChange(1)
		
		LogUtility.debug( self, log: "onPushForwardCursol ")
	}
	
	/**
		「カーソル後ろ移動」ボタン長押し時に呼ばれます
	*/
	func onLongPressForwardCursolButton(sender: UILongPressGestureRecognizer)
	{
		self.onLongPress( sender, selectorName: "onPushForwardCursol")

		LogUtility.debug( self, log: "onLongPressForwardCursolButton ")
	}
	
	/**
		「文字削除」ボタン押下時に呼ばれます
	*/
	func onPushRemoveWord()
	{
		self.commonOperationDelegate.requestRemoveWord()

		LogUtility.debug( self, log: "onLongPressForwardCursolButton ")
	}
	
	/**
		「文字削除」ボタン長押し時に呼ばれます
	*/
	func onLongPressRemoveWordButton(sender: UILongPressGestureRecognizer)
	{
		self.onLongPress( sender, selectorName: "onPushRemoveWord")

		LogUtility.debug( self, log: "onLongPressRemoveWordButton ")
	}
	
	/**
		「確定」ボタン押下時に呼ばれます
	*/
	func onPushInputConfirm()
	{
		self.commonOperationDelegate.requestInputText()

		LogUtility.debug( self, log: "onPushInputConfirm ")
	}
	
	/**
		入力モードの変更後に呼ばれます
		@param HaiInputStringType 変更後の状態
		@see  ModeChangedDelegate
	*/
	func changedInputMode( haiInputStringType:HaiInputStringType )
	{
		var imageinputModeButton:UIImage
		switch( haiInputStringType )
		{
			case HaiInputStringType.simple:
				imageinputModeButton = UIImage(named: "common_edit_02.png") as UIImage!
				break
			case HaiInputStringType.accsiArt1:
				imageinputModeButton = UIImage(named: "common_edit_03.png") as UIImage!
				break
			case HaiInputStringType.accsiArt2:
				imageinputModeButton = UIImage(named: "common_edit_14.png") as UIImage!
				break
			default:
				break
		}
		self.inputModeButton.setImage(imageinputModeButton, forState: .Normal)

		LogUtility.debug( self, log: "changedInputMode ")
	}

	/**
		自動整列の有効・無効 変更後に呼ばれます
		@param haiSortType 変更後の状態
		@see  ModeChangedDelegate
	*/
	func changedSortMode( haiSortType:HaiSortType)
	{
		var imageSortModeButton : UIImage
		switch(haiSortType)
		{
			case HaiSortType.sort:
				imageSortModeButton = UIImage(named: "common_edit_05.png") as UIImage!
				break
			case HaiSortType.unsort:
				imageSortModeButton = UIImage(named: "common_edit_04.png") as UIImage!
				break
			default:
				break
		}
		self.sortModeButton.setImage(imageSortModeButton, forState: .Normal)

		LogUtility.debug( self, log: "changedSortMode ")
	}
	
	/**
		ボタンの長押し処理(タイマ起動・停止)を行います
		@param sender ジェスチャーオブジェクト
		@param selectorName タイマ経由でコールされる関数名
	*/
	private func onLongPress(sender: UILongPressGestureRecognizer, selectorName:String )
	{
		if(sender.state == UIGestureRecognizerState.Began)
		{
			//長押し開始を検知
			self.keyRepeatTimer = NSTimer.scheduledTimerWithTimeInterval(
				0.1, target: self,
				selector: Selector(selectorName),
				userInfo: nil, repeats: true)
		}
		else if(sender.state == UIGestureRecognizerState.Ended)
		{
			//長押し終了を検知
			self.keyRepeatTimer?.invalidate()
		}
	}
	
	/**
		ボタンの配置位置(左端・ボタン間隔)をデバイスに応じた値で返します
		@return tuple leftMargin 左端
		@return tuple horizontalInterval ボタン間隔
	*/
	private func getButtonLayoutParameter() -> (leftMargin: CGFloat, horizontalInterval: CGFloat )
	{
		let deviceType:DeviceType = DeviceUtility.getDeviceType()
		
		var leftMargin:CGFloat = 0
		var horizontalInterval:CGFloat = 8
		
		if( deviceType == DeviceType.iPhone4s || deviceType == DeviceType.iPhone5 )
		{
			leftMargin = 4
			horizontalInterval = 9
		}
		else if( deviceType == DeviceType.iPhone6 )
		{
			leftMargin = 24
			horizontalInterval = 13
		}
		else if( deviceType == DeviceType.iPhone6Plus )
		{
			leftMargin = 28
			horizontalInterval = 18
		}
		else
		{
			leftMargin = 4
			horizontalInterval = 8
		}
		return ( leftMargin, horizontalInterval )
	}
}

