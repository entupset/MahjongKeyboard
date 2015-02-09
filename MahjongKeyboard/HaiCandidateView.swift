//
//  HaiCandidateView.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/16.
//  Copyright (c) 2015年 entupset. All rights reserved.
//


import UIKit

/**
	キーボード上部の牌入力候補画面
*/
class HaiCandidateView: UIScrollView, CandidateChangedDelegate
{
	/// 牌入力候補の変更依頼を受け付けるデリゲート
	var candidateOperationDelegate:CandidateOperationDelegate!
	
	var btnCandidate: Array< UIButton! > = [] //!< 現在の牌入力候補
	var labelIndex: Array< UILabel! > = []    //!< 牌の番号を表示するラベル
	
	/**
		ビューの高さを返します(高さは環境にかかわらず固定)
	*/
	class func getViewHeight() -> CGFloat
	{
		return 58
	}
	
	/**
		牌入力候補の変更後に呼ばれます
		@param candidate  変更後の牌入力候補
		@see  HaiChangeDelegate
	*/
	func changedCandidate( candidate: Array<Hai> )
	{
		//背景色設定
		self.backgroundColor = UIColor.hexStr("a9a9a9", alpha: 1)

		self.claerControlls()

		let haiImageSize = MahjongKeyboardConstant.getHaiImageSize()
		
		var leftMargin:CGFloat = 2
		var viewWidth:CGFloat = leftMargin
		
		for ( index, hai ) in enumerate( candidate )
		{
			viewWidth += haiImageSize.width

			//------------------
			//牌入力候補ボタン作成
			let resourceName :String = hai.getResourceName()
			let image = UIImage(named: resourceName) as UIImage!
			let haiButton = UIButton()
			haiButton.setImage(image, forState: .Normal)
			haiButton.addTarget(
				self,
				action: Selector("onPushHaiButton:"),
				forControlEvents: .TouchUpInside)
			haiButton.tag = index
			
			let btnTop:CGFloat  = 5
			let btnLeft:CGFloat = leftMargin + ( CGFloat(index) * haiImageSize.width )
			Layout.addSubView(haiButton, superview: self )
				.top(btnTop).fromSuperviewTop()
				.left(btnLeft).fromSuperviewLeft()
			
			self.btnCandidate.append( haiButton )

			//------------------
			//番号表示ラベル作成
			let lebelLeft:CGFloat   = leftMargin + ( CGFloat(index) * haiImageSize.width )
			let lebelTop:CGFloat    = 42
			let lebelWidth:CGFloat  = 24
			let lebelHeight:CGFloat = 12

			let lebelRect = CGRect(
				x: lebelLeft, y: lebelTop,
				width: lebelWidth, height: lebelHeight )
			
			let label = UILabel( frame:lebelRect )
			
			label.text = "\(index+1)"
			label.textAlignment = NSTextAlignment.Center
			label.textColor = UIColor.whiteColor()
			label.font = UIFont.systemFontOfSize(12)
			self.addSubview(label)
			
			self.labelIndex.append( label )
		}

		if( candidate.count == 0 )
		{
			// TODO: 起動直後のみ、ボタンがひとつもない状態だとスワイプアニメーションが効かなくなる
			// 原因は後日調査。とりあえずダミーのボタンを載せる
			self.setDummyButton()
		}
		
		//------------------
		//横スクロール領域設定
		if( viewWidth < self.frame.width )
		{
			viewWidth = self.frame.width
		}
		self.contentSize = CGSizeMake( viewWidth, self.frame.height)
		
		LogUtility.debug( self, log: "changeCandidate finifhed")
	}

	/**
		牌候補ボタン押下時に呼ばれます
		@param sender 押下対象のボタン
	*/
	func onPushHaiButton(sender: UIButton!)
	{
		let button: UIButton = sender
		let removeIndex = (sender as UIButton).tag
		self.candidateOperationDelegate.requestRemoveHaiFromIndex( removeIndex )
		
		LogUtility.debug( self, log: "onPushHaiButton finifhed")
	}

	/**
		画面上のボタン・ラベルを破棄します
	*/
	private func claerControlls()
	{
		// 現在の牌入力候補 クリア
		for btn in self.btnCandidate
		{
			btn.removeFromSuperview()
		}
		self.btnCandidate.removeAll(keepCapacity: true)
		
		// 牌の番号を表示するラベル クリア
		for label in self.labelIndex
		{
			label.removeFromSuperview()
		}
		self.labelIndex.removeAll(keepCapacity: true)
	}
	
	/**
		ダミーボタンを設定します 
		@note スワイプが動作しない問題回避用の暫定処理
	*/
	private func setDummyButton()
	{
		let haiButton = UIButton()
		haiButton.backgroundColor = UIColor.clearColor();
		
		let btnLeft:CGFloat = 1
		let btnTop:CGFloat  = 1
		Layout.addSubView(haiButton, superview: self )
		.top(btnTop).fromSuperviewTop()
		.left(btnLeft).fromSuperviewLeft()
		self.btnCandidate.append( haiButton )
	}
}
