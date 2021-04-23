import Foundation

struct DateFormatters {
  
  static var MMMMYYYYDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM yyyy"
//    dateFormatter.dateStyle = .short
    return dateFormatter
  }()
  
   static var yyyyMMddDateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    //    dateFormatter.dateStyle = .short
    return dateFormatter
   }()
    
    static var shortDateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
       dateFormatter.dateStyle = .short
       return dateFormatter
    }()
    
  static var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    return dateFormatter
  }()
  
  static var weekdayFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE"
    return dateFormatter
  }()
    
    static var fullFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
      return dateFormatter
    }()
    
    static var twelveHourFormatter: DateFormatter = {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "hh:mm a"
         dateFormatter.timeZone = TimeZone.autoupdatingCurrent
         return dateFormatter
     }()
  
    static var twetyFourHourFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter
    }()
}
