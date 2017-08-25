//
//  String+Range.swift
//  StringRangeDemo-Swift4
//
//  Created by JiongXing on 2017/8/25.
//  Copyright © 2017年 JiongXing. All rights reserved.
//

import Foundation

extension String {
    /// 顺序查找指定子串，每个字符只扫描一次，不重复扫描。返回Range数组
    func ranges(of string: String) -> [Range<String.Index>] {
        var rangeArray = [Range<String.Index>]()
        var searchedRange: Range<String.Index>
        guard let sr = self.range(of: self) else {
            return rangeArray
        }
        searchedRange = sr
        
        var resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        while let range = resultRange {
            rangeArray.append(range)
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        }
        return rangeArray
    }
    
    /// 顺序查找指定子串，每个字符只扫描一次，不重复扫描。返回NSRange数组
    func nsranges(of string: String) -> [NSRange] {
        return ranges(of: string).map { (range) -> NSRange in
            self.nsrange(fromRange: range)
        }
    }
    
    /// 把Range转成NSRange
    func nsrange(fromRange range : Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}
