
//  MahjongKeyboardModel.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/18.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import Foundation

/**
	牌の整列
*/
enum HaiType : Int
{
	case manzu_1 = 1	//!< 一萬
	case manzu_2 = 2	//!< 二萬
	case manzu_3 = 3	//!< 三萬
	case manzu_4 = 4	//!< 四萬
	case manzu_5 = 5	//!< 五萬
	case manzu_6 = 6	//!< 六萬
	case manzu_7 = 7	//!< 七萬
	case manzu_8 = 8	//!< 八萬
	case manzu_9 = 9	//!< 九萬
	
	case pinzu_1 = 11	//!< 一筒
	case pinzu_2 = 12	//!< 二筒
	case pinzu_3 = 13	//!< 三筒
	case pinzu_4 = 14	//!< 四筒
	case pinzu_5 = 15	//!< 五筒
	case pinzu_6 = 16	//!< 六筒
	case pinzu_7 = 17	//!< 七筒
	case pinzu_8 = 18	//!< 八筒
	case pinzu_9 = 19	//!< 九筒
	
	case souzu_1 = 21	//!< 一索
	case souzu_2 = 22	//!< 二索
	case souzu_3 = 23	//!< 三索
	case souzu_4 = 24	//!< 四索
	case souzu_5 = 25	//!< 五索
	case souzu_6 = 26	//!< 六索
	case souzu_7 = 27	//!< 七索
	case souzu_8 = 28	//!< 八索
	case souzu_9 = 29	//!< 九索
	
	case other_1 = 31	//!< 東
	case other_2 = 32	//!< 西
	case other_3 = 33	//!< 西
	case other_4 = 34	//!< 北
	case other_5 = 35	//!< 白
	case other_6 = 36	//!< 発
	case other_7 = 37	//!< 中
	case other_8 = 38	//!< 牌裏側(現状未使用)
	case other_9 = 39	//!< ポッチ(現状未使用)
	
	/**
		自身が萬子か否かを判定する
		@return 自身が萬子か否か
	*/
	func isManzu() -> Bool
	{
		var isCheck = false
		if( ( HaiType.manzu_1.rawValue <= self.rawValue )
			&& ( self.rawValue <= HaiType.manzu_9.rawValue ) )
		{
			isCheck = true
		}
		return isCheck
	}
	
	/**
		自身が筒子か否かを判定する
		@return 自身が萬子か否か
	*/
	func isPinzu() -> Bool
	{
		var isCheck = false
		if( ( HaiType.pinzu_1.rawValue <= self.rawValue )
			&& ( self.rawValue <= HaiType.pinzu_9.rawValue ) )
		{
			isCheck = true
		}
		return isCheck
	}
	
	/**
		自身が索子か否かを判定する
		@return 自身が萬子か否か
	*/
	func isSouzu() -> Bool
	{
		var isCheck = false
		if( ( HaiType.souzu_1.rawValue <= self.rawValue )
			&& ( self.rawValue <= HaiType.souzu_9.rawValue ) )
		{
			isCheck = true
		}
		return isCheck
	}
	
	/**
		自身がその他牌か否かを判定する
		@return 自身がその他牌か否か
	*/
	func isOther() -> Bool
	{
		var isCheck = false
		if( ( HaiType.other_1.rawValue <= self.rawValue )
			&& ( self.rawValue <= HaiType.other_9.rawValue ) )
		{
			isCheck = true
		}
		return isCheck
	}
}

/**
	牌のカテゴリ
*/
enum HaiCategory : String
{
	case none  = "none"		//!< 未設定
	case manzu = "manzu"	//!< 萬子
	case pinzu = "pinzu"	//!< 筒子
	case souzu = "souzu"	//!< 索子
	case other = "other"	//!< その他
}

/**
	牌
*/
class Hai : NSObject, NSCoding, NSCopying
{
	var haiType:HaiType	//!< 牌の種別
	var isRed:Bool		//!< 赤牌か否か

	let haiImageIndex:Int32 = 1 //!< 牌の画像番号
	// (TODO: 牌の画像セットを増やす場合は、この値を可変にする)

	let imageExtention:String = ".png" //!< 牌の画像拡張子
	
	//シリアライズ用識別子
	let haiTypeName:String = "haiType"
	let isRedName:String   = "isRed"
	
	init( _haiType:HaiType, _isRed:Bool )
	{
		self.haiType = _haiType
		self.isRed = _isRed

		if( Hai.isRegisterRed( self.haiType ) == false )
		{
			self.isRed = false
		}
	}
	
	/**
		シリアライズにおけるデータ復元時に呼ばれます
		@see NSCoding
	*/
	required init(coder decoder: NSCoder)
	{
		self.haiType = HaiType( rawValue: ( decoder.decodeObjectForKey( haiTypeName ) as Int) )!
		self.isRed = decoder.decodeBoolForKey(isRedName)
		super.init()
	}
	
	/**
		シリアライズにおけるデータ保存時に呼ばれます
		@see NSCoding
	*/
	func encodeWithCoder(coder: NSCoder)
	{
		coder.encodeObject(self.haiType.rawValue, forKey: haiTypeName )
		coder.encodeBool( self.isRed, forKey: isRedName)
	}
	
	/**
		自身の情報をコピーした別インスタンスを生成します
		@see NSCopying
	*/
	func copyWithZone(zone: NSZone) -> AnyObject
	{
		var newInstance = Hai( _haiType: self.haiType, _isRed: self.isRed )
		return newInstance
	}

	/**
		赤牌の設定可否を調べる
		@param haiType チェック対象の牌種別
		@return 赤牌の設定可否
	*/
	class func isRegisterRed( haiType:HaiType ) -> Bool
	{
		var redEnable = false
		if( ( haiType == HaiType.manzu_5 )
		||  ( haiType == HaiType.pinzu_5 )
		||  ( haiType == HaiType.souzu_5 ) )
		{
			redEnable = true
		}
		return redEnable
	}
	
	/**
		牌のカテゴリ文字列をまとめて返します
		@return 牌のカテゴリ文字列
	*/
	class func getHaiCategoryArray() -> Array<String>
	{
		let arrayHaiCategory:Array<String> =
		[
			HaiCategory.manzu.rawValue,
			HaiCategory.pinzu.rawValue,
			HaiCategory.souzu.rawValue,
			HaiCategory.other.rawValue
		]
		return arrayHaiCategory
	}

	/**
		牌のカテゴリに対応する牌の個数を返します
		@param  categoryName カテゴリ名
		@return カテゴリに対応する牌の個数
	*/
	class func getHaiCategoryCount( categoryName:String ) -> Int
	{
		var count = 9
		if( categoryName == HaiCategory.other.rawValue )
		{
			count = 7
		}
		return count
	}
	
	/**
		牌のリソースファイル名を返します
		@return リソースファイル名
	*/
	func getResourceName() -> String
	{
		var resourceName:String = NSString(format: "%02d_", self.haiImageIndex )
		let index = self.haiType.rawValue % 10
		if( self.haiType.isManzu() == true )
		{
			resourceName += HaiCategory.manzu.rawValue
		}
		if( self.haiType.isPinzu() == true )
		{
			resourceName += HaiCategory.pinzu.rawValue
		}
		if( self.haiType.isSouzu() == true )
		{
			resourceName += HaiCategory.souzu.rawValue
		}
		if( self.haiType.isOther() == true )
		{
			resourceName += HaiCategory.other.rawValue
		}
		resourceName += NSString(format: "_%02d", index)

		if( self.isRed )
		{
			resourceName += "_red"
		}

		resourceName += imageExtention
		return resourceName
	}
}

/**
	局の詳細情報 風
*/
enum DetailKaze : Int
{
	case ton	//!< 東
	case nan	//!< 南
	case shaa	//!< 西
	case pei	//!< 北
}

/**
	入力モード
*/
enum HaiInputStringType : Int
{
	case simple		//!< 通常
	case accsiArt1	//!< アスキーアート1
	case accsiArt2	//!< アスキーアート2
}

/**
	牌の自動整列
*/
enum HaiSortType : Int
{
	case sort		//!< 整列する
	case unsort		//!< 整列しない
}

/**
	牌の入力状況。局の詳細情報も含む
*/
class MahjongSituation : NSObject, NSCoding, NSCopying
{
	/// 入力された牌候補
	var haiList: Array< Hai > = Array< Hai >()
	
	/// 局の詳細入力オン・オフ
	var isDetailOutput:Bool = false

	/// 局の詳細 風
	var detailKaze:DetailKaze = DetailKaze.ton

	/// 局の詳細 局目
	var detailKyokume:Int32 = 1

	/// 局の詳細 巡目
	var detailJunme:Int32 = 1

	/// 局の詳細 ドラ
	var detailDora:Hai = Hai( _haiType: HaiType.manzu_1, _isRed: false )

	/// 局の詳細 ツモ牌 (v1.1以降)
	var detailTsumo:Hai = Hai( _haiType: HaiType.manzu_1, _isRed: false )
	
	//シリアライズ用識別子
	let typename_haiList = "haiList"
	let typename_isDetailOutput = "isDetailOutput"
	let typename_detailKaze = "detailKazeName"
	let typename_detailKyokume = "detailKyokume"
	let typename_detailJunme = "detailJunme"
	let typename_detailDora = "detailDora"
	let typename_detailTsumo = "detailTsumo"
	
	override init()
	{
	}
	
	/**
		シリアライズにおけるデータ復元時に呼ばれます
		@see NSCoding
	*/
	required init(coder decoder: NSCoder)
	{
		super.init()
		
		self.haiList = decoder.decodeObjectForKey( self.typename_haiList ) as Array< Hai >!
		
		self.isDetailOutput = decoder.decodeBoolForKey( self.typename_isDetailOutput )
		self.detailKaze = DetailKaze( rawValue: ( decoder.decodeObjectForKey( self.typename_detailKaze ) as Int) )!
		self.detailKyokume = decoder.decodeIntForKey( self.typename_detailKyokume )
		self.detailJunme = decoder.decodeIntForKey( self.typename_detailJunme )

		self.detailDora = decoder.decodeObjectForKey( self.typename_detailDora ) as Hai

		// v1.1 以降追加パラメータ
		if let detailTsumoLoad = decoder.decodeObjectForKey( self.typename_detailTsumo ) as Hai?
		{
			self.detailTsumo = detailTsumoLoad
		}
	}
	
	/**
		シリアライズにおけるデータ保存時に呼ばれます
		@see NSCoding
	*/
	func encodeWithCoder(coder: NSCoder)
	{
		coder.encodeObject( self.haiList, forKey: self.typename_haiList )
		
		coder.encodeBool( self.isDetailOutput, forKey: self.typename_isDetailOutput )
		coder.encodeObject( self.detailKaze.rawValue, forKey: self.typename_detailKaze )
		coder.encodeInt( self.detailKyokume, forKey: self.typename_detailKyokume )
		coder.encodeInt( self.detailJunme, forKey: self.typename_detailJunme )
		coder.encodeObject( self.detailDora, forKey: self.typename_detailDora )
		coder.encodeObject( self.detailTsumo, forKey: self.typename_detailTsumo )
	}
	
	/**
		自身の情報をコピーした別インスタンスを生成します
		@see NSCopying
	*/
	func copyWithZone(zone: NSZone) -> AnyObject
	{
		var newInstance = MahjongSituation()
		
		newInstance.haiList = Array< Hai >()
		for hai in haiList
		{
			newInstance.haiList.append( hai.copy() as Hai )
		}
		
		newInstance.isDetailOutput = self.isDetailOutput
		newInstance.detailKaze = self.detailKaze
		newInstance.detailKyokume = self.detailKyokume
		newInstance.detailJunme = self.detailJunme
		newInstance.detailDora = self.detailDora
		newInstance.detailTsumo = self.detailTsumo
		return newInstance
	}
	
	/**
		局の詳細入力オン・オフを切り替えます
	*/
	func toggleDetailOutput()
	{
		self.isDetailOutput = !self.isDetailOutput
	}
	
	/**
		牌候補のソートを行います
	*/
	func sortHaiArray()
	{
		sort( &self.haiList )
			{
				(hai1 : Hai, hai2 : Hai) -> Bool in
				return hai1.haiType.rawValue < hai2.haiType.rawValue
		}
	}

	/**
		状態をログ出力します
	*/
	func dump()
	{
		println("[MahjongSituation]")
		println("isDetailOutput \(self.isDetailOutput)")
		println("detailKaze \(self.detailKaze)")
		println("detailKyokume \(self.detailKyokume)")
		println("detailJunme \(self.detailJunme)")
		println("detailDora \(self.detailDora.haiType.rawValue)")
		println("detailTsumo \(self.detailTsumo.haiType.rawValue)")
		
		println("haiList count \(self.haiList.count)")
		for (index, hai) in enumerate(self.haiList)
		{
			println("index \(index), hai.haiType \(hai.haiType.rawValue) hai.isRed \(hai.isRed) ")
		}
	}
}

/**
	MahjongKeyboardにおけるデータモデル
*/
class MahjongKeyboardModel
{
	let haiMax = 32		//!< 牌の最大数
	let historyMax = 20 //!< 入力履歴の最大数
 
	/// 現在編集中の牌の入力状況
	var cueerntEditing:MahjongSituation = MahjongSituation()

	/// 入力履歴
	var situationHistory: Array<MahjongSituation> = Array<MahjongSituation>()
	
	//シリアライズ用識別子
	let key_currentEditing   = "currentEditing"
	let key_situationHistory = "situationHistory"

	/**
		牌候補に牌を追加する
		@param hai 追加する牌
	*/
	func addCurrentEditingHai( hai:Hai )
	{
		if( self.cueerntEditing.haiList.count < self.haiMax )
		{
			self.cueerntEditing.haiList.append( hai )
			self.saveCurrentEditing()
		}
	}
	
	/**
		牌候補から指定位置の牌を削除する
		@param removeIndex 削除位置
	*/
	func removeHaiFromIndex( removeIndex:Int )
	{
		if( removeIndex < self.cueerntEditing.haiList.count )
		{
			self.cueerntEditing.haiList.removeAtIndex(removeIndex)
			self.saveCurrentEditing()
		}
	}
	
	/**
		牌候補から最後尾の牌を削除する
	*/
	func removeLastCurrentEditing()
	{
		if( 0 < self.cueerntEditing.haiList.count )
		{
			self.cueerntEditing.haiList.removeLast()
			self.saveCurrentEditing()
		}
	}

	/**
		牌候補を全削除する
	*/
	func removeAllCurrentEditing()
	{
		self.cueerntEditing.haiList.removeAll(keepCapacity:false)
		self.saveCurrentEditing()
	}

	/**
		牌候補をソートする
	*/
	func sortCurrentEditing()
	{
		self.cueerntEditing.sortHaiArray()
		self.saveCurrentEditing()
	}
	
	/**
		現在の状況を、入力履歴に追加します
	*/
	func registerHaiHistory()
	{
		self.situationHistory.insert( cueerntEditing.copy() as MahjongSituation, atIndex: 0 )
		if( self.historyMax < self.situationHistory.count)
		{
			self.situationHistory.removeLast()
		}
		self.saveSituationHistory()
	}
	
	/**
		入力履歴を牌候補に反映させます
		@param index 反映させる入力履歴の位置
	*/
	func historyToCurrent(index:Int)
	{
		if( index < self.situationHistory.count )
		{
			self.cueerntEditing = self.situationHistory[index].copy() as MahjongSituation
			self.saveCurrentEditing()
		}
	}

	/**
		現在の入力状態を保存します
	*/
	private func saveCurrentEditing()
	{
		let sharedDefaults:NSUserDefaults? = NSUserDefaults.standardUserDefaults()
		
		var data : NSData = NSKeyedArchiver.archivedDataWithRootObject( self.cueerntEditing )
		sharedDefaults?.setObject( data, forKey: self.key_currentEditing )
		sharedDefaults?.synchronize()
		
		LogUtility.debug( self, log: "[saveCurrentEditing] data.length \(data.length)")
	}
	
	/**
		現在の入力状態を復元します
	*/
	func loadCurrentEditing()
	{
		let sharedDefaults:NSUserDefaults? = NSUserDefaults.standardUserDefaults()
		if let data:NSData = sharedDefaults?.objectForKey(self.key_currentEditing) as NSData?
		{
			if( 0 < data.length )
			{
				LogUtility.debug( self, log: "[loadCurrentEditing] data.length \(data.length)")
				
				let cueerntEditing : AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData( data )
				self.cueerntEditing  = cueerntEditing as MahjongSituation
				// self.dump()
			}
			else
			{
				LogUtility.debug( self, log: "[loadCurrentEditing] objectForKey error data.length is 0")
			}
		}
		else
		{
			LogUtility.debug( self, log: "[loadCurrentEditing] sharedDefaults is nil")
		}
	}
	
	/**
		入力履歴を保存します
	*/
	private func saveSituationHistory()
	{
		// TODO: suiteNameを使用してアプリ間とデータ連携すると、アプリ側でエラーとなった
		// 当面データ共有は使用しないが、要調査
		//	let sharedDefaults:NSUserDefaults? = NSUserDefaults(suiteName: self.suiteName)
		let sharedDefaults:NSUserDefaults? = NSUserDefaults.standardUserDefaults()
		
		var data : NSData = NSKeyedArchiver.archivedDataWithRootObject( self.situationHistory )
		sharedDefaults?.setObject( data, forKey: self.key_situationHistory )
		sharedDefaults?.synchronize()

		LogUtility.debug( self, log: "[saveSituationHistory] data.length \(data.length)")

		// self.dump()
	}
	
	/**
		入力履歴を復元します
	*/
	func loadSituationHistory()
	{
		// TODO: suiteNameを使用してアプリ間とデータ連携すると、アプリ側でエラーとなった
		// 当面データ共有は使用しないが、要調査
		//let sharedDefaults:NSUserDefaults? = NSUserDefaults(suiteName: self.suiteName)

		let sharedDefaults:NSUserDefaults? = NSUserDefaults.standardUserDefaults()
		if let data:NSData = sharedDefaults?.objectForKey(self.key_situationHistory) as NSData?
		{
			if( 0 < data.length )
			{
				LogUtility.debug( self, log: "[loadSituationHistory] data.length \(data.length)")

				let situationHistory : AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData( data )
				self.situationHistory  = situationHistory as Array< MahjongSituation>

				// self.dump()
			}
			else
			{
				LogUtility.debug( self, log: "[loadSituationHistory] objectForKey error data.length is 0")
			}
		}
		else
		{
			LogUtility.debug( self, log: "[loadSituationHistory] sharedDefaults is nil")
		}
	}

	/**
		状態をログ出力します
	*/
	func dump()
	{
		println("[MahjongKeyboardModel]")
		println("cueerntEditing:")
		self.cueerntEditing.dump()

		println("situationHistory count \(self.situationHistory.count)")
		for (index, situation) in enumerate(self.situationHistory)
		{
			println("situation index \(index)")
			situation.dump()
		}
	}
}






