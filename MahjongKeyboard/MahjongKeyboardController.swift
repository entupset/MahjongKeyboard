//
//  MahjongKeyboardController.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/18.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import Foundation

/**
	ViewとModelの仲介を行うコントローラ
*/
class MahjongKeyboardController :
	CandidateOperationDelegate,
	DetailOperationDelegate,
	SituationHistoryOperationDelegate,
	CommonOperationDelegate
{
	/// 牌候補の変更依頼を受け付けるデリゲート
	var haiChangeDelegate: CandidateChangedDelegate!

	/// 動作モードの変更依頼を受け付けるデリゲート
	var modeChangeDelegate: ModeChangedDelegate!

	/// 局の詳細の変更依頼を受け付けるデリゲート
	var detailChangedDelegate: DetailChangedDelegate!

	/// 入力履歴の変更依頼を受け付けるデリゲート
	var situationHistoryChangedDelegate:SituationHistoryChangedDelegate!

	/// カスタムキーボード直接操作の変更依頼を受け付けるデリゲート
	var customKeyboardOperationDelegate: CustomKeyboardOperationDelegate!
	
	/// 牌の入力モード
	var haiinputStringType: HaiInputStringType = HaiInputStringType.simple

	/// 自動整列を行うか否か
	var haiSortType: HaiSortType = HaiSortType.sort
	
	/// データモデル
	var model:MahjongKeyboardModel = MahjongKeyboardModel()
	
	init ()
	{
	}
	
	/**
		牌の入力モード 変更要求時に呼ばれます
		@see CommonOperationDelegate
	*/
	func toggleHaiOutputType()
	{
		switch( self.haiinputStringType )
		{
			case HaiInputStringType.simple:
				self.haiinputStringType = HaiInputStringType.accsiArt1
				break
			case HaiInputStringType.accsiArt1:
				self.haiinputStringType = HaiInputStringType.accsiArt2
				break
			case HaiInputStringType.accsiArt2:
				self.haiinputStringType = HaiInputStringType.simple
				break
			default:
				break
		}
		self.modeChangeDelegate.changedInputMode( self.haiinputStringType )

		LogUtility.debug( self, log: "toggleHaiOutputType")
	}
	
	/**
		牌の自動整列 変更要求時に呼ばれます
		@see CommonOperationDelegate
	*/
	func toggleHaiSortType()
	{
		switch(self.haiSortType)
		{
			case HaiSortType.sort:
				self.setHaiSortType( HaiSortType.unsort )
				break
			case HaiSortType.unsort:
				self.setHaiSortType( HaiSortType.sort )
				break
			default:
				break
		}
		self.modeChangeDelegate.changedSortMode(self.haiSortType)
		
		LogUtility.debug( self, log: "toggleHaiSortType")
	}
	
	
	/**
		牌候補への追加要求時に呼ばれます
		@param hai 追加する牌
		@see CommonOperationDelegate
	*/
	func requestAddHai( hai:Hai )
	{
		self.model.addCurrentEditingHai( hai )
		if( self.haiSortType == HaiSortType.sort )
		{
			self.model.sortCurrentEditing()
		}
		self.haiChangeDelegate.changedCandidate( self.model.cueerntEditing.haiList )
		LogUtility.debug( self, log: "requestAddHai")
	}
	
	/**
		牌候補に対して、指定位置の削除要求時に呼ばれます
		@param removeIndex 牌削除位置
		@see CommonOperationDelegate
	*/
	func requestRemoveHaiFromIndex( removeIndex:Int )
	{
		self.model.removeHaiFromIndex( removeIndex )
		self.haiChangeDelegate.changedCandidate( self.model.cueerntEditing.haiList )

		LogUtility.debug( self, log: "requestRemoveHaiFromIndex")
	}
	
	/**
		現在の牌候補取得要求時に呼ばれます
		@see CommonOperationDelegate
	*/
	func requestCurrentCandidate()
	{
		self.haiChangeDelegate.changedCandidate( self.model.cueerntEditing.haiList )

		LogUtility.debug( self, log: "requestCurrentCandidate")
	}
	
	/**
		局の詳細入力オン・オフ 切り替え要求時に呼ばれます
		@see DetailOperationDelegate
	*/
	func requestChanhgeDetailOnOff()
	{
		self.model.cueerntEditing.toggleDetailOutput()
		self.detailChangedDelegate.changedDetailOutput( self.model.cueerntEditing.isDetailOutput )
		LogUtility.debug( self, log: "requestChanhgeDetailOnOff")
	}
	
	/**
		風の変更要求時に呼ばれます
		@param kaze 変更する風
		@see DetailOperationDelegate
	*/
	func requestChanhgeDetailKaze( kaze:DetailKaze )
	{
		self.model.cueerntEditing.detailKaze = kaze
		self.detailChangedDelegate.changedKaze(self.model.cueerntEditing.detailKaze)
		LogUtility.debug( self, log: "requestChanhgeDetailKaze")
	}
	
	/**
		局目の変更要求時に呼ばれます
		@param kyokume 変更する局目
		@see DetailOperationDelegate
	*/
	func requestChanhgeDetailKyokume( kyokume:Int32 )
	{
		if( 1 <= kyokume && kyokume <= 4 )
		{
			self.model.cueerntEditing.detailKyokume = kyokume
			self.detailChangedDelegate.changedKyokume( self.model.cueerntEditing.detailKyokume )
		}
		else
		{
			LogUtility.warning( self, log: "requestChanhgeDetailKyokume invalid \(kyokume)")
		}
		LogUtility.debug( self, log: "requestChanhgeDetailKyokume")
	}
	
	/**
		順目の変更要求時に呼ばれます
		@param junme 変更する順目
		@see DetailOperationDelegate
	*/
	func requestChanhgeDetailJunme( junme:Int32 )
	{
		let detailJunmeMod = ( self.model.cueerntEditing.detailJunme % 10 ) * 10
		self.model.cueerntEditing.detailJunme = detailJunmeMod + junme
		self.detailChangedDelegate.changedJunme( self.model.cueerntEditing.detailJunme )
		LogUtility.debug( self, log: "requestChanhgeDetailJunme")
	}
	
	/**
		ドラの変更要求時に呼ばれます
		@param hai 変更するドラ
		@see DetailOperationDelegate
	*/
	func requestChanhgeDetailDora( hai:Hai )
	{
		self.model.cueerntEditing.detailDora = hai
		self.detailChangedDelegate.changedDora( self.model.cueerntEditing.detailDora )
		LogUtility.debug( self, log: "requestChanhgeDetailDora")
	}
	
	/**
		現在の局詳細情報 取得要求時に呼ばれます
		@see DetailOperationDelegate
	*/
	func requestCurrentDetail()
	{
		self.detailChangedDelegate.changedDetailOutput( self.model.cueerntEditing.isDetailOutput )
		self.detailChangedDelegate.changedKaze( self.model.cueerntEditing.detailKaze )
		self.detailChangedDelegate.changedKyokume( self.model.cueerntEditing.detailKyokume )
		self.detailChangedDelegate.changedJunme( self.model.cueerntEditing.detailJunme )
		self.detailChangedDelegate.changedDora( self.model.cueerntEditing.detailDora )
	}

	/**
		入力履歴を牌候補に反映 の要求時に呼ばれます
		@param historyIndex 反映対象の履歴の位置
		@see SituationHistoryOperationDelegate
	*/
	func requestHistoryToCurrent( historyIndex:Int )
	{
		self.model.historyToCurrent( historyIndex )
		self.haiChangeDelegate.changedCandidate( self.model.cueerntEditing.haiList )
		
		LogUtility.debug( self, log: "requestHistoryToCurrent")
	}
	
	/**
		現在の牌候補取得要求時に呼ばれます
		@see SituationHistoryOperationDelegate
	*/
	func requestCurrentSituationHistory()
	{
		self.situationHistoryChangedDelegate?.changedSituationHistory( self.model.situationHistory )
		
		LogUtility.debug( self, log: "requestCurrentSituationHistory")
	}
	
	/**
		次のキーボード 要求時に呼ばれます
		@see CommonOperationDelegate
	*/
	func requestNextKeuboard()
	{
		self.customKeyboardOperationDelegate.requestNextKeyboard()
		LogUtility.debug( self, log: "requestNextKeuboard")
	}
	
	/**
		入力モード切り替え 要求時に呼ばれます
		@see CommonOperationDelegate
	*/
	func requestTextOutputModeChange()
	{
		self.toggleHaiOutputType()
		LogUtility.debug( self, log: "requestTextOutputModeChange")
	}
	
	/**
		整列モード切り替え 要求時に呼ばれます
		@see CommonOperationDelegate
	*/
	func requestSortModeChange()
	{
		self.toggleHaiSortType()
		LogUtility.debug( self, log: "requestSortModeChange")
	}
	
	/**
		カーソル移動要求時に呼ばれます
		@param positionOffset カーソル移動量
		@see CommonOperationDelegate
	*/
	func requestCursolPositionChange( positionOffset:Int )
	{
		self.customKeyboardOperationDelegate.requestCursolPositionChange( positionOffset )
		
		LogUtility.debug( self, log: "requestCursolPositionChange")
	}
	
	/**
		文字削除要求時に呼ばれます
		@see CommonOperationDelegate
	*/
	func requestRemoveWord()
	{
		if( self.model.cueerntEditing.haiList.isEmpty == true )
		{
			self.customKeyboardOperationDelegate.requestRemoveWord()
		}
		else
		{
			if( 0 < self.model.cueerntEditing.haiList.count )
			{
				self.model.removeLastCurrentEditing()
				self.haiChangeDelegate.changedCandidate( self.model.cueerntEditing.haiList )
			}
		}
		LogUtility.debug( self, log: "requestRemoveWord")
	}
	
	/**
		編集しているテキストの入力要求時に呼ばれます
		@see CommonOperationDelegate
	*/
	func requestInputText()
	{
		let inputString = self.getInputString()
		self.customKeyboardOperationDelegate.requestInputText( inputString )

		self.model.removeAllCurrentEditing()
		self.haiChangeDelegate.changedCandidate( self.model.cueerntEditing.haiList )
		
		LogUtility.debug( self, log: "requestInputText")
	}
	
	/**
		指定テキストの直接入力要求時に呼ばれます
		@param text 入力対象のテキスト
		@see CommonOperationDelegate
	*/
	func requestInputTextWithString(text: String)
	{
		self.customKeyboardOperationDelegate.requestInputText( text )
		LogUtility.debug( self, log: "outputTextWithString")
	}
	
	/**
		永続データの復元要求時に呼ばれます
	*/
	func loadPersistData()
	{
		self.model.loadCurrentEditing()
		self.model.loadSituationHistory()
	}
	
	/**
		牌の自動整列状態を変更します
		@param haiSortType 変更する牌の自動整列状態
	*/
	private func setHaiSortType( haiSortType:HaiSortType  )
	{
		self.haiSortType = haiSortType
		if( self.haiSortType == HaiSortType.sort )
		{
			// 非ソートからソートに変わった場合は、牌をソートする
			self.model.sortCurrentEditing()
			self.haiChangeDelegate.changedCandidate( self.model.cueerntEditing.haiList )
		}
		LogUtility.debug( self, log: "setHaiSortType")
	}
	
	/**
		モード等の状態に応じて、画面入力する文字列を生成して返します
		@return 画面入力する文字列
	*/
	private func getInputString() -> String!
	{
		var inputString = ""
		
		switch ( self.haiinputStringType )
		{
			case HaiInputStringType.simple:
				if( self.haiSortType == HaiSortType.sort )
				{
					inputString = MahjongKeyboardTextUtility.getInputStringSimpleOmission( self.model.cueerntEditing )
				}
				else
				{
					inputString = MahjongKeyboardTextUtility.getInputStringSimple( self.model.cueerntEditing )
				}
			case HaiInputStringType.accsiArt1:
				inputString = MahjongKeyboardTextUtility.getInputStringAssciArt1( self.model.cueerntEditing )
			case HaiInputStringType.accsiArt2:
				inputString = MahjongKeyboardTextUtility.getInputStringAssciArt2( self.model.cueerntEditing )
			default:
				break;
		}
		
		if( 0 < countElements( inputString ) )
		{
			// 局の詳細入力が有効の場合、詳細情報を後ろに追加
			if( self.model.cueerntEditing.isDetailOutput )
			{
				let detailString:String = MahjongKeyboardTextUtility.getOutputDetail( self.model.cueerntEditing )
				inputString += detailString
			}
			
			// 入力履歴に追加
			self.model.registerHaiHistory()
			self.situationHistoryChangedDelegate?.changedSituationHistory( self.model.situationHistory )
		}
		else
		{
			// 入力する内容が存在しない場合、改行する
			inputString += "\n"
		}
		return inputString
	}
	
	
}
