//
//  MahjongKeyboardDelegate.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/02/04.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import Foundation

/// 牌候補の変更依頼を受け付けるデリゲート
protocol CandidateOperationDelegate
{
	/**
		牌候補への追加要求時に呼ばれます
		@param hai 追加する牌
	*/
	func requestAddHai( hai:Hai )

	/**
		牌候補に対して、指定位置の削除要求時に呼ばれます
		@param removeIndex 牌削除位置
	*/
	func requestRemoveHaiFromIndex( removeIndex:Int )

	/**
		現在の牌候補取得要求時に呼ばれます
	*/
	func requestCurrentCandidate()
}

/// 牌候補の変更完了を通知するデリゲート
protocol CandidateChangedDelegate
{
	/**
		牌入力候補の変更後に呼ばれます
		@param candidate  変更後の牌入力候補
	*/
	func changedCandidate( candidate: Array< Hai > )
}

/// 各種モードの変更完了を通知するデリゲート
protocol ModeChangedDelegate
{
	/**
		入力モードの変更後に呼ばれます
		@param HaiInputStringType 変更後の状態
	*/
	func changedInputMode( haiInputStringType:HaiInputStringType )

	/**
		自動整列の有効・無効 変更後に呼ばれます
		@param haiSortType 変更後の状態
	*/
	func changedSortMode( haiSortType:HaiSortType )
}

/// 局の詳細の変更依頼を受け付けるデリゲート
protocol DetailOperationDelegate
{
	/**
		局の詳細入力オン・オフ 切り替え要求時に呼ばれます
	*/
	func requestChanhgeDetailOnOff()
	/**
		風の変更要求時に呼ばれます
		@param kaze 変更する風
	*/
	func requestChanhgeDetailKaze(kaze:DetailKaze)
	/**
		局目の変更要求時に呼ばれます
		@param kyokume 変更する局目
	*/
	func requestChanhgeDetailKyokume(kyokume:Int32)
	/**
		巡目の変更要求時に呼ばれます
		@param junme 変更する巡目
	*/
	func requestChanhgeDetailJunme(junme:Int32)
	/**
		ドラの変更要求時に呼ばれます
		@param hai 変更するドラ
	*/
	func requestChanhgeDetailDora(hai:Hai)
	/**
		ツモ牌の変更要求時に呼ばれます
		@param hai 変更するツモ牌
	*/
	func requestChanhgeDetailTsumo(hai:Hai)
	/**
		現在の局詳細情報 取得要求時に呼ばれます
	*/
	func requestCurrentDetail()
}

/// 局の詳細情報 変更完了を通知するデリゲート
protocol DetailChangedDelegate
{
	/**
		局の詳細入力 有効・無効 状態変更時に呼ばれます
		@param  isDetailOutput  局の詳細入力 有効・無効
	*/
	func changedDetailOutput( isDetailOutput:Bool )

	/**
		風の状態変更時に呼ばれます
		@param  detailKaze 変更後の風
	*/
	func changedKaze( detailKaze:DetailKaze )

	/**
		局目の変更時に呼ばれます
		@param  kyokume 変更後の局目
	*/
	func changedKyokume( kyokume:Int32 )

	/**
		巡目の変更時に呼ばれます
		@param  junme 変更後の巡目
	*/
	func changedJunme( junme:Int32 )

	/**
		ドラの変更時に呼ばれます
		@param  hai 変更後のドラ
	*/
	func changedDora( hai:Hai )

	/**
		ツモ牌の変更時に呼ばれます
		@param  hai 変更後のドラ
	*/
	func changedTsumo( hai:Hai )
}

/// 入力履歴の詳細の変更依頼を受け付けるデリゲート
protocol SituationHistoryOperationDelegate
{
	/**
		入力履歴を牌候補に反映 の要求時に呼ばれます
		@param historyIndex 反映対象の履歴の位置
	*/
	func requestHistoryToCurrent( historyIndex:Int )

	/**
		現在の牌候補取得要求時に呼ばれます
		@see SituationHistoryOperationDelegate
	*/
	func requestCurrentSituationHistory()
}

/// 入力履歴 変更完了を通知するデリゲート
protocol SituationHistoryChangedDelegate
{
	/**
		入力履歴の変更後に呼ばれます
		@param candidate  変更後の入力履歴
	*/
	func changedSituationHistory( situationHistory:Array<MahjongSituation> )
}

/// 共通操作の変更依頼を受け付けるデリゲート
protocol CommonOperationDelegate
{
	/**
		次のキーボード 要求時に呼ばれます
	*/
	func requestNextKeuboard()

	/**
		入力モード切り替え 要求時に呼ばれます
	*/
	func requestTextOutputModeChange()

	/**
		整列モード切り替え 要求時に呼ばれます
	*/
	func requestSortModeChange()

	/**
		カーソル移動要求時に呼ばれます
		@param positionOffset カーソル移動量
	*/
	func requestCursolPositionChange( positionOffset:Int )

	/**
		文字削除要求時に呼ばれます
	*/
	func requestRemoveWord()

	/**
		編集しているテキストの入力要求時に呼ばれます
	*/
	func requestInputText()

	/**
		指定テキストの直接入力要求時に呼ばれます
		@param text 入力対象のテキスト
	*/
	func requestInputTextWithString( text:String)
}

/// カスタムキーボード直接操作の変更依頼を受け付けるデリゲート
protocol CustomKeyboardOperationDelegate
{
	/*
		次のキーボード 要求時に呼ばれます
	*/
	func requestNextKeyboard()

	/**
		カーソル移動要求時に呼ばれます
		@param positionOffset カーソル移動量
	*/
	func requestCursolPositionChange( positionOffset:Int )

	/**
		編集しているテキストの入力要求時に呼ばれます
	*/
	func requestRemoveWord()

	/**
		指定テキストの直接入力要求時に呼ばれます
		@param text 入力対象のテキスト
	*/
	func requestInputText( text:String )
}

/// 入力画面の切り替え依頼を受け付けるデリゲート
protocol InputViewChangeDelegate
{
	/**
		入力操作の切り替えを行います
		@param  moveType 変更時の操作の方向
	*/
	func requestInputViewChange( baseOperationChangeType:BaseOperationChangeType )
}

