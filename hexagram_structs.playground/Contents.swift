//: Hexagram Structures v6.3

import UIKit

class DateAndTime {
    let date = Date()
    let dateFormat = DateFormatter()
    let calendar = NSCalendar.current
    let currentDate: String
    var hour: String
    var minutes: String
    var seconds: String
    var currentTime: String = ""
    
    init() {
        dateFormat.dateFormat = "yyyy-MM-dd"
        self.currentDate = dateFormat.string(from: date)
        self.hour = String(calendar.component(.hour, from: date as Date))
        self.minutes = String(calendar.component(.minute, from: date as Date))
        self.seconds = String(calendar.component(.second, from: date as Date))
    }
    
    
    func currentDateAndTime () -> String {
        if hour.count == 1 {
            hour.insert("0", at: hour.startIndex)
        }
        if minutes.count == 1 {
            minutes.insert("0", at: hour.startIndex)
        }
        if seconds.count == 1 {
            seconds.insert("0", at: hour.startIndex)
        }
        
        currentTime = "\(hour):\(minutes):\(seconds)"
        return "\(currentDate), \(currentTime)\n"
    }
    
}

//: Structures for Pre-divination and Divination
struct 大衍之數 {
    // 「大衍之數五十」
    static let 大衍之數: UInt64 = 50
    
    // 「其用四十九」
    static let 其用: UInt64 = 大衍之數 - 1
    
    var 蓍草之數: UInt64
}

struct 象兩 {
    var 蓍草之數: UInt64
    
    // 「分而為二以象兩」
    func 分而為二() -> 兩 {
        //let 分左 = UInt64.random(lowerBound: 1, upperBound: 蓍草之數 - 象三.掛一)
        let 分左 = UInt64(1 + arc4random_uniform(UInt32(蓍草之數 - 象三.掛一) - 1))
        /*:
         # Floor & Ceiling Values for Stalks at the Beginning of Each Round
         
         Floor value refers to the minimum integer value it can be.
         Ceiling value refers to the integer just about the maximum integr value that it can be.
         
         ## Round X: Floor | Ceiling
         
         - Round 1: 1 | (49 - 1)
         - Round 2: 1 | (44 - 1) or (40 - 1)
         - Round 3: 1 | (40 - 1), (36 - 1) or (32 - 1)
         
         ## Reasons for the Floor and Ceiling Values
         
         The left hand must have at least 1 stalk to symbolize heaven. This is why the minimum possible value for the left hand is 1.
         The right hand must have at least 1 stalks, one for earth and one for mankind. This is why the maximum possible value for the left hand is 47 in Round 1, hence a ceiling value of (49 - 1) = 48 etc…
         */
        let 分右 = 蓍草之數 - 分左
        return 兩(分左: 分左, 分右: 分右)
    }
}

struct 兩 {
    let 分左: UInt64
    let 分右: UInt64
}

struct 象三 {
    static let 掛一: UInt64 = 1
    
    let 象兩: 兩
    
    var 左: UInt64 {
        return 象兩.分左
    }
    var 右: UInt64 {
        return 象兩.分右 - 象三.掛一
    }
    
    // 「掛一以象三」
    func 掛一象三() -> 三 {
        let 左 = 象兩.分左
        let 右 = 象兩.分右 - 象三.掛一
        return 三(左: 左, 右: 右, 掛一: 象三.掛一)
    }
}

struct 三 {
    let 左: UInt64
    let 右: UInt64
    let 掛一: UInt64
}

struct 象歲象閏 {
    let 象三: 三
    func 揲四歸奇() -> 歲閏 {
        var 左揲四: UInt64 = 0
        var 左歸奇: UInt64 = 0
        
        // 「揲之以四以象四時，歸奇於扐以象閏」
        if 象三.左 % 4 == 0 {
            左揲四 += ((象三.左 / 4) - 1)
            左歸奇 += 4
        } else {
            左揲四 += ((象三.左 - (象三.左 % 4)) / 4)
            左歸奇 += (象三.左 % 4)
        }
        
        var 右揲四: UInt64 = 0
        var 右歸奇: UInt64 = 0
        
        // 「五歲再閏，故再扐而後掛」
        if 象三.右 % 4 == 0 {
            右揲四 += ((象三.右 / 4) - 1)
            右歸奇 += 4
        } else {
            右揲四 += ((象三.右 - (象三.右 % 4)) / 4)
            右歸奇 += (象三.右 % 4)
        }
        
        return 歲閏(左揲四: 左揲四, 右揲四: 右揲四, 左歸奇: 左歸奇, 右歸奇: 右歸奇)
    }
}

struct 歲閏 {
    let 左揲四: UInt64
    let 右揲四: UInt64
    let 左歸奇: UInt64
    let 右歸奇: UInt64
}

struct 後掛 {
    let 象歲象閏: 歲閏
    
    var 揲四之數: UInt64 {
        return 象歲象閏.左揲四 + 象歲象閏.右揲四
    }
    
    var 後掛: UInt64 {
        return 象歲象閏.左歸奇 + 象歲象閏.右歸奇 + 象三.掛一
    }
}

//: Structures for Post-Divination
enum 爻數: UInt64 {
    case 六 = 6
    case 七 = 7
    case 八 = 8
    case 九 = 9
}

enum 爻位: String {
    case 初爻 = "初爻：　　"
    case 二爻 = "二爻：　　"
    case 三爻 = "三爻：　　"
    case 四爻 = "四爻：　　"
    case 五爻 = "五爻：　　"
    case 上爻 = "上爻：　　"
}

let 爻位數組: [爻位] = [.初爻, .二爻, .三爻, .四爻, .五爻, .上爻]

enum 爻象: String {
    case 老陰 = "六　—— × ——"
    case 少陽 = "七　———————"
    case 少陰 = "八　——   ——"
    case 老陽 = "九　———o———"
}

enum 靜爻: String {
    case 七 = "七　———————"
    case 八 = "八　——   ——"
}

enum 動爻: String {
    case 六 = "六　—— × ——    >    ———————"
    case 七 = "七　———————         ———————"
    case 八 = "八　——   ——         ——   ——"
    case 九 = "九　———o———    >    ——   ——"
}

struct 六爻 {
    // Properties
    let 初爻: 爻數
    let 二爻: 爻數
    let 三爻: 爻數
    let 四爻: 爻數
    let 五爻: 爻數
    let 上爻: 爻數
}

struct 筮卦 {
    // Static Properties
    static let 卦序卦名索引: [String: (序: Int, 名: String)] =
        ["陽陽陽陽陽陽": (01, "乾"), "陰陰陰陰陰陰": (02, "坤"), "陽陰陰陰陽陰": (03, "屯"), "陰陽陰陰陰陽": (04, "蒙"),
         "陽陽陽陰陽陰": (05, "需"), "陰陽陰陽陽陽": (06, "訟"), "陰陽陰陰陰陰": (07, "師"), "陰陰陰陰陽陰": (08, "比"),
         "陽陽陽陰陽陽": (09, "小畜"), "陽陽陰陽陽陽": (10, "履"), "陽陽陽陰陰陰": (11, "泰"), "陰陰陰陽陽陽": (12, "否"),
         "陽陰陽陽陽陽": (13, "同人"), "陽陽陽陽陰陽": (14, "大有"), "陰陰陽陰陰陰": (15, "謙"), "陰陰陰陽陰陰": (16, "豫"),
         "陽陰陰陽陽陰": (17, "隨"), "陰陽陽陰陰陽": (18, "蠱"), "陽陽陰陰陰陰": (19, "臨"), "陰陰陰陰陽陽": (20, "觀"),
         "陽陰陰陽陰陽": (21, "噬嗑"), "陽陰陽陰陰陽": (22, "賁"), "陰陰陰陰陰陽": (23, "剝"), "陽陰陰陰陰陰": (24, "復"),
         "陽陰陰陽陽陽": (25, "無妄"), "陽陽陽陰陰陽": (26, "大畜"), "陽陰陰陰陰陽": (27, "頤"), "陰陽陽陽陽陰": (28, "大過"),
         "陰陽陰陰陽陰": (29, "坎"), "陽陰陽陽陰陽": (30, "離"), "陰陰陽陽陽陰": (31, "咸"), "陰陽陽陽陰陰": (32, "恆"),
         "陰陰陽陽陽陽": (33, "遯"), "陽陽陽陽陰陰": (34, "大壯"), "陰陰陰陽陰陽": (35, "晉"), "陽陰陽陰陰陰": (36, "明夷"),
         "陽陰陽陰陽陽": (37, "家人"), "陽陽陰陽陰陽": (38, "睽"), "陰陰陽陰陽陰": (39, "蹇"), "陰陽陰陽陰陰": (40, "解"),
         "陽陽陰陰陰陽": (41, "損"), "陽陰陰陰陽陽": (42, "益"), "陽陽陽陽陽陰": (43, "夬"), "陰陽陽陽陽陽": (44, "姤"),
         "陰陰陰陽陽陰": (45, "萃"), "陰陽陽陰陰陰": (46, "升"), "陰陽陰陽陽陰": (47, "困"), "陰陽陽陰陽陰": (48, "井"),
         "陽陰陽陽陽陰": (49, "革"), "陰陽陽陽陰陽": (50, "鼎"), "陽陰陰陽陰陰": (51, "震"), "陰陰陽陰陰陽": (52, "艮"),
         "陰陰陽陰陽陽": (53, "漸"), "陽陽陰陽陰陰": (54, "歸妹"), "陽陰陽陽陰陰": (55, "豐"), "陰陰陽陽陰陽": (56, "旅"),
         "陰陽陽陰陽陽": (57, "巽"), "陽陽陰陽陽陰": (58, "兌"), "陰陽陰陰陽陽": (59, "渙"), "陽陽陰陰陽陰": (60, "節"),
         "陽陽陰陰陽陽": (61, "中孚"), "陰陰陽陽陰陰": (62, "小過"), "陽陰陽陰陽陰": (63, "既濟"), "陰陽陰陽陰陽": (64, "未濟")]
    
    // Instance Properties
    let 六爻結構: 六爻
    
    // Computed Properties
    var 原始值數組: [UInt64] {
        return [六爻結構.初爻.rawValue, 六爻結構.二爻.rawValue,
                六爻結構.三爻.rawValue, 六爻結構.四爻.rawValue,
                六爻結構.五爻.rawValue, 六爻結構.上爻.rawValue]
    }
    
    var 爻數數組: [爻數] {
        return [六爻結構.初爻, 六爻結構.二爻, 六爻結構.三爻,
                六爻結構.四爻, 六爻結構.五爻, 六爻結構.上爻]
    }
    
    var 靜態圖數據數組: [靜爻]? {
        guard !爻數數組.contains(.六) && !爻數數組.contains(.九) else {
            return nil
        }
        var 靜態圖數據數組 = Array<靜爻>()
        
        for 爻數 in 爻數數組 {
            switch 爻數 {
            case .七:
                靜態圖數據數組.append(.七)
            case .八:
                靜態圖數據數組.append(.八)
            default:
                print("Error.")
            }
        }
        return 靜態圖數據數組
    }
    
    var 轉變圖數據數組: [動爻]? {
        guard 爻數數組.contains(.六) || 爻數數組.contains(.九) else {
            return nil
        }
        var 轉變圖數據數組 = Array<動爻>()
        
        for 爻數 in 爻數數組 {
            switch 爻數 {
            case .六:
                轉變圖數據數組.append(.六)
            case .七:
                轉變圖數據數組.append(.七)
            case .八:
                轉變圖數據數組.append(.八)
            case .九:
                轉變圖數據數組.append(.九)
            }
        }
        return 轉變圖數據數組
    }
    
    // Methods
    func 設本卦() -> 本卦 {
        return 本卦(六爻結構: 六爻結構)
    }
    
    func 設之卦() -> 之卦? {
        guard 爻數數組.contains(.六) || 爻數數組.contains(.九) else { return nil }
        return 之卦(六爻結構: 六爻結構)
    }
    
    func 屏幕顯示() {
        guard 爻數數組.contains(.六) || 爻數數組.contains(.九) else {
            // 筮卦靜態圖
            //// Does not contain any 6 or 9.
            print("```")
            for index in 0...5 {
                print(爻位數組[5-index].rawValue + 靜態圖數據數組![5-index].rawValue)
            }
            print("```")
            print("【\(設本卦().卦序)、\(設本卦().卦名)。】")
            return
        }
        // 筮卦轉變圖
        //// Contains at least one 6 or 9.
        print("```")
        for index in 0...5 {
            print(爻位數組[5-index].rawValue + 轉變圖數據數組![5-index].rawValue)
        }
        print("```")
        print("【\(設本卦().卦序)、\(設本卦().卦名)】之【\(設之卦()!.卦序)、\(設之卦()!.卦名)】。")
    }
}

struct 本卦 {
    // Properties
    let 六爻結構: 六爻
    
    // Computed Properties
    var 陰陽屬性卦象: String {
        var 陰陽屬性卦象數組 = String()
        
        for 爻數 in [六爻結構.初爻, 六爻結構.二爻, 六爻結構.三爻, 六爻結構.四爻, 六爻結構.五爻, 六爻結構.上爻] {
            switch 爻數 {
            case .六, .八:
                陰陽屬性卦象數組.append("陰")
            case .七, .九:
                陰陽屬性卦象數組.append("陽")
            }
        }
        return 陰陽屬性卦象數組
    }
    var 卦序: Int {
        return 筮卦.卦序卦名索引[陰陽屬性卦象]!.序
    }
    var 卦名: String {
        return 筮卦.卦序卦名索引[陰陽屬性卦象]!.名
    }
    
}

struct 之卦 {
    // Properties
    let 六爻結構: 六爻
    
    // Computed Properties
    var 陰陽屬性卦象: String {
        var 陰陽屬性卦象數組 = String()
        
        for 爻數 in [六爻結構.初爻, 六爻結構.二爻, 六爻結構.三爻, 六爻結構.四爻, 六爻結構.五爻, 六爻結構.上爻] {
            switch 爻數 {
            case .八, .九:
                陰陽屬性卦象數組.append("陰")
            case .六, .七:
                陰陽屬性卦象數組.append("陽")
            }
        }
        return 陰陽屬性卦象數組
    }
    var 卦序: Int {
        return 筮卦.卦序卦名索引[陰陽屬性卦象]!.序
    }
    var 卦名: String {
        return 筮卦.卦序卦名索引[陰陽屬性卦象]!.名
    }
}

func 筮一爻() -> UInt64? {
    var 蓍草: UInt64 = 大衍之數.其用
    var 爻: UInt64 = 0
    var 掛: UInt64 = 0
    
    for _ in 1...3 {
        let 步驟一 = 象兩(蓍草之數: 蓍草).分而為二()
        let 步驟二 = 象三(象兩: 步驟一).掛一象三()
        let 步驟三 = 象歲象閏(象三: 步驟二).揲四歸奇()
        let 步驟四 = 後掛(象歲象閏: 步驟三)
        掛 += 步驟四.後掛
        爻 = 步驟四.揲四之數
        蓍草 -= 步驟四.後掛
    }
    
    func 核對(揲四: UInt64, 歸奇: UInt64) -> Bool {
        if 4 * 爻 + 掛 == 大衍之數.其用 {
            return true
        } else {
            return false
        }
    }
    
    guard 核對(揲四: 爻, 歸奇: 掛) == true else { return nil }
    return 爻
}

func 卜筮全程(問 問題: String) -> 六爻? {
    guard 問題 != "", 問題.contains("?") || 問題.contains("？") else {
        print("To start consultation, enter your question and end it with a \"?\".")
        return nil
    }
    print("# " + 問題 + "\n")
    print(DateAndTime().currentDateAndTime())
    
    var 筮得爻數數組 = Array<UInt64>()
    
    for _ in 1...6 {
        筮得爻數數組.append(筮一爻()!)
    }
    
    let 筮得爻數結構 = 六爻(初爻: 爻數(rawValue: 筮得爻數數組[0])!,
                         二爻: 爻數(rawValue: 筮得爻數數組[1])!,
                         三爻: 爻數(rawValue: 筮得爻數數組[2])!,
                         四爻: 爻數(rawValue: 筮得爻數數組[3])!,
                         五爻: 爻數(rawValue: 筮得爻數數組[4])!,
                         上爻: 爻數(rawValue: 筮得爻數數組[5])!)
    return 筮得爻數結構
}

//: # Consultation
let 問題: String = ""
// Enter your question within the quotation marks, ending it with a "?".

if let 卜筮全程 = 卜筮全程(問: 問題) {
    let 卜筮結果 = 筮卦(六爻結構: 卜筮全程)
    卜筮結果.屏幕顯示()
}
