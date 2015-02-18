//
//  WiktionaryDetailView.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/16.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	キーボード中央部の操作画面(2) 局の詳細情報入力
*/
class WiktionaryDetailView: BaseOperationView, DetailChangedDelegate
{
	/// 局詳細の変更依頼を受け付けるデリゲート
	var detailOperationDelegate:DetailOperationDelegate!
	
	var detailOnOffButton:UIButton! //!< 局の詳細入力 有効・無効 ボタン
	var detailOnOffLabel:UILabel!   //!< 局の詳細入力 有効・無効 状態表示ラベル
	var kazeLabel:UILabel!          //!< 風表示ラベル
	var kyokumeLabel:UILabel!		//!< 局目 表示ラベル
	var junmeLabel:UILabel!			//!< 順目 表示ラベル
	var daraButton:UIButton!		//!< ドラ 表示兼切り替えボタン
	var tsumoButton:UIButton!		//!< ツモ牌 表示兼切り替えボタン
	var viewGray:UIView!			//!< 局の詳細入力 無効時にかぶせるグレー部分
	var isFirst = true				//!< 初回表示フラグ
	
	let detailAreaOffset:CGFloat = 30
	
	init( frame:CGRect , delegate:DetailOperationDelegate )
	{
		self.detailOperationDelegate = delegate
		super.init( frame: frame )
	}
	
	/**
		初期化処理を行います
	*/
	override func setupOperationView()
	{
		//lightgrey
		self.backgroundColor = UIColor.hexStr("d3d3d3", alpha: 1)
		
		// 画面表示物の生成
		self.setupBackgroundStripe()	//項目区分背景
		self.setupDetailOnOffButton()	//詳細出力
		self.setupKaze()				//風
		self.setupKyokume()				//局目
		self.setupJunme()				//順目
		self.setupDora()				//ドラ
		self.setupTsumo()				//ツモ牌
		self.setupDetailDisableView()	//局の詳細入力 無効時にかぶせるグレー部分

		// スワイプ設定
		self.setupSwipe()
		
		//デフォルト値の更新を要求
		self.detailOperationDelegate.requestCurrentDetail()
		
		LogUtility.debug( self, log: "setupOperationView")
	}

	/**
		背景の設定を行います
		@note パラメータごとに背景を変えて見やすくします
	*/
	private func setupBackgroundStripe()
	{
		let stripe1 = UIColor.hexStr("d3d3d3", alpha: 1)
		let stripe2 = UIColor.hexStr("e3e3e3", alpha: 1)

		// 一番上のエリア(チェックボックス)
		let backGoroundOnOffHeight:CGFloat = 30
		let backGoroundOnOffViewRect = CGRect(
			x: 0, y: 0,
			width: self.frame.width,
			height: backGoroundOnOffHeight )
		
		var backGoroundOnOff = UIView( frame: backGoroundOnOffViewRect )
		backGoroundOnOff.backgroundColor = stripe2
		self.addSubview( backGoroundOnOff )
	
		// 風選択のエリア
		let backGoroundKazeHeight:CGFloat = 40
		let backGoroundKazeViewRect = CGRect(
			x: 0, y: backGoroundOnOffHeight,
			width: self.frame.width,
			height: backGoroundKazeHeight )
		
		var backGoroundKaze = UIView( frame: backGoroundKazeViewRect )
		backGoroundKaze.backgroundColor = stripe1
		self.addSubview( backGoroundKaze )

		// 順目選択のエリア
		let backGoroundJunmeHeight:CGFloat = 40
		let backGoroundJunmeViewRect = CGRect(
			x: 0, y: backGoroundOnOffHeight + backGoroundKazeHeight,
			width: self.frame.width,
			height: backGoroundJunmeHeight )
		
		var backGoroundJunme = UIView( frame: backGoroundJunmeViewRect )
		backGoroundJunme.backgroundColor = stripe2
		self.addSubview( backGoroundJunme )

		LogUtility.debug( self, log: "setupBackgroundStripe")
	}
	
	/**
		局の詳細入力 有効・無効 ボタン・ラベルを生成します
	*/
	private func setupDetailOnOffButton()
	{
		//ボタンの生成
		self.detailOnOffButton = UIButton.buttonWithType(.Custom) as UIButton
		let imageDetailOnOffButton = UIImage(named: "common_chheck_off.png") as UIImage!
		self.detailOnOffButton.setImage(imageDetailOnOffButton, forState: .Normal)
		
		self.detailOnOffButton.addTarget(
			self,
			action: "onPushDetailOnOffBUtton",
			forControlEvents: .TouchUpInside)
		
		let btnLeft:CGFloat = 20
		let btnTop:CGFloat  = 3
		
		Layout.addSubView(self.detailOnOffButton, superview: self )
			.top(btnTop).fromSuperviewTop()
			.left(btnLeft).fromSuperviewLeft()

		//ラベルの生成
		self.detailOnOffLabel = UILabel()
		let lebalLeft:CGFloat = 54
		let lebalTop:CGFloat  = 5
		
		Layout.addSubView(self.detailOnOffLabel, superview: self )
			.top(lebalTop).fromSuperviewTop()
			.left(lebalLeft).fromSuperviewLeft()

		LogUtility.debug( self, log: "setupDetailOnOffButton")
	}
	
	/**
		 風 関連のボタン・ラベルを生成します
	*/
	private func setupKaze()
	{
		//ボタンの生成
		for haiIndex in 1...4
		{
			let haiTypeValue:Int = ( HaiType.other_1.rawValue - 1 + haiIndex )
			let haiType:HaiType = HaiType( rawValue: haiTypeValue )!
			let hai:Hai = Hai( _haiType: haiType, _isRed: false )
			let resourceName = hai.getResourceName()
			
			let image = UIImage(named: resourceName) as UIImage!
			let kazeButton = UIButton.buttonWithType(.Custom) as UIButton
			kazeButton.setImage(image, forState: .Normal)
			
			kazeButton.addTarget(
				self,
				action: Selector("onPushKazeButton:"),
				forControlEvents: .TouchUpInside)
			kazeButton.tag = haiIndex
			
			let haiImageSize = MahjongKeyboardConstant.getHaiImageSize()
			let kazeButtonLeftMargin:CGFloat = 20
			let kazeButtonInterval:CGFloat   = 8

			let kazeButtonLeft:CGFloat = kazeButtonLeftMargin +
					( CGFloat( haiIndex - 1 ) * ( haiImageSize.width + kazeButtonInterval ) )

			let kazeButtonTop:CGFloat  = 32
			
			Layout.addSubView(kazeButton, superview: self )
				.top(kazeButtonTop).fromSuperviewTop()
				.left(kazeButtonLeft).fromSuperviewLeft()
		}
		
		//ラベルの生成
		self.kazeLabel = UILabel()
		let lebalLeft:CGFloat = 150
		let lebalTop:CGFloat  = 42
		
		Layout.addSubView(self.kazeLabel, superview: self )
			.top(lebalTop).fromSuperviewTop()
			.left(lebalLeft).fromSuperviewLeft()
		
		LogUtility.debug( self, log: "setupKaze")
	}

	/**
		局目 関連のボタン・ラベルを生成します
	*/
	private func setupKyokume()
	{
		//ボタンの生成
		for haiIndex in 1...4
		{
			let kyokumeButton = UIButton.buttonWithType(.Custom) as UIButton

			let resourceName = NSString(format: "common_%d.png", haiIndex)
			let image = UIImage(named: resourceName) as UIImage!
			kyokumeButton.setImage(image, forState: .Normal)
			
			kyokumeButton.addTarget(
				self,
				action: Selector("onPushKyokumeButton:"),
				forControlEvents: .TouchUpInside)
			kyokumeButton.tag = haiIndex
			
			let numberImageSize = MahjongKeyboardConstant.getNumberButtonImageSize()
			let kyokumeButtonLeftMargin:CGFloat = 20
			let kyokumeButtonInterval:CGFloat   = 8

			let kyokumeButtonLeft:CGFloat = kyokumeButtonLeftMargin +
					( CGFloat( haiIndex - 1 ) * ( numberImageSize.width + kyokumeButtonInterval ) )

			let kyokumeButtonTop:CGFloat  = 78
			
			Layout.addSubView(kyokumeButton, superview: self )
				.top(kyokumeButtonTop).fromSuperviewTop()
				.left(kyokumeButtonLeft).fromSuperviewLeft()
		}

		//ラベルの生成
		self.kyokumeLabel = UILabel()
		let lebalLeft:CGFloat = 152
		let lebalTop:CGFloat  = 80
		
		Layout.addSubView(self.kyokumeLabel, superview: self )
			.top(lebalTop).fromSuperviewTop()
			.left(lebalLeft).fromSuperviewLeft()

		LogUtility.debug( self, log: "setupKyokume")
	}
	
	/**
		順目 関連のボタン・ラベルを生成します
	*/
	private func setupJunme()
	{
		let numberImageSize = MahjongKeyboardConstant.getNumberButtonImageSize()

		let leftMargin:CGFloat   = 20
		let leftInterval:CGFloat = 10
		let topInterval:CGFloat  = 3

		var buttonLeft:CGFloat = leftMargin
		var buttonTop:CGFloat  = 114

		//ボタンの生成
		for haiIndex in 0...9
		{
			let nunberButton = UIButton.buttonWithType(.Custom) as UIButton

			let resourceName = NSString(format: "common_%d.png", haiIndex)
			let image = UIImage(named: resourceName) as UIImage!
			nunberButton.setImage(image, forState: .Normal)
			
			nunberButton.addTarget(
				self,
				action: Selector("onPushJunmeButton:"),
				forControlEvents: .TouchUpInside)
			nunberButton.tag = haiIndex
			
			if( haiIndex == 5 )
			{
				buttonLeft = leftMargin
				buttonTop += ( numberImageSize.height + topInterval )
			}
			
			Layout.addSubView(nunberButton, superview: self )
				.top( buttonTop ).fromSuperviewTop()
				.left( buttonLeft ).fromSuperviewLeft()

			buttonLeft += ( numberImageSize.width + leftInterval )
		}

		//ラベルの生成
		self.junmeLabel = UILabel()
		let lebalLeft:CGFloat = 190
		let lebalTop:CGFloat  = 116
		
		Layout.addSubView(self.junmeLabel, superview: self )
			.top(lebalTop).fromSuperviewTop()
			.left(lebalLeft).fromSuperviewLeft()

		LogUtility.debug( self, log: "setupJunme")
	}
	
	/**
		ドラ関連のボタン・ラベルを生成します
	*/
	private func setupDora()
	{
		//ボタンの生成
		self.daraButton = UIButton()
		self.daraButton!.addTarget(
			self,
			action: Selector("onPushDara"),
			forControlEvents: .TouchUpInside)
		
		let buttonLeft:CGFloat = 245
		let buttonTop:CGFloat  = 32
		
		Layout.addSubView(self.daraButton!, superview: self )
			.top( buttonTop ).fromSuperviewTop()
			.left( buttonLeft ).fromSuperviewLeft()

		//ラベルの生成
		var doraLabel = UILabel()
		let lebalLeft:CGFloat = 205
		let lebalTop:CGFloat  = 42
		
		doraLabel.text = "ドラ"
		Layout.addSubView(doraLabel, superview: self )
			.top(lebalTop).fromSuperviewTop()
			.left(lebalLeft).fromSuperviewLeft()

		LogUtility.debug( self, log: "setupDora")
	}
	
	/**
		ツモ牌関連のボタン・ラベルを生成します
	*/
	private func setupTsumo()
	{
		//ボタンの生成
		self.tsumoButton = UIButton()
		self.tsumoButton!.addTarget(
			self,
			action: Selector("onPushTsumo"),
			forControlEvents: .TouchUpInside)
		
		let buttonLeft:CGFloat = 245
		let buttonTop:CGFloat  = 72
		
		Layout.addSubView(self.tsumoButton!, superview: self )
			.top( buttonTop ).fromSuperviewTop()
			.left( buttonLeft ).fromSuperviewLeft()
		
		//ラベルの生成
		var tsumoLabel = UILabel()
		let lebalLeft:CGFloat = 207
		let lebalTop:CGFloat  = 80
		
		tsumoLabel.text = "ツモ"
		Layout.addSubView(tsumoLabel, superview: self )
			.top(lebalTop).fromSuperviewTop()
			.left(lebalLeft).fromSuperviewLeft()
		
		LogUtility.debug( self, log: "setupTsumo")
	}
	
	
	
	/**
		局の詳細入力 無効時にかぶせるグレー部分を生成します
	*/
	private func setupDetailDisableView()
	{
		let viewRect = CGRect(
			x: 0, y: self.detailAreaOffset,
			width: self.frame.width,
			height: self.frame.height - self.detailAreaOffset )
		self.viewGray = UIView(frame: viewRect)
		self.viewGray.backgroundColor = UIColor.hexStr("888888", alpha: 0.7)
		self.addSubview( self.viewGray )

		LogUtility.debug( self, log: "setupDetailDisableView")
	}

	/**
		局の詳細入力 有効・無効 ボタン押下時に呼ばれます
	*/
	func onPushDetailOnOffBUtton()
	{
		self.detailOperationDelegate.requestChanhgeDetailOnOff()
		LogUtility.debug( self, log: "onPushDetailOnOffBUtton")
	}
	
	/**
		風ボタン押下時に呼ばれます
		@param sender 押下されたボタン
	*/
	func onPushKazeButton( sender: UIButton! )
	{
		switch ( sender.tag )
		{
			case 1:
				self.detailOperationDelegate.requestChanhgeDetailKaze( DetailKaze.ton )
			case 2:
				self.detailOperationDelegate.requestChanhgeDetailKaze( DetailKaze.nan )
			case 3:
				self.detailOperationDelegate.requestChanhgeDetailKaze( DetailKaze.shaa )
			case 4:
				self.detailOperationDelegate.requestChanhgeDetailKaze( DetailKaze.pei )
			default:
				break
		}
		LogUtility.debug( self, log: "onPushKazeButton")
	}
	
	/**
		局目ボタン押下時に呼ばれます
		@param sender 押下されたボタン
	*/
	func onPushKyokumeButton( sender: UIButton! )
	{
		let kyokume = Int32(sender.tag)
		self.detailOperationDelegate.requestChanhgeDetailKyokume( kyokume )

		LogUtility.debug( self, log: "onPushKyokumeButton")
	}
	
	/**
		順目ボタン押下時に呼ばれます
		@param sender 押下されたボタン
	*/
	func onPushJunmeButton( sender: UIButton! )
	{
		let junme = Int32(sender.tag)
		self.detailOperationDelegate.requestChanhgeDetailJunme(junme)

		LogUtility.debug( self, log: "onPushJunmeButton")
	}
	
	/**
		ドラ変更ボタン押下時に呼ばれます
	*/
	func onPushDara()
	{
		self.showHaiSelectView( HaiSelectMode.Dora )
		LogUtility.debug( self, log: "onPushDara")
	}
	
	/**
		ツモ牌変更ボタン押下時に呼ばれます
	*/
	func onPushTsumo()
	{
		self.showHaiSelectView( HaiSelectMode.Tsumo )
		LogUtility.debug( self, log: "onPushTsumo")
	}
	
	/**
		牌選択ビューを表示します
		@param  selectMode  選択モード
	*/
	private func showHaiSelectView( selectMode:HaiSelectMode )
	{
		//ツモ選択ビュー表示
		let candidateViewHeight:CGFloat   = HaiCandidateView.getViewHeight()
		let inputViewHeight:CGFloat		  = BaseOperationView.getViewHeight()
		let commonOperationHeight:CGFloat = CommonOperationView.getViewHeight()
		let expandedHeight:CGFloat = candidateViewHeight + inputViewHeight + commonOperationHeight
		
		let viewRect = CGRect(
			x: 0, y: 0,
			width: self.frame.width,
			height: self.frame.height + commonOperationHeight)
		
		var view:WiktionaryDetailDoraSelectView =
		WiktionaryDetailDoraSelectView(
			viewRect: viewRect,
			selectMode:selectMode,
			operationDelegate: self.detailOperationDelegate )
		view.backgroundColor = UIColor.hexStr("e3e3e3", alpha: 1)
		
		self.addSubview( view )
		
		view.center = CGPoint(
			x: view.frame.width / 2,
			y: expandedHeight + ( view.frame.height / 2 ) )
		
		UIView.animateWithDuration( 0.2,
			animations:
			{() -> Void in
				view.center = CGPoint(
					x: view.frame.width  / 2,
					y: view.frame.height / 2 );
			},
			completion:
			{(Bool) -> Void in
				// nop
			}
		)
		LogUtility.debug( self, log: "showHiaSelectView")
	}
	
	
	/**
		局の詳細入力 有効・無効 状態変更時に呼ばれます
		@param  isDetailOutput  局の詳細入力 有効・無効
		@see DetailChangedDelegate
	*/
	func changedDetailOutput( isDetailOutput:Bool )
	{
		var detailString = MahjongKeyboardTextUtility.getDetailString( isDetailOutput )
		self.detailOnOffLabel.text = detailString

		var imageDetailOnOffButton:UIImage
		if( isDetailOutput)
		{
			imageDetailOnOffButton = UIImage(named: "common_chheck_on.png") as UIImage!
		}
		else
		{
			imageDetailOnOffButton = UIImage(named: "common_chheck_off.png") as UIImage!
		}
		self.detailOnOffButton.setImage(imageDetailOnOffButton, forState: .Normal)
		
		// 入力有効・無効のエリア
		
		if( isFirst )
		{
			// 初回(ビューの表示直後)はアニメーションしない
			if( isDetailOutput)
			{
				self.viewGray.center = CGPoint(
					x: self.viewGray.frame.width / 2,
					y: self.frame.height + ( self.viewGray.frame.height / 2 ) + self.detailAreaOffset )
			}
			else
			{
				self.viewGray.center = CGPoint(
					x: self.viewGray.frame.width / 2 ,
					y: ( self.viewGray.frame.height / 2 ) + self.detailAreaOffset )
			}
			isFirst = false
		}
		else
		{
			let animationDuration:NSTimeInterval = 0.2
			
			if( isDetailOutput)
			{
				self.viewGray.center = CGPoint(
					x: self.viewGray.frame.width / 2,
					y: ( self.viewGray.frame.height / 2 ) + self.detailAreaOffset )
				
				UIView.animateWithDuration( animationDuration,
					animations:
					{() -> Void in
						self.viewGray.center = CGPoint(
							x: self.viewGray.frame.width / 2,
							y: self.frame.height + ( self.viewGray.frame.height / 2 ) + self.detailAreaOffset );
					},
					completion:
					{(Bool) -> Void in
						// nop
					}
				)
			}
			else
			{
				self.viewGray.center = CGPoint(
					x: self.viewGray.frame.width / 2,
					y: self.frame.height + ( self.viewGray.frame.height / 2 ) + self.detailAreaOffset )
				
				UIView.animateWithDuration( animationDuration,
					animations:
					{() -> Void in
						self.viewGray.center = CGPoint(
							x: self.viewGray.frame.width / 2,
							y: (self.viewGray.frame.height / 2 ) + self.detailAreaOffset )
					},
					completion:
					{(Bool) -> Void in
						// nop
					}
				)
			}
		}
		LogUtility.debug( self, log: "changedDetailOutput")
	}
	
	/**
		風の状態変更時に呼ばれます
		@param  detailKaze 変更後の風
		@see DetailChangedDelegate
	*/
	func changedKaze( detailKaze:DetailKaze )
	{
		let kazeString = MahjongKeyboardTextUtility.getKazeString( detailKaze )
		self.kazeLabel.text = kazeString
		LogUtility.debug( self, log: "changedKaze")
	}

	/**
		局目の変更時に呼ばれます
		@param  kyokume 変更後の局目
		@see DetailChangedDelegate
	*/
	func changedKyokume( kyokume:Int32 )
	{
		self.kyokumeLabel.text = MahjongKeyboardTextUtility.getKyokumeString( kyokume )
		LogUtility.debug( self, log: "changedKyokume")
	}

	/**
		順目の変更時に呼ばれます
		@param  junme 変更後の順目
		@see DetailChangedDelegate
	*/
	func changedJunme( junme:Int32 )
	{
		self.junmeLabel.text = MahjongKeyboardTextUtility.getJunmeString( junme )
		LogUtility.debug( self, log: "changedJunme")
	}

	/**
		ドラの変更時に呼ばれます
		@param  hai 変更後のドラ
		@see DetailChangedDelegate
	*/
	func changedDora( hai:Hai )
	{
		let resourceName :String = hai.getResourceName()
		let image = UIImage(named: resourceName) as UIImage!
		self.daraButton!.setImage(image, forState: .Normal)

		LogUtility.debug( self, log: "changedDora")
	}
	
	/**
		ツモ牌の変更時に呼ばれます
		@param  hai 変更後のツモ牌
		@see DetailChangedDelegate
	*/
	func changedTsumo( hai:Hai )
	{
		let resourceName :String = hai.getResourceName()
		let image = UIImage(named: resourceName) as UIImage!
		self.tsumoButton!.setImage(image, forState: .Normal)

		LogUtility.debug( self, log: "changedTsumo")
	}

}
