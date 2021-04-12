import Foundation

struct DateFormatters {
  
  static var shortDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM yyyy"
//    dateFormatter.dateStyle = .short
    return dateFormatter
  }()
  
   static var yyyyMMddDateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    //    dateFormatter.dateStyle = .short
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
      dateFormatter.timeZone = TimeZone.autoupdatingCurrent
      return dateFormatter
    }()
  
}
