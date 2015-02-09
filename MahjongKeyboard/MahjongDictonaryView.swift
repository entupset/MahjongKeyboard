//
//  MahjongDictonaryView.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/16.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	キーボード中央部の操作画面(4) 麻雀用語
*/
class MahjongDictonaryView: BaseOperationView
{
	/// 共通操作の変更依頼を受け付けるデリゲート
	var commonOperationDelegate:CommonOperationDelegate!
	
	/// 用語ボタン群
	var mahjongDictonaryWord:Array<String> = []
	
	/**
		初期化処理を行います
	*/
	override func setupOperationView()
	{
		self.backgroundColor = UIColor.whiteColor()
	
		self.mahjongDictonaryWord = MahjongKeyboardTextUtility.getMahjongDictonary()
		self.setupDictionaryButton()
		self.setupSwipe()
		
		LogUtility.debug( self, log: "setupOperationView")
	}
	
	/**
		用語ボタンを生成します
	*/
	func setupDictionaryButton()
	{
		let leftMargin:CGFloat = 6

		var buttonLeft:CGFloat = leftMargin
		var buttonTop:CGFloat  = 0
		var lastWordHeight:CGFloat = 0
		
		for (index, itemName) in enumerate( self.mahjongDictonaryWord )
		{
			let wordButton = UIButton.buttonWithType(.System) as UIButton

			wordButton.setTitle(NSLocalizedString(itemName, comment: itemName), forState: .Normal)
			wordButton.sizeToFit()
			wordButton.setTranslatesAutoresizingMaskIntoConstraints(false)
			wordButton.addTarget(self,
				action: "onPushWord:",
				forControlEvents: .TouchUpInside)
			wordButton.tag = index
			
			let maxSize: CGSize = CGSizeMake(self.bounds.width,self.bounds.height)
			let wordButtonSize: CGSize = wordButton.sizeThatFits(maxSize)

			//println("width: \(wordButtonSize.width)")
			//println("height: \(wordButtonSize.height)")

			let rightOverCheck = buttonLeft + wordButtonSize.width
			if( self.frame.width < rightOverCheck )
			{
				// 幅を超えたら、次の行の先頭から
				buttonLeft = leftMargin
				buttonTop += wordButtonSize.height
			}

			Layout.addSubView(wordButton, superview: self )
				.top( buttonTop ).fromSuperviewTop()
				.left( buttonLeft ).fromSuperviewLeft()

			buttonLeft += wordButtonSize.width
			buttonLeft += leftMargin
			lastWordHeight = wordButtonSize.height
		}
		
		self.contentSize = CGSizeMake(self.frame.width, buttonTop + lastWordHeight)

		LogUtility.debug( self, log: "setupDictionaryButton")
	}
	
	/**
		用語ボタン押下時に呼ばれます
		@param sender 押下されたボタン
	*/
	func onPushWord(sender: UIButton!)
	{
		let title = self.mahjongDictonaryWord[ sender.tag ]
		self.commonOperationDelegate.requestInputTextWithString( title )
		
		LogUtility.debug( self, log: "onPushWord button.tag: \(sender.tag), button.title" + title)
	}
}
