//
//  ViewController.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/12.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	トップ画面
*/
class StartMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	///メニュー表示用テーブルビュー
	var tableView : UITableView!

	///メニューの文字列リスト
	var menuList : [ String ] = [ "使い方" , "このアプリについて"  ]
	
	/*
		ビュー表示完了後に呼ばれます
		@see UIViewController
	*/
	override func viewDidLoad()
	{
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		self.title = "麻雀キーボード"
		
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

	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()

		LogUtility.debug( self, log: "didReceiveMemoryWarning")
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
		if( indexPath.row == 0)
		{
			let nextViewController: TutorialMenuController = TutorialMenuController()
			self.navigationController?.pushViewController( nextViewController, animated: true)
		}
		else if( indexPath.row == 1)
		{
			let nextViewController: AboutMenuViewController = AboutMenuViewController()
			self.navigationController?.pushViewController( nextViewController, animated: true )
		}
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

		LogUtility.debug( self, log: "didSelectRowAtIndexPath")
	}

}

