//
//  HaiHistoryTableViewCell.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/18.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	入力履歴のテーブルビューで使用するカスタムセル
*/
class HaiHistoryTableViewCell: UITableViewCell
{
	/// 牌の画像リスト
	var haiImageViewList  = Array< UIImageView >()
	
	/// 局の詳細を表示するラベル
	var detailLabel: UILabel?
	
	/**
		セルの表示を更新
		@param 牌の入力状況
	*/
	func updateCell( situation:MahjongSituation )
	{
		for imageView in self.haiImageViewList
		{
			imageView.removeFromSuperview()
		}
		self.haiImageViewList.removeAll(keepCapacity: false)
		
		// 牌の画像表示
		let leftOffset:CGFloat = 5
		for ( index, hai ) in enumerate( situation.haiList )
		{
			var resourceName :String = hai.getResourceName()
			var image = UIImage(named: resourceName) as UIImage!
			var imageView = UIImageView(frame: CGRectMake(leftOffset+CGFloat(index*24),10,24,36))
			imageView.image = image
			self.haiImageViewList.append(imageView)
			self.addSubview(imageView)
		}
		
		// ラベルに局の詳細を表示
		self.detailLabel?.removeFromSuperview()
		let detailString:String = MahjongKeyboardTextUtility.getOutputDetail( situation )
		self.detailLabel = UILabel(frame: CGRectMake(5,60,300,10))
		if( situation.isDetailOutput )
		{
			self.detailLabel?.textColor = UIColor.blackColor()
		}
		else
		{
			self.detailLabel?.textColor = UIColor.grayColor()
		}
		self.detailLabel?.text = detailString
		self.addSubview(self.detailLabel!)
	}
}
