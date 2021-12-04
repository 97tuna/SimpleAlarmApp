//
//  AlarmInfoModel.swift
//  ExternalProj
//
//  Created by 이동헌 on 2021/12/03.
//

import Foundation

struct AlarmInfoModel {
    var activation: Bool
    var date: Date
    var note: String
    var subject: String
    
    init(activation: Bool, date: Date, note: String, subject: String) {
        self.activation = activation
        self.date = date
        self.note = note
        self.subject = subject
    }
}
