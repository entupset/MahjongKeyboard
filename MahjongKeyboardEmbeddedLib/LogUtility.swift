//
//  LogUtility.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/02/02.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import Foundation


/**
	ログの出力を行うユーティリティクラス
*/
class LogUtility
{
	/**
		debugログを出力します
		@param v 出力元のクラス
		@param log ログ文字列
	*/
	class func debug(v: Any, log: NSString)
	{
		// このフラグを動作環境に合わせて変更すること
		let debugOutput = false
		if( debugOutput )
		{
			let logString = LogUtility.getLogString(v, log: log)
			println( "D: " + logString )
		}
	}

	/**
		warning(警告)ログを出力します
		@param v 出力元のクラス
		@param log ログ文字列
	*/
	class func warning(v: Any, log: NSString)
	{
		// このフラグを動作環境に合わせて変更すること
		let warningOutput = false
		if( warningOutput )
		{
			let logString = LogUtility.getLogString(v, log: log)
			println( "W: " + logString )
		}
	}
	
	/**
		fatal(致命的エラー)ログを出力します
		@param v 出力元のクラス
		@param log ログ文字列
	*/
	class func fatal(v: Any, log: NSString)
	{
		// このフラグを動作環境に合わせて変更すること
		let fatalOutput = true
		if( fatalOutput )
		{
			let logString = LogUtility.getLogString(v, log: log)
			println( "F: " + logString )
		}
	}

	/**
		クラス名称を返します
		@param v クラス名判定対象のクラス
		@return クラス名
	*/
	private class func getTypeName( v: Any ) -> String
	{
		let fullName = _stdlib_demangleName(_stdlib_getTypeName(v))
		if let range = fullName.rangeOfString(".")
		{
			return fullName.substringFromIndex(range.endIndex)
		}
		return fullName
	}
	
	/**
		クラス名称とログを連結します
		@param v ログ出力元のクラス
		@param log ログ文字列
		@return クラス名と文字列を特定フォーマットで連結して返す
	*/
	private class func getLogString( v: Any, log: NSString ) -> String
	{
		let className = LogUtility.getTypeName(v)
		return ( className + " : " + log )
	}
}
