//
//  HaiHistoryView.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/16.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	キーボード中央部の操作画面(3) 入力履歴
*/
class HaiHistoryView: BaseOperationView, UITableViewDelegate, UITableViewDataSource, SituationHistoryChangedDelegate
{
	/// 入力履歴の変更依頼を受け付けるデリゲート
	var situationHistoryOperationDelegate:SituationHistoryOperationDelegate!
	
	/// 入力履歴
	var situationHistory:Array<MahjongSituation> = Array<MahjongSituation>()

	/// テーブルビュー
	var tableView : UITableView!
	
	/**
		初期化処理を行います
	*/
	override func setupOperationView()
	{
		self.backgroundColor = UIColor.whiteColor()

		// スワイプ設定
		self.setupSwipe()
		
		self.tableView = UITableView(frame: CGRectMake(0, 0 , self.frame.size.width, self.frame.size.height))
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "data")
		self.addSubview(self.tableView)
		
		self.situationHistoryOperationDelegate.requestCurrentSituationHistory()
		
		LogUtility.debug( self, log: "setupOperationView")
	}

	/**
		入力履歴の変更後に呼ばれます
		@param candidate  変更後の入力履歴
		@see  SituationHistoryChangedDelegate
	*/
	func changedSituationHistory( situationHistory:Array<MahjongSituation> )
	{
		self.situationHistory = situationHistory
		
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.tableView.reloadData()

		LogUtility.debug( self, log: "changedSituationHistory")
	}
	
	/**
		セルの行数を返します
		@see  UITableViewDataSource
	*/
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return situationHistory.count
	}
	
	/**
		指定されたインデックスのセルを生成します
		@see  UITableViewDelegate
	*/
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cellId = "HaiHistoryTableViewCell"
		var cell:HaiHistoryTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? HaiHistoryTableViewCell
		if( cell == nil )
		{
			cell = HaiHistoryTableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:cellId)
		}
		cell?.updateCell( self.situationHistory[indexPath.row] )
		return cell!
	}

	/**
		セルの高さを指定します
		@see  UITableViewDelegate
	*/
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
	{
		return 80
	}
	
	/**
		セルが選択された時に呼ばれます
		@see  UITableViewDelegate
	*/
	func tableView( tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath )
	{
		self.situationHistoryOperationDelegate.requestHistoryToCurrent( indexPath.row )

		self.tableView.deselectRowAtIndexPath( indexPath, animated: true )

		LogUtility.debug( self, log: "didSelectRowAtIndexPath")
	}
}


