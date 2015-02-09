//
//  DeviceUtility.swift
//  MahjongKeyboardApp
//
//  Created by tatsuya tezuka on 2015/02/02.
//  Copyright (c) 2015年 entupset. All rights reserved.
//

import UIKit

/**
	デバイスの種別
*/
enum DeviceType : Int
{
	case unknown	// 不明
	case iPhone4s	// iPhone4s    320x480
	case iPhone5	// iPhone5/s/c 320x568
	case iPhone6	// iPhone6     375x667
	case iPhone6Plus// iPhone6plus 424x736
}

/**
	デバイス判定を行うユーティリティクラス
*/
class DeviceUtility
{
	/**
		デバイスの諸別を返します
	*/
	class func getDeviceType() -> DeviceType
	{
		let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
		var deviceType = DeviceType.unknown
		
		if( myBoundSize.width == 320 )
		{
			if( myBoundSize.height == 480 )
			{
				deviceType = DeviceType.iPhone4s
			}
			else
			{
				deviceType = DeviceType.iPhone5
			}
		}
		else if( myBoundSize.width == 375 )
		{
			deviceType = DeviceType.iPhone6
		}
		else if( myBoundSize.width == 414 )
		{
			deviceType = DeviceType.iPhone6Plus
		}
		else
		{
			deviceType = DeviceType.unknown
		}
		return deviceType
	}
}
