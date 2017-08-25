# StringRangeDemo
Swift字符串查找所有子串及Range转换成NSRange

使用到一个关键的方法：

```swift
range(of: string, options: , range: , locale: )
```

这个方法在给定给定范围内查找子串，并在查到第一个子串时返回Range类型的结果。

如此一来，我们只需要不断改变查找范围，把每一次查找得到的Range都记录下来，最终就能得到所有Range。

1、初始化时先设置查找范围为整个字符串
2、若能通过查找得到子串的Range，进入循环
3、保存子串Range到数组
4、缩小查找范围，减掉已经查找过的区域
5、在缩小的范围内查找子串
6、若能在缩小的范围内找到子串，继续下一轮循环

```swift
extension String {
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
}
```

# 把Range转换成NSRange

## Swift3的转换方法：
OC常用的NSRange不依赖于任何类型，独立成型，要创建一个NSRange只需要给出区间起始点，以及区间长度即可，而这两个值都是整型。

```objc
NSMakeRange(3, 5)
```

但是Swift新增的Range类型，是建立在其它类型的基础上，是对其它类型的描述。
在本文，Range通过range(of string)而取得，依赖于String。要把它转换成独立的NSRange，需要分别对其`lowerBound`和`upperBound`通过`String.UTF16View`来转换成整型。
```swift
extension String {
    func nsrange(fromRange range : Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = String.UTF16View.Index(range.lowerBound, within: utf16view)
        let to = String.UTF16View.Index(range.upperBound, within: utf16view)
        return NSMakeRange(utf16view.startIndex.distance(to: from), from.distance(to: to))
    }
}
```

## Swift4的转换方法：
苹果在Swift4对字符串作了很大改动，字符串变回了集合类型，相应地其很多api都发生了变化，这是题外话了...
在Swift4，苹果增加了api直接支持把Range转换成NSRange，它是NSRange的构造方法：
```swift
NSRange(range, in: string)
```
给构造方法传入range以及这个range相应的string即可。
所以到了Swift4，把方法重构一下，只需要一行代码：
```swift
extension String {
    func nsrange(fromRange range : Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}
```

此时可以顺便添加一个方法，在String中查找子串，返回NSRange数组：
```swift
extension String {
    func nsranges(of string: String) -> [NSRange] {
        return ranges(of: string).map { (range) -> NSRange in
            self.nsrange(fromRange: range)
        }
    }
}
```

# 测试一下
```
let text = "😊连续的降雨把佛罗里达州的迈阿卡河州立公园变成了一个水世界。迈阿卡河州立公园😊是佛罗里达最古老、最大型的公园之一😊，绵延3.7万英亩。这里有各种各样的自然特征，包括一片森林湿地，也叫做沼泽生态系统💐，是由各种各样的树木组成的一种美妙的自然生态系统。"

let ranges = text.ranges(of: "😊")
print("------ ranges of 😊 :\(ranges.count) ------")
dump(ranges)

let nsranges = text.nsranges(of: "😊")
print("------ nsranges of 😊 :\(nsranges.count) ------")
dump(nsranges)
```

![swift3运行结果](http://upload-images.jianshu.io/upload_images/2419179-7c1340f1cb5824de.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![swift4的NSRange](http://upload-images.jianshu.io/upload_images/2419179-c9c32f42a755ba52.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
