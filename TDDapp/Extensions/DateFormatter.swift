//
//  DateFormatter.swift
//  TDDapp
//
//  Created by Дарья on 23.02.2021.
//

import Foundation

extension DateFormatter {
    
    static var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        //formatter.locale = Locale(identifier: "ru_RU")
        return df
    }
    
//    private var dateFormatter: DateFormatter {
//        let df = DateFormatter()
//        df.dateFormat = "dddd, dd MMMM yyyy"
//        df.locale = Locale(identifier: "ru_RU")
//        return df
//    }
}
