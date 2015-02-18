//
//  WiktionaryDetailDoraSelectView.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/16.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	局の詳細情報 風
*/
enum HaiSelectMode : Int
{
	case Dora	//!< ドラ選択
	case Tsumo	//!< ツモ選択
}

/**
	牌選択ビュー
*/
class WiktionaryDetailDoraSelectView: BaseHaiSelectView
{
	/// 選択モード
	let haiSelectMode:HaiSelectMode = HaiSelectMode.Dora
	
	/// 局詳細の変更依頼を受け付けるデリゲート
	let detailOperationDelegate:DetailOperationDelegate!
	
	init( viewRect: CGRect, selectMode:HaiSelectMode, operationDelegate:DetailOperationDelegate )
	{
		self.haiSelectMode = selectMode
		self.detailOperationDelegate = operationDelegate
		super.init( frame:viewRect )
	}
	
	/**
		画面描画時に呼ばれます
	*/
	override func drawRect(rect: CGRect)
	{
		self.setupHaiSelectButtons()
		
		LogUtility.debug( self, log: "drawRect")
	}

	/**
		牌ボタン押下時に呼ばれます
		@param sender 押下されたボタン
	*/
	func onPushHaiButton( sender: UIButton! )
	{
		// ドラの変更を依頼
		let haiType:HaiType = HaiType( rawValue: sender.tag )!
		let hai = Hai( _haiType:haiType, _isRed:false )
		
		if( self.haiSelectMode == HaiSelectMode.Dora )
		{
			self.detailOperationDelegate.requestChanhgeDetailDora( hai )
		}
		else if( self.haiSelectMode == HaiSelectMode.Tsumo )
		{
			self.detailOperationDelegate.requestChanhgeDetailTsumo( hai )
		}

		// 自身を閉じるアニメーショ開始
		self.center = CGPoint(
			x: ( self.frame.width  / 2 ),
			y: ( self.frame.height / 2 ) )
		
		UIView.animateWithDuration( 0.2,
			animations:
			{() -> Void in
				self.center = CGPoint(
					x: self.frame.width / 2,
					y: self.frame.height + ( self.frame.height / 2 ) );
			},
			completion:
			{(Bool) -> Void in

				//自身を閉じる
				self.removeFromSuperview()
			}
		)

		LogUtility.debug( self, log: "onPushHaiButton button.tag: \(sender.tag)")
	}
	
}