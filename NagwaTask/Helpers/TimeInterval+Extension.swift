//
//  TimeInterval+Extension.swift
//  NagwaTask
//
//  Created by Mohamed Samir on 30/03/2022.
//

import Foundation

extension TimeInterval {
    func getTimeAsString() -> String{
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.hour, .minute, .second]
        
        return formatter.string(from: self) ?? "00:00"
        
    }
}
