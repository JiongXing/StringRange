//
//  main.swift
//  StringRangeDemo-Swift4
//
//  Created by JiongXing on 2017/8/25.
//  Copyright © 2017年 JiongXing. All rights reserved.
//

import Foundation

let text = "😊连续的降雨把佛罗里达州的迈阿卡河州立公园变成了一个水世界。迈阿卡河州立公园😊是佛罗里达最古老、最大型的公园之一😊，绵延3.7万英亩。这里有各种各样的自然特征，包括一片森林湿地，也叫做沼泽生态系统💐，是由各种各样的树木组成的一种美妙的自然生态系统。"

let ranges = text.ranges(of: "😊")
print("------ ranges of 😊 :\(ranges.count) ------")
dump(ranges)

let nsranges = text.nsranges(of: "😊")
print("------ nsranges of 😊 :\(nsranges.count) ------")
dump(nsranges)

