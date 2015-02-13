//
//  HaiInputView.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/16.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	キーボード中央部の操作画面(1) 牌候補入力
*/
class HaiInputView: BaseOperationView
{
	/// 牌入力候補の変更依頼を受け付けるデリゲート
	var candidateOperationDelegate:CandidateOperationDelegate!
	
	init( frame:CGRect , delegate:CandidateOperationDelegate )
	{
		self.candidateOperationDelegate = delegate
		super.init( frame: frame )
	}
	
	/**
		初期化処理を行います
	*/
	override func setupOperationView()
	{
		// 背景色設定 lightgrey
		self.backgroundColor = UIColor.hexStr("d3d3d3", alpha: 1)
		
		self.setupHaiSelectButtons()
		self.setupSwipe()

		LogUtility.debug( self, log: "setupOperationView")
	}

	/**
		牌ボタン押下時に呼ばれます
		@param sender 押下されたボタン
	*/
	func onPushHaiButton(sender: UIButton!)
	{
		let hai:Hai = Hai( _haiType:HaiType(rawValue: (sender as UIButton).tag)! , _isRed:false )
		self.candidateOperationDelegate.requestAddHai( hai )
		
		LogUtility.debug( self, log: "onPushHaiButton button.tag: \(sender.tag)")
	}
	
	/**
		牌ボタンの長押し時に呼ばれます
		@param sender ジェスチャーオブジェクト
	*/
	func onLongPressHaiButton(sender: UILongPressGestureRecognizer)
	{
		// 指が離れたことを検知
		if( sender.state == UIGestureRecognizerState.Ended )
		{
			// 「赤牌」を有効にして追加依頼する
			let buttonTag = (sender.view?.tag)!
			let hai:Hai = Hai( _haiType:HaiType(rawValue: buttonTag)!, _isRed:true )
			self.candidateOperationDelegate.requestAddHai( hai )
		}

		LogUtility.debug( self, log: "onLongPressHaiButton")
	}
}
