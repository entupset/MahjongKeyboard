//
//  KeyboardViewController.swift
//  MahjongKeyboard
//
//  Created by tatsuya tezuka on 2015/01/12.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	入力操作画面の種別
*/
enum BaseOperationViewType : Int
{
	case operationHaiInputView			//!< 牌入力
	case operationWiktionaryDetailView	//!< 局の詳細入力
	case operationHaiHistoryView		//!< 入力履歴
	case operationMahjongDictonaryView	//!< 用語入力
}

/**
	入力操作画面の移動方向
*/
enum BaseOperationChangeType : Int
{
	case moveNone	//!< 移動しない
	case moveLeft	//!< 左
	case moveRight	//!< 右
}

/**
	キーボード処理の起点となるViewController

	CustumKeyboard を実装するには
	UIInputViewController 派生であるこのクラスを拡張していく
*/
class KeyboardViewController: UIInputViewController, InputViewChangeDelegate, CustomKeyboardOperationDelegate
{

	/// ViewとModelの仲介を行うコントローラ
	var controller: MahjongKeyboardController! = MahjongKeyboardController()//!< 牌管理マネージャ

	var isFirst:Bool = true  //!< 初回判定フラグ
	var frameSize:CGSize = CGSizeMake(0, 0) //!< 現在のビューサイズ(回転判定で使用)
	
	var viewCandidate:HaiCandidateView?		     //!< 画面上 牌出力候補ビュー
	var viewCommonOperation:CommonOperationView? //!< 画面下 共通操作ビュー
	var viewBaseOperation:BaseOperationView?     //!< 現在使用している操作ビュー
	var currentBaseOperationViewIndex : Int  = 0 //!< 現在使用している操作ビューインデックス

	/// 使用する入力ビューの順序
	var baseOperationViews : Array<BaseOperationViewType> = Array<BaseOperationViewType>()

	/**
		ビューの表示完了時に呼ばれます
		@see UIViewController
	*/
	override func viewDidAppear(animated: Bool)
	{
		super.viewDidAppear(animated)
		self.setupKeyboardHeight()
		
		LogUtility.debug( self, log: "viewDidAppear ")
	}
	
	/**
		レイアウト変更時に呼ばれます
		@see UIViewController
	*/
	override func updateViewConstraints()
	{
		super.updateViewConstraints()
		if( self.isFirst )
		{
			self.controller.loadPersistData()
			self.setupOperationViews()
			self.isFirst = false
		}
		self.setupScreen()

		LogUtility.debug( self, log: "updateViewConstraints ")
	}

	/**
		キーボード全体の高さを変更します
	*/
	private func setupKeyboardHeight()
	{
		var view = inputView as UIInputView!
		view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight

		let candidateViewHeight:CGFloat   = HaiCandidateView.getViewHeight()
		let inputViewHeight:CGFloat		  = BaseOperationView.getViewHeight()
		let commonOperationHeight:CGFloat = CommonOperationView.getViewHeight()
		let expandedHeight:CGFloat = candidateViewHeight + inputViewHeight + commonOperationHeight

		let heightConstraint = NSLayoutConstraint(item:view,
			attribute: .Height,
			relatedBy: .Equal,
			toItem: nil,
			attribute: .NotAnAttribute,
			multiplier: 0.0,
			constant: expandedHeight)

		view.addConstraint(heightConstraint)

		LogUtility.debug( self, log: "setupKeyboardHeight　, expandedHeight \(expandedHeight) ")
	}
	
	/**
		ビューのサイズが変更されたかを判定します
		@param  newSize 判定対象のサイズ
		@return 変更されたかを表す真偽値
	*/
	private func isFrameChange(newSize:CGSize) -> Bool
	{
		var isChange = false
		if( self.frameSize.width != newSize.width)
		{
			isChange = true
		}
		if( self.frameSize.height != newSize.height)
		{
			isChange = true
		}
		return isChange
	}
	
	/**
		ビュー全体の初期化を行います
	*/
	private func setupScreen()
	{
		let myBoundSize: CGSize = self.inputView.frame.size
		
		//-----------------------
		//候補ビューの初期化
		let candidateViewHeight:CGFloat = HaiCandidateView.getViewHeight()
		if( self.isFrameChange( myBoundSize ) )
		{
			self.viewCandidate?.removeFromSuperview()
			let viewRect = CGRect(
				x: 0, y: 0, width: myBoundSize.width, height: candidateViewHeight )
			self.viewCandidate = HaiCandidateView(frame: viewRect)
			self.viewCandidate?.backgroundColor = UIColor.hexStr("a9a9a9", alpha: 1)
			self.inputView?.addSubview( self.viewCandidate! )

			//デリゲート設定
			self.controller.haiChangeDelegate = self.viewCandidate
			self.viewCandidate?.candidateOperationDelegate = self.controller
			self.viewCandidate?.candidateOperationDelegate.requestCurrentCandidate()
		}

		//-----------------------
		//入力ビューの初期化
		if( self.isFrameChange( myBoundSize ) )
		{
			self.requestInputViewChange( BaseOperationChangeType.moveNone )
		}
		
		//-----------------------
		//共通操作ビューの初期化
		if( self.isFrameChange( myBoundSize ) )
		{
			let inputViewHeight:CGFloat = BaseOperationView.getViewHeight()
			let commonOperationHeight:CGFloat = CommonOperationView.getViewHeight()
			let rectCommonOperation = CGRect(
				x: 0, y: candidateViewHeight + inputViewHeight,
				width: myBoundSize.width, height: commonOperationHeight )

			self.viewCommonOperation?.removeFromSuperview()
			self.viewCommonOperation = CommonOperationView( frame: rectCommonOperation )
			self.viewCommonOperation?.setupScreen()
			self.inputView?.addSubview( self.viewCommonOperation! )
			
			//デリゲート設定
			self.controller.modeChangeDelegate = self.viewCommonOperation
			
			self.viewCommonOperation?.commonOperationDelegate = self.controller
		}

		//-----------------------
		//メイン操作ビュー切り替えのデリゲート設定
		self.viewBaseOperation?.inputViewChangeDelegate = self
		
		self.controller.customKeyboardOperationDelegate = self

		LogUtility.debug( self, log: "setupScreen")
	}
	
	/**
		入力操作の切り替えを行います
		@param  moveType 変更時の操作の方向
		@see  InputViewChangeDelegate
	*/
	func requestInputViewChange( moveType:BaseOperationChangeType )
	{
		self.viewBaseOperation?.removeFromSuperview()

		var index = self.baseOperationViews[ currentBaseOperationViewIndex ]
		if ( moveType  == BaseOperationChangeType.moveNone )
		{
			//ビューを切り替えず、現在のインデックスのビューを生成
			// nop
		}
		else if ( moveType  == BaseOperationChangeType.moveRight )
		{
			//ビューを切り替え(次)
			if( 0 == currentBaseOperationViewIndex)
			{
				self.currentBaseOperationViewIndex = self.baseOperationViews.count-1
			}
			else
			{
				self.currentBaseOperationViewIndex--
			}
			index = self.baseOperationViews[currentBaseOperationViewIndex]
		}
		else if ( moveType  == BaseOperationChangeType.moveLeft )
		{
			//ビューを切り替え(前)
			if( currentBaseOperationViewIndex == ( self.baseOperationViews.count-1 ) )
			{
				self.currentBaseOperationViewIndex = 0
			}
			else
			{
				self.currentBaseOperationViewIndex++
			}
			index = self.baseOperationViews[currentBaseOperationViewIndex]
		}
		self.viewBaseOperation = self.createOperationView( index )
		self.viewBaseOperation?.setupOperationView()
		self.inputView?.addSubview( self.viewBaseOperation! )

		//スワイプのアニメーション実行
		self.viewBaseOperation?.swipeAnimation( moveType )
		
		LogUtility.debug( self, log: "changeBaseOperation")
	}
	
	/**
		指定された種別の入力ビューを生成します
		@param  baseOperationViewType 入力ビューの種別
		@return  入力ビューのインスタンス
		@note controllerとview間のDelegate接続もこの関数内で行います
	*/
	private func createOperationView( baseOperationViewType:BaseOperationViewType )->BaseOperationView
	{
		let myBoundSize: CGSize         = UIScreen.mainScreen().bounds.size
		let candidateViewHeight:CGFloat = HaiCandidateView.getViewHeight()
		let inputViewHeight:CGFloat     = BaseOperationView.getViewHeight()
		
		//入力ビューの初期化
		let rectInputView = CGRect( x: 0, y: candidateViewHeight,
			width: myBoundSize.width, height: inputViewHeight )
		
		var baseOperationView:BaseOperationView
		switch(baseOperationViewType)
		{
			case BaseOperationViewType.operationHaiInputView:
				var view:HaiInputView = HaiInputView(frame: rectInputView)
				view.candidateOperationDelegate = self.controller
				baseOperationView = view
				break
			case BaseOperationViewType.operationWiktionaryDetailView:
				var view:WiktionaryDetailView = WiktionaryDetailView(frame: rectInputView)
				view.detailOperationDelegate = self.controller
				baseOperationView = view
				self.controller.detailChangedDelegate = view
				break
			case BaseOperationViewType.operationHaiHistoryView:
				var view:HaiHistoryView = HaiHistoryView(frame: rectInputView)
				view.situationHistoryOperationDelegate = self.controller
				baseOperationView = view
				self.controller.situationHistoryChangedDelegate = view
				break
			case BaseOperationViewType.operationMahjongDictonaryView:
				var view:MahjongDictonaryView = MahjongDictonaryView(frame: rectInputView)
				view.commonOperationDelegate = self.controller
				baseOperationView = view
				break
			default:
				LogUtility.fatal( self, log: "createOperationView invalid viewtype ")
				break
		}
		baseOperationView.inputViewChangeDelegate = self

		LogUtility.debug( self, log: "createOperationView")
		return baseOperationView
	}
	
	/**
		入力ビューの移動順を登録します
	*/
	private func setupOperationViews()
	{
		self.baseOperationViews.append( BaseOperationViewType.operationHaiInputView )
		self.baseOperationViews.append( BaseOperationViewType.operationWiktionaryDetailView )
		self.baseOperationViews.append( BaseOperationViewType.operationHaiHistoryView )
		self.baseOperationViews.append( BaseOperationViewType.operationMahjongDictonaryView )

		LogUtility.debug( self, log: "setupOperationViews")
	}
	
	/**
		入力テキストの変更直前に呼ばれます
		@see UIInputViewController
	*/
	override func textWillChange(textInput: UITextInput)
	{
		LogUtility.debug( self, log: "textWillChange")
	}
	
	/**
		入力テキストの変更後に呼ばれます
		@see UIInputViewController
	*/
	override func textDidChange(textInput: UITextInput)
	{
		LogUtility.debug( self, log: "textDidChange")
	}
	
	/**
		次のキーボード 切り替え要求時に呼ばれます
		@see CustomKeyboardOperationDelegate
	*/
	func requestNextKeyboard()
	{
		self.advanceToNextInputMode()
		LogUtility.debug( self, log: "requestNextKeyboard")
	}

	/**
		カーソル移動要求時に呼ばれます
		@param positionOffset カーソル移動量
		@see CustomKeyboardOperationDelegate
	*/
	func requestCursolPositionChange( positionOffset:Int )
	{
		var proxy = textDocumentProxy as UITextDocumentProxy
		proxy.adjustTextPositionByCharacterOffset( positionOffset )
		LogUtility.debug( self, log: "requestCursolPositionChange")
	}

	/**
		文字削除要求時に呼ばれます
		@see CustomKeyboardOperationDelegate
	*/
	func requestRemoveWord()
	{
		let proxy = textDocumentProxy as UIKeyInput
		proxy.deleteBackward()
		LogUtility.debug( self, log: "requestRemoveWord")
	}

	/**
		指定テキストの直接入力要求時に呼ばれます
		@param text 入力対象のテキスト
		@see CustomKeyboardOperationDelegate
	*/
	func requestInputText( text:String )
	{
		let proxy = textDocumentProxy as UITextDocumentProxy
		proxy.insertText( text )
		LogUtility.debug( self, log: "requestInputText")
	}
	
}


