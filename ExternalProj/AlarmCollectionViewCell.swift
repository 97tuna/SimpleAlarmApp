//
//  AlarmCollectionViewCell.swift
//  ExternalProj
//
//  Created by 이동헌 on 2021/12/03.
//

import UIKit
import SnapKit
import UserNotifications

class AlarmCollectionViewCell: UICollectionViewCell {
    lazy var date: UILabel = {
        let date = UILabel()
        return date
    }()
    
    lazy var subject: UILabel = {
        let subject = UILabel()
        return subject
    }()
    
    lazy var note: UILabel = {
        let note = UILabel()
        return note
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.addSubview(self.date)
        self.addSubview(self.subject)
        self.addSubview(self.note)
        
//        self.timePicker.snp.makeConstraints {
//
//        }
//
//        self.subject.snp.makeConstraints {
//
//        }
//
//        self.note.snp.makeConstraints {
//
//        }
    }
}
