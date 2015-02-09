//
//  WiktionaryDetailDoraSelectView.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/16.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	ドラ選択ビュー
*/
class WiktionaryDetailDoraSelectView: BaseHaiSelectView
{
	/// 局詳細の変更依頼を受け付けるデリゲート
	var detailOperationDelegate:DetailOperationDelegate!
	
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
		self.detailOperationDelegate.requestChanhgeDetailDora( hai )

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