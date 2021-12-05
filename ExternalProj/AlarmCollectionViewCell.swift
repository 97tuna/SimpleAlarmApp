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
        date.font = UIFont(name: "GmarketSansBold", size: CGFloat(15))
        date.text = "12월 18일"
        return date
    }()
    
    lazy var subject: UILabel = {
        let subject = UILabel()
        subject.font = UIFont(name: "GmarketSansMediun", size: CGFloat(15))
        subject.text = "전자기학"
        return subject
    }()
    
    lazy var note: UILabel = {
        let note = UILabel()
        note.font = UIFont(name: "GmarketSansLight", size: CGFloat(15))
        note.text = "기말고사 00관"
        note.numberOfLines = 2
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
        
        self.date.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(10)
            $0.left.equalTo(self.snp.left).offset(20)
            $0.width.equalTo(self.snp.width).multipliedBy(0.3)
        }

        self.subject.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(20)
            $0.width.equalTo(self.snp.width).multipliedBy(0.3)
            $0.top.equalTo(self.date.snp.bottom).offset(5)
        }

        self.note.snp.makeConstraints {
            $0.left.equalTo(self.subject.snp.right).offset(20)
            $0.right.equalTo(self.snp.right).inset(20)
            $0.height.equalTo(self.snp.height).offset(40)
            $0.centerY.equalTo(self.snp.centerY)
        }
    }
}
