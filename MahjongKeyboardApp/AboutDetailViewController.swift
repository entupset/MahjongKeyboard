//
//  AboutDetailViewController.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/29.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	画像素材について画面
*/
class AboutDetailViewController: UIViewController, UIWebViewDelegate
{
	///html表示用webビュー
	let myWebView : UIWebView = UIWebView()
	
	/*
		ビュー表示完了後に呼ばれます
		@see UIViewController
	*/
	override func viewDidLoad()
	{
		super.viewDidLoad()

		self.title = "画像素材について"
		
		// Delegateを設定する.
		myWebView.delegate = self
		
		// WebViewのサイズを設定する.
		myWebView.frame = self.view.bounds
		
		// Viewに追加する.
		self.view.addSubview(myWebView)

		let path = NSBundle.mainBundle().pathForResource("free_image", ofType: "html")!
		let url = NSURL(string: path)!
		
		var htmlData:NSData = NSData.dataWithContentsOfMappedFile(path) as NSData
		self.myWebView.loadData(htmlData, MIMEType: "text/html", textEncodingName: "utf-8", baseURL: url)
		
		LogUtility.debug( self, log: "viewDidLoad")
	}
	
	/*
		WebView の読み込み開始時に呼ばれます
	*/
	func webViewDidStartLoad(webView: UIWebView!)
	{
		LogUtility.debug( self, log: "webViewDidStartLoad")
	}

	/*
		WebView の読み込み完了時に呼ばれます
	*/
	func webViewDidFinishLoad(webView: UIWebView!)
	{
		LogUtility.debug( self, log: "webViewDidFinishLoad")
	}
}
