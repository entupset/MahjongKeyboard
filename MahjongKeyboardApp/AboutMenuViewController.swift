//
//  AboutMenuViewController.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/29.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit
import MessageUI

/**
	アプリについて メニュー一覧画面
*/
class AboutMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate
{
	///メニュー表示用テーブルビュー
	var tableView : UITableView!
	
	///メニューの文字列リスト
	var menuList : [ String ] = [ "画像素材について" , "お問い合わせ", "バージョン"]
	
	/*
		ビュー表示完了後に呼ばれます
		@see UIViewController
	*/
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.addVersionStringToMenu()
		
		self.title = "このアプリについて"
		
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
			let nextViewController: AboutDetailViewController = AboutDetailViewController()
			self.navigationController?.pushViewController( nextViewController, animated: true )
		}
		else if( indexPath.row == 1)
		{
			//メールフォーム表示
			self.showMailForm()
		}
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
		LogUtility.debug( self, log: "didSelectRowAtIndexPath")
	}
	
	/**
	メニューのバージョン表示に、バージョン番号を追加します
	*/
	private func addVersionStringToMenu()
	{
		let rawVersionString = self.menuList[2];
		let version: String! = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as String
		let formatedVersionString = rawVersionString + "  " + version
		self.menuList[2] = formatedVersionString
	}
	
	/**
	メール送信画面を表示します
	*/
	func showMailForm()
	{
		if ( MFMailComposeViewController.canSendMail() )
		{
			let mailViewController = MFMailComposeViewController()
			
			mailViewController.mailComposeDelegate = self
			mailViewController.setSubject( "麻雀キーボード ご意見・ご感想" )
			
			let toRecipients = ["entupset@gmail.com"]
			mailViewController.setToRecipients(toRecipients)
			mailViewController.setMessageBody( "ご意見・ご感想などありましたら、お知らせください。", isHTML: false )
			
			self.presentViewController(mailViewController, animated: true, completion: nil)
		}
		else
		{
			LogUtility.warning( self, log: "showMailForm, Email Send Failed")
		}
		LogUtility.debug( self, log: "showMailForm")
	}
	
	/**
	メール画面の操作完了後に呼ばれます
	*/
	func mailComposeController(controller: MFMailComposeViewController!,
		didFinishWithResult result: MFMailComposeResult, error: NSError! )
	{
		switch result.value
		{
		case MFMailComposeResultCancelled.value:
			LogUtility.debug( self, log: "mailComposeController, Email Send Cancelled")
		case MFMailComposeResultSaved.value:
			LogUtility.debug( self, log: "mailComposeController, Email Saved as a Draft")
		case MFMailComposeResultSent.value:
			LogUtility.debug( self, log: "mailComposeController, Email Sent Successfully")
		case MFMailComposeResultFailed.value:
			LogUtility.debug( self, log: "mailComposeController, Email Send Failed")
		default:
			break
		}
		
		self.dismissViewControllerAnimated(true, completion: nil)
		LogUtility.debug( self, log: "mailComposeController")
	}
}

