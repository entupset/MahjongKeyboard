//
//  TutorialMenuController.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/23.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	使い方一覧画面
*/
class TutorialMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	///メニュー表示用テーブルビュー
	var tableView : UITableView!

	///メニューの文字列リスト
	var menuList : [ String ] = []

	/*
		メニューの文字列リスト初期値を返します	
	*/
	class func getMenuList() -> [ String ]
	{
		var menuList : [ String ] =	[
			"ご利用前の設定",
			"麻雀キーボードとは",
			"画面の切替(スワイプ)",
			"局の状況を設定",
			"入力履歴",
			"麻雀用語入力",
			"入力形式",
			"牌の並び替え",
			"その他の操作"
		]
		return menuList
	}
	
	/*
		ビュー表示完了後に呼ばれます
		@see UIViewController
	*/
	override func viewDidLoad()
	{
		self.title = "使い方一覧"
		self.view.backgroundColor = UIColor.greenColor()
		
		self.menuList = TutorialMenuController.getMenuList()
		
		let navBarHeight: CGFloat  = (self.navigationController?.navigationBar.frame.size.height)!
		let statusBarHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.height
		let offsetHeight: CGFloat = navBarHeight + statusBarHeight
		
		self.tableView = UITableView(frame: CGRectMake(0, 0 , self.view.frame.size.width, self.view.frame.size.height ))
		self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "data")
		
		self.tableView.dataSource = self
		self.tableView.delegate = self
		
		self.view.addSubview(self.tableView)
		
		LogUtility.debug( self, log: "viewDidLoad")
	}
	
	/**
		セルの行数を返します
		@see  UITableViewDataSource
	*/
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return self.menuList.count
	}
	
	/**
		指定されたインデックスのセルを生成します
		@see  UITableViewDelegate
	*/
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cellId = "cell"
		var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell
		if( cell == nil )
		{
			cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:cellId)
		}
		cell?.textLabel?.text = self.menuList[ indexPath.row ]
		return cell!
	}
	
	/**
		セルが選択された時に呼ばれます
		@see  UITableViewDelegate
	*/
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		var myViewController: TutorialViewController =	TutorialViewController()
		myViewController.currentIndex = indexPath.row
		self.navigationController?.pushViewController(myViewController, animated: true)
		
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

		LogUtility.debug( self, log: "didSelectRowAtIndexPath")
	}
}

