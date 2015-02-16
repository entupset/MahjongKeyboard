//
//  MahjongKeyboardTextUtility.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/01/20.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import Foundation

/**
	表示文字列の変換処理をまとめたユーティリティクラス

@note 表示する文字はこのクラスにまとめて、他のクラスでハードコードしないこと
*/
class MahjongKeyboardTextUtility
{
	/**
		通常入力に対応する、牌の文字列を取得する
	@param  牌の種別
	@return 牌の文字列
	*/
	class func getSimpleString( haiType:HaiType ) -> String
	{
		var haiString = "";
		switch( haiType )
		{
			case HaiType.manzu_1:
				haiString = "1M";
			case HaiType.manzu_2:
				haiString = "2M";
			case HaiType.manzu_3:
				haiString = "3M";
			case HaiType.manzu_4:
				haiString = "4M";
			case HaiType.manzu_5:
				haiString = "5M";
			case HaiType.manzu_6:
				haiString = "6M";
			case HaiType.manzu_7:
				haiString = "7M";
			case HaiType.manzu_8:
				haiString = "8M";
			case HaiType.manzu_9:
				haiString = "9M";
				
			case HaiType.pinzu_1:
				haiString = "1P";
			case HaiType.pinzu_2:
				haiString = "2P";
			case HaiType.pinzu_3:
				haiString = "3P";
			case HaiType.pinzu_4:
				haiString = "4P";
			case HaiType.pinzu_5:
				haiString = "5P";
			case HaiType.pinzu_6:
				haiString = "6P";
			case HaiType.pinzu_7:
				haiString = "7P";
			case HaiType.pinzu_8:
				haiString = "8P";
			case HaiType.pinzu_9:
				haiString = "9P";
				
			case HaiType.souzu_1:
				haiString = "1S";
			case HaiType.souzu_2:
				haiString = "2S";
			case HaiType.souzu_3:
				haiString = "3S";
			case HaiType.souzu_4:
				haiString = "4S";
			case HaiType.souzu_5:
				haiString = "5S";
			case HaiType.souzu_6:
				haiString = "6S";
			case HaiType.souzu_7:
				haiString = "7S";
			case HaiType.souzu_8:
				haiString = "8S";
			case HaiType.souzu_9:
				haiString = "9S";
				
			case HaiType.other_1:
				haiString = "東";
			case HaiType.other_2:
				haiString = "南";
			case HaiType.other_3:
				haiString = "西";
			case HaiType.other_4:
				haiString = "北";
			case HaiType.other_5:
				haiString = "白";
			case HaiType.other_6:
				haiString = "発";
			case HaiType.other_7:
				haiString = "中";
			case HaiType.other_8:
				haiString = "・";
			case HaiType.other_9:
				haiString = "裏";
				
			default:
				break
		}
		return haiString
	}
	
	/**
		アスキーアート入力に対応する、牌の文字列を取得する
	@param  牌の種別
	@return 牌の文字列
	*/
	class func getAssciArtTopString( haiType:HaiType ) -> String
	{
		var haiString = "";
		switch( haiType )
		{
			case HaiType.manzu_1:
				haiString = "一";
			case HaiType.manzu_2:
				haiString = "二";
			case HaiType.manzu_3:
				haiString = "三";
			case HaiType.manzu_4:
				haiString = "四";
			case HaiType.manzu_5:
				haiString = "五";
			case HaiType.manzu_6:
				haiString = "六";
			case HaiType.manzu_7:
				haiString = "七";
			case HaiType.manzu_8:
				haiString = "八";
			case HaiType.manzu_9:
				haiString = "九";
				
			case HaiType.pinzu_1:
				haiString = "一";
			case HaiType.pinzu_2:
				haiString = "二";
			case HaiType.pinzu_3:
				haiString = "三";
			case HaiType.pinzu_4:
				haiString = "四";
			case HaiType.pinzu_5:
				haiString = "五";
			case HaiType.pinzu_6:
				haiString = "六";
			case HaiType.pinzu_7:
				haiString = "七";
			case HaiType.pinzu_8:
				haiString = "八";
			case HaiType.pinzu_9:
				haiString = "九";
				
			case HaiType.souzu_1:
				haiString = "一";
			case HaiType.souzu_2:
				haiString = "二";
			case HaiType.souzu_3:
				haiString = "三";
			case HaiType.souzu_4:
				haiString = "四";
			case HaiType.souzu_5:
				haiString = "五";
			case HaiType.souzu_6:
				haiString = "六";
			case HaiType.souzu_7:
				haiString = "七";
			case HaiType.souzu_8:
				haiString = "八";
			case HaiType.souzu_9:
				haiString = "九";
				
			case HaiType.other_1:
				haiString = "東";
			case HaiType.other_2:
				haiString = "南";
			case HaiType.other_3:
				haiString = "西";
			case HaiType.other_4:
				haiString = "北";
			case HaiType.other_5:
				haiString = "白";
			case HaiType.other_6:
				haiString = "発";
			case HaiType.other_7:
				haiString = "中";
			case HaiType.other_8:
				haiString = "・";
			case HaiType.other_9:
				haiString = "裏";
				
			default:
				break
		}
		return haiString
	}
	
	/**
		アスキーアート入力に対応する、牌のカテゴリ文字列を取得する
	@param  牌の種別
	@return 牌の文字列
	*/
	class func getAssciArtBottomString( haiType:HaiType ) -> String
	{
		var haiString = ""
		if( haiType.isManzu() == true )
		{
			haiString = "萬"
		}
		if( haiType.isPinzu() == true )
		{
			haiString = "筒"
		}
		if( haiType.isSouzu() == true )
		{
			haiString = "索"
		}
		if( haiType.isOther() == true )
		{
			haiString = "　"
		}
		return haiString
	}
	
	class func getSimpleCategoryString( haiCategory:String ) -> String
	{
		var categoryString = ""
		if( HaiCategory.manzu.rawValue == haiCategory )
		{
			categoryString = "M"
		}
		else if( HaiCategory.pinzu.rawValue == haiCategory )
		{
			categoryString = "P"
		}
		else if( HaiCategory.souzu.rawValue == haiCategory )
		{
			categoryString = "S"
		}
		return categoryString
	}
	
	class func getRedHaiString() -> String
	{
		return "赤"
	}
	
	/**
		局の詳細文字列を取得する
	@return 局の詳細文字列
	*/
	class func getOutputDetail( situation:MahjongSituation) -> String
	{
		var outputString = MahjongKeyboardTextUtility.getKazeString( situation.detailKaze )
		
		outputString += NSString(format: " %d 局目 %d 順目",
			situation.detailKyokume, situation.detailJunme)
		
		outputString += "ドラ" + MahjongKeyboardTextUtility.getSimpleString( situation.detailDora.haiType )
		outputString += "\n"
		
		return outputString
	}
	
	/**
		風の文字列を取得する
	@param  風の種別
	@return 風の文字列
	*/
	class func getKazeString( detailKaze:DetailKaze ) -> String
	{
		var outputString = ""
		switch( detailKaze )
		{
			case DetailKaze.ton:
				outputString += "東"
			case DetailKaze.nan:
				outputString += "南"
			case DetailKaze.shaa:
				outputString += "西"
			case DetailKaze.pei:
				outputString += "北"
			default:
				break
		}
		outputString += "場"
		return outputString
	}
	
	class func getKyokumeString( kyokume:Int32 ) -> String
	{
		return NSString(format: "%d 局目", kyokume)
	}
	
	class func getJunmeString( junme:Int32 ) -> String
	{
		return NSString(format: "%d 順目", junme)
	}
	
	/**
		局の詳細オン・オフの見出しを取得する
		@return 対応する見出し文字列
	*/
	class func getDetailString( isDetail:Bool ) -> String
	{
		var detailString = ""
		if( isDetail )
		{
			detailString = "局の状況入力 (オン)"
		}
		else
		{
			detailString = "局の状況入力 (オフ)"
		}
		return detailString
	}
	
	/**
		入力モード(通常)における文字列を、同一カテゴリ内は省略して返します
		例えば、萬子は 1M2M3M ではなく 123M とします
		situation.haiList はソートされている前提です
		
		@param  situation 対象の入力状態
		@param  haiSortType 自動整列するか否か
		@return 画面入力する文字列
	*/
	class func getInputStringSimpleOmission( situation:MahjongSituation ) -> String
	{
		var inputString = ""
		
		if( 0 < situation.haiList.count )
		{
			// そのため、次のカテゴリに行く前は数値のみ連結する
			var haiCategory:HaiCategory = HaiCategory.none
			for hai in situation.haiList
			{
				if( hai.isRed == true )
				{
					inputString += MahjongKeyboardTextUtility.getRedHaiString()
				}
				
				let index = hai.haiType.rawValue % 10
				if( hai.haiType.isManzu() == true )
				{
					haiCategory = HaiCategory.manzu
					inputString += NSString(format: "%d", index)
				}
				else
				{
					if( haiCategory == HaiCategory.manzu )
					{
						inputString += MahjongKeyboardTextUtility.getSimpleCategoryString( HaiCategory.manzu.rawValue )
					}
				}
				
				if( hai.haiType.isPinzu() == true )
				{
					haiCategory = HaiCategory.pinzu
					inputString += NSString(format: "%d", index)
				}
				else
				{
					if( haiCategory == HaiCategory.pinzu )
					{
						inputString += MahjongKeyboardTextUtility.getSimpleCategoryString( HaiCategory.pinzu.rawValue )
					}
				}
				if( hai.haiType.isSouzu() == true )
				{
					haiCategory = HaiCategory.souzu
					inputString += NSString(format: "%d", index)
				}
				else
				{
					if( haiCategory == HaiCategory.souzu )
					{
						inputString += MahjongKeyboardTextUtility.getSimpleCategoryString( HaiCategory.souzu.rawValue )
					}
				}
				
				if( hai.haiType.isOther() == true )
				{
					haiCategory = HaiCategory.other
					inputString += MahjongKeyboardTextUtility.getSimpleString( hai.haiType )
				}
			}
			
			// 数牌で終わった場合、末尾に種別をつける
			if( haiCategory == HaiCategory.manzu )
			{
				inputString += MahjongKeyboardTextUtility.getSimpleCategoryString( HaiCategory.manzu.rawValue )
			}
			else if( haiCategory == HaiCategory.pinzu )
			{
				inputString += MahjongKeyboardTextUtility.getSimpleCategoryString( HaiCategory.pinzu.rawValue )
			}
			else if( haiCategory == HaiCategory.souzu )
			{
				inputString += MahjongKeyboardTextUtility.getSimpleCategoryString( HaiCategory.souzu.rawValue )
			}
			inputString += "\n"
		}
		return inputString
	}
	
	/**
		入力モード(通常)における文字列を、ソートせず生成して返します
		@param  situation 対象の入力状態
		@param  haiSortType 自動整列するか否か
		@return 画面入力する文字列
	*/
	class func getInputStringSimple( situation:MahjongSituation ) -> String
	{
		var inputString = ""
		
		if( 0 < situation.haiList.count )
		{
			for hai in situation.haiList
			{
				if( hai.isRed == true )
				{
					inputString += MahjongKeyboardTextUtility.getRedHaiString()
				}
				
				let haiValue = MahjongKeyboardTextUtility.getSimpleString( hai.haiType )
				inputString += haiValue
			}
			inputString += "\n"
		}
		return inputString
	}
	
	/**
		入力モード(アスキーアート1)における文字列を生成して返します
		@param  situation 対象の入力状態
		@return 画面入力する文字列
	*/
	class func getInputStringAssciArt1( situation:MahjongSituation  ) -> String!
	{
		var inputString = ""
		
		if( 0 < situation.haiList.count )
		{
			//一列目
			for hai in situation.haiList
			{
				let haiValue = MahjongKeyboardTextUtility.getAssciArtTopString( hai.haiType )
				inputString += haiValue
			}
			inputString += "\n"
			
			//二列目
			for hai in situation.haiList
			{
				let haiValue = MahjongKeyboardTextUtility.getAssciArtBottomString( hai.haiType )
				inputString += haiValue
			}
			inputString += "\n"
		}
		return inputString
		
	}
	
	/**
		入力モード(アスキーアート2)における文字列を生成して返します
		@param  situation 対象の入力状態
		@return 画面入力する文字列
	*/
	class func getInputStringAssciArt2( situation:MahjongSituation ) -> String!
	{
		var inputString = ""
		
		if( 0 < situation.haiList.count )
		{
			//一列目
			let topLeft    = "┏"
			let topCenter1 = "━"
			let topCenter2 = "┳"
			let topRight   = "┓"
			for ( index, hai ) in enumerate( situation.haiList )
			{
				if( index == 0 )
				{
					inputString += topLeft
				}
				else
				{
					inputString += topCenter2
				}
				inputString += topCenter1
			}
			inputString += topRight
			inputString += "\n"
			
			//二列目
			let separator = "┃"
			for hai in situation.haiList
			{
				inputString += separator
				
				let haiValue = MahjongKeyboardTextUtility.getAssciArtTopString( hai.haiType )
				inputString += haiValue
			}
			inputString += separator
			inputString += "\n"
			
			//三列目
			for hai in situation.haiList
			{
				inputString += separator
				let haiValue = MahjongKeyboardTextUtility.getAssciArtBottomString( hai.haiType )
				inputString += haiValue
			}
			inputString += separator
			inputString += "\n"
			
			//四列目
			let bottomLeft    = "┗"
			let bottomCenter1 = "━"
			let bottomCenter2 = "┻"
			let bottomRight   = "┛"
			for ( index, hai ) in enumerate( situation.haiList )
			{
				if( index == 0 )
				{
					inputString += bottomLeft
				}
				else
				{
					inputString += bottomCenter2
				}
				inputString += bottomCenter1
			}
			inputString += bottomRight
			inputString += "\n"
		}
		return inputString
	}
	
	
	/**
		麻雀用語群を取得する
		@return 麻雀用語群
		@note 用語入力で使用
	*/
	class func getMahjongDictonary() -> Array<String>
	{
		var itemes:Array<String> =
		[
			"立直",
			"一発",
			"門前清模和",
			"断么九",
			"平和",
			"一盃口",
			"役牌",
			"翻牌",
			"嶺上開花",
			"槍槓",
			"海底撈月",
			"河底撈魚",
			"三色同順",
			"一気通貫",
			"混全帯么九",
			"七対子",
			"対々和",
			"三暗刻",
			"混老頭",
			"三色同刻",
			"三槓子",
			"小三元",
			"ダブル立直",
			"混一色",
			"純全帯么九",
			"二盃口",
			"清一色",
			"国士無双",
			"国士無双十三面待ち",
			"四暗刻",
			"四暗刻単騎",
			"大三元",
			"字一色",
			"小四喜",
			"大四喜",
			"緑一色",
			"清老頭",
			"四槓子",
			"九蓮宝燈",
			"天和",
			"地和",
			"流し満貫",
			"人和",
			"三連刻",
			"四連刻",
			"大車輪",
			"八連荘",
			"ドラ",
			"副露",
			"槓",
			"門前",
			"一向聴",
			"聴牌",
			"和了",
			"フリテン",
			"チョンボ",
			"流局",
			"連荘",
			"飛び",
			"ウマ",
			"喰い下がり",
			"喰い替え",
			"スジ",
			"パオ",
			"高点法",
			"頭跳ね",
			"ダブロン",
			"三家和",
			"九種九牌",
			"四風連打",
			"四開槓",
			"四家立直"]
		return itemes
	}
	
	
}

