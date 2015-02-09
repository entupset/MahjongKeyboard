//
//  BaseOperationView.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/16.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	キーボード中央部の各種操作画面 ベースクラス
*/
class BaseOperationView: BaseHaiSelectView
{
	/// 入力画面の切り替え依頼を受け付けるデリゲート
	var inputViewChangeDelegate:InputViewChangeDelegate!
	
	/**
		ビューの高さを返します(高さは環境にかかわらず固定)
	*/
	class func getViewHeight() -> CGFloat
	{
		return 170
	}
	
	/**
		初期化処理を行います
		@note 子クラス側で実装される想定です
	*/
	func setupOperationView()
	{
		LogUtility.warning( self, log: "setupOperationView : nop")
	}

	/**
		自身にスワイプ設定を行います
	*/
	func setupSwipe()
	{
		let swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipeGesture:")
		swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
		self.addGestureRecognizer( swipeLeft )
		
		let swipeRight = UISwipeGestureRecognizer(target: self, action: "swipeGesture:")
		swipeRight.direction = UISwipeGestureRecognizerDirection.Right
		self.addGestureRecognizer( swipeRight )
		
		LogUtility.debug( self, log: "setupSwipe")
	}
	
	/**
		スワイプ検知時に呼ばれます
		@param sender  スワイプ情報
	*/
	func swipeGesture(sender: UISwipeGestureRecognizer)
	{
		if (sender.direction == UISwipeGestureRecognizerDirection.Right)
		{
			self.inputViewChangeDelegate.requestInputViewChange( BaseOperationChangeType.moveRight )
			LogUtility.debug( self, log: "swipeGesture : Right")
		}
		else if (sender.direction == UISwipeGestureRecognizerDirection.Left)
		{
			self.inputViewChangeDelegate.requestInputViewChange(BaseOperationChangeType.moveLeft)
			LogUtility.debug( self, log: "swipeGesture : Left")
		}
		else
		{
			LogUtility.warning( self, log: "swipeGesture : direction invalid")
		}
	}

	/**
		スワイプ方向に応じたアニメーションを行います
		@param moveType  ビュー移動方向
	*/
	func swipeAnimation( moveType:BaseOperationChangeType )
	{
		let candidateViewHeight:CGFloat = HaiCandidateView.getViewHeight()
		let swipeDuration:NSTimeInterval = 0.2
		
		if( moveType == BaseOperationChangeType.moveRight )
		{
			self.center = CGPoint(
				x: -( self.frame.width / 2),
				y: candidateViewHeight + ( self.frame.height / 2 ) );
			
			UIView.animateWithDuration( swipeDuration,
				animations:
				{() -> Void in
					self.center = CGPoint(
						x: self.frame.width / 2,
						y: candidateViewHeight + ( self.frame.height / 2 ) );
				},
				completion:
				{(Bool) -> Void in
					LogUtility.debug( self, log: "swipeAnimation : animateWithDuration finished")
				}
			)
		}
		else if( moveType == BaseOperationChangeType.moveLeft )
		{
			self.center = CGPoint(
				x: self.frame.width    + ( self.frame.width / 2 ),
				y: candidateViewHeight + ( self.frame.height / 2 ) );
			
			UIView.animateWithDuration( swipeDuration,
				animations:
				{() -> Void in
					self.center = CGPoint(
						x: self.frame.width / 2,
						y: candidateViewHeight + ( self.frame.height / 2 ) );
				},
				completion:
				{(Bool) -> Void in
					LogUtility.debug( self, log: "swipeAnimation : animateWithDuration finished")
				}
			)
		}
		LogUtility.debug( self, log: "swipeAnimation")
	}
}
