
//
//  TextBlock.swift
//  Ticket
//
//  Created by gix on 2019/6/30.
//  Copyright © 2019 gix. All rights reserved.
//

import Foundation

public struct Text: BlockDataProvider {
    
    let content: String
    let attributes: [Attribute]?
    
    public init(_ content: String, attributes: [Attribute]? = nil) {
        self.content = content
        self.attributes = attributes
    }
    
    public func data(using encoding: String.Encoding) -> Data {
        var result = Data()
        
        if let attrs = attributes {
            result.append(Data(attrs.flatMap { $0.attribute }))
        }
        
        if let cd = content.data(using: encoding) {
            result.append(cd)
        }
        
        return result
    }
}

public extension Text {
    
    enum PredefinedAttribute: Attribute {
        
        public enum ScaleLevel: UInt8 {
            
            case l0 = 0x00
            case l1 = 0x11
            case l2 = 0x22
            case l3 = 0x33
            case l4 = 0x44
            case l5 = 0x55
            case l6 = 0x66
            case l7 = 0x77
        }
        
        case alignment(NSTextAlignment)
        case bold
        case small
        case medium

        case light
        case scale(ScaleLevel)
        case feed(UInt8)
        
        public var attribute: [UInt8] {
            switch self {
            case let .alignment(v):
                return ESC_POSCommand.justification(v == .left ? 0 : v == .center ? 1 : 2).rawValue
            case .bold:
                return ESC_POSCommand.emphasize(mode: true).rawValue
            case .small:
                return ESC_POSCommand.font(1).rawValue
            case .medium:
                return ESC_POSCommand.font(2).rawValue
            case .light:
                return ESC_POSCommand.color(n: 1).rawValue
            case let .scale(v):
                return [0x1D, 0x21, v.rawValue]
            case let .feed(v):
                return ESC_POSCommand.feed(points: v).rawValue
            }
        }
    }
}

public extension Text {
    
    init(content: String, predefined attributes: PredefinedAttribute...) {
        self.init(content, attributes: attributes)
    }
}

public extension Text {
    
    static func title(_ content: String) -> Text {
        return Text(content: content, predefined: .scale(.l1), .alignment(.center))
    }
    static func kv(printDensity: Int = 384, fontDensity: Int = 12, k: String, v: String, attributes: [Attribute]? = nil) -> Text {
        
        var num = printDensity / fontDensity
        
        let string = k + v
        
        for c in string {
            if (c >= "\u{2E80}" && c <= "\u{FE4F}") || c == "\u{FFE5}"{
                num -= 2
            } else  {
                num -= 1
            }
        }
        
        var contents = stride(from: 0, to: num, by: 1).map { _ in " " }
        
        contents.insert(k, at: 0)
        contents.append(v)
        
        return Text(contents.joined(), attributes: attributes)
    }
    
    static func kvWithSpaceCalculator(printDensity: Int = 384, fontDensity: Int = 12, k: String, v: String, attributes: [Attribute]? = nil) -> Text {
        
        var num = printDensity / fontDensity
        
        let string = k
        
        for c in string {
            if (c >= "\u{2E80}" && c <= "\u{FE4F}") || c == "\u{FFE5}"{
                num -= 2
            } else  {
                num -= 1
            }
        }

        
        
       print(string)
        var str : String = ""
        str = self.spaceCalculator(string:string,v:v)
        /* for i in 0...string.split(by: 30-v.count).count - 1{
            if i == string.split(by: 30-v.count).count - 1{
                if i != 0{
                    var length : Int = 0
                    length = "    ".count + string.split(by: 30-v.count)[i].replacingOccurrences(of: v, with: "").count
                    if length <= 30-v.count{
                        var space = ""
                        let s = string.split(by: 30-v.count)[i].replacingOccurrences(of: v, with: "")
                        for _ in 0...(30-length-v.count)-1{
                            space = space + " "
                        }
                        str = str + s + space + v
                        print(str)
                    }else{
                        let subStr  = (string.split(by: 30-v.count)[i])
                        
                        for k in 0...subStr.split(by: 30/2).count - 1{
                            if k == subStr.split(by: 30/2).count - 1{
                                if k != 0{
                                    var length : Int = 0
                                    length = "    ".count + subStr.split(by: 30/2)[k].replacingOccurrences(of: v, with: "").count
                                    if length <= 30-v.count{
                                        var space = ""
                                        let s = subStr.split(by: 30/2)[k].replacingOccurrences(of: v, with: "")
                                        for _ in 0...(30-length-v.count)-1{
                                            space = space + " "
                                        }
                                        str = str + s + space + v
                                        print(str)
                                    }
                                }else{
                                    var length : Int = 0
                                    length = subStr.split(by: 30-v.count)[k].replacingOccurrences(of: v, with: "").count
                                    if length <= 30-v.count{
                                        var space = ""
                                        let s = subStr.split(by: 30-v.count)[k].replacingOccurrences(of: v, with: "")
                                        for _ in 0...(30-length-v.count)-1{
                                            space = space + " "
                                        }
                                        str = str + s + space + v
                                        print(str)
                                    }
                                }
                            }else{
                                str = str + subStr.split(by: 30/2)[k].replacingOccurrences(of: v, with: "") + "\n" + "    "
                            }
                        }
                    }
                }else{
                    var length : Int = 0
                    length = string.split(by: 30-v.count)[i].replacingOccurrences(of: v, with: "").count
                    if length <= 30-v.count{
                        var space = ""
                        let s = string.split(by: 30-v.count)[i].replacingOccurrences(of: v, with: "")
                        if (30-length-v.count-1) >= 0{
                            for _ in 0...(30-length-v.count-1){
                                space = space + " "
                            }
                        }
                        str = str + s + space + v
                        print(str)
                    }
                }
                
            }else{
                str = str + string.split(by: 30-v.count)[i].replacingOccurrences(of: v, with: "") + "\n" + "    "
            }
        }*/
        print(str)
        
        var contents = stride(from: 0, to: num, by: 1).map { _ in " " }
        
        contents.insert(k, at: 0)
        contents.append(v)
        
        return Text(str, attributes: attributes)
    }
    
    static func spaceCalculator(string:String,v:String) -> String{
        let charNum : Int = 30
        let spaceAppend : String = "    "
        
        var str : String = ""
        for i in 0...string.split(by: charNum-v.count).count - 1{
            if i == string.split(by: charNum-v.count).count - 1{
                if i != 0{
                    var length : Int = 0
                    length = spaceAppend.count + string.split(by: charNum-v.count)[i].count
                    if length <= charNum-v.count{
                        var space = ""
                        let s = string.split(by: charNum-v.count)[i]
                        if (charNum-length-v.count)-1 >= 0{
                            for _ in 0...(charNum-length-v.count)-1{
                                space = space + " "
                            }
                        }
                        str = str + s + space + v
                        print(str)
                    }else{
                        let subStr  = (string.split(by: charNum-v.count)[i])
                        
                        for k in 0...subStr.split(by: charNum/2).count - 1{
                            if k == subStr.split(by: charNum/2).count - 1{
                                if k != 0{
                                    var length : Int = 0
                                    length = spaceAppend.count + subStr.split(by: charNum/2)[k].count
                                    if length <= charNum-v.count{
                                        var space = ""
                                        let s = subStr.split(by: charNum/2)[k]
                                        if (charNum-length-v.count)-1 >= 0{
                                            for _ in 0...(charNum-length-v.count)-1{
                                                space = space + " "
                                            }
                                        }
                                        str = str + s + space + v
                                        print(str)
                                    }
                                }else{
                                   /* var length : Int = 0
                                    length = subStr.split(by: charNum-v.count)[k].count
                                    if length <= charNum-v.count{
                                        var space = ""
                                        let s = subStr.split(by: charNum-v.count)[k]
                                        for _ in 0...(charNum-length-v.count)-1{
                                            space = space + " "
                                        }
                                        str = str + s + space + v
                                        print(str)
                                    }*/
                                    str = getStringWithSpaceAppend(string: subStr, i: k, charNum: charNum, v: v)

                                }
                            }else{
                                str = str + subStr.split(by: charNum/2)[k] + "\n" + spaceAppend
                            }
                        }
                    }
                }else{
                    /*var length : Int = 0
                    length = string.split(by: charNum-v.count)[i].count
                    if length <= charNum-v.count{
                        var space = ""
                        let s = string.split(by: charNum-v.count)[i]
                        if (charNum-length-v.count-1) >= 0{
                            for _ in 0...(charNum-length-v.count-1){
                                space = space + " "
                            }
                        }
                        str = str + s + space + v
                        print(str)
                    }*/
                    str = getStringWithSpaceAppend(string: string, i: i, charNum: charNum, v: v)
                }
                
            }else{
                str = str + string.split(by: charNum-v.count)[i] + "\n" + spaceAppend
            }
        }
        return str
    }
    
    static func getStringWithSpaceAppend(string:String,i:Int,charNum:Int,v:String)->String{
        var length : Int = 0
        var str = ""
        length = string.split(by: charNum-v.count)[i].count
        if length <= charNum-v.count{
            var space = ""
            let s = string.split(by: charNum-v.count)[i]
            if (charNum-length-v.count-1) >= 0{
                for _ in 0...(charNum-length-v.count-1){
                    space = space + " "
                }
            }
            str = str + s + space + v
            print(str)
        }
        return str
    }
}

extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
}
