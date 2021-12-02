//
//  SetAlarmViewController.swift
//  ExternalProj
//
//  Created by 이동헌 on 2021/12/03.
//

import UIKit
import SnapKit
import CoreData

class SetAlarmViewController: UIViewController {
    
    lazy var pageTitle: UILabel = {
       let pageTitle = UILabel()
        pageTitle.text = ""
        pageTitle.textColor = .black
        return pageTitle
    }()
    
    lazy var timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        return timePicker
    }()
    
    lazy var subject: UITextField = {
        let subject = UITextField()
        return subject
    }()
    
    lazy var note: UITextField = {
        let note = UITextField()
        return note
    }()
    
    var date: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.pageTitle.text = date
        
    }
    
    func configureUI() {
        self.view.addSubview(self.pageTitle)
        
        self.pageTitle.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX).offset(0)
        }
    }
}
// MARK: 로컬에 알람정보 저장
extension SetAlarmViewController {
    func saveInfo(date: Date, subject: String, note: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let Info = AlarmInfoModel(activation: true, date: date, note: note, subject: subject)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
                
        let entity = NSEntityDescription.entity(forEntityName: "AlarmInfo", in: context)
                
        if let entity = entity {
            let data = NSManagedObject(entity: entity, insertInto: context)
            data.setValue(Info.activation, forKey: "activation")
            data.setValue(Info.date, forKey: "date")
            data.setValue(Info.note, forKey: "note")
            data.setValue(Info.subject, forKey: "subject")
        }
    }
}

// MARK: 노티 생성
extension SetAlarmViewController {
    func setNoti(subject: String, note: String, time: Double) {
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            if setting.authorizationStatus == UNAuthorizationStatus.authorized {
                let nContents = UNMutableNotificationContent()
                nContents.badge = 1
                nContents.title = "과외선생"
                nContents.subtitle = subject
                nContents.body = note
                nContents.sound = UNNotificationSound.default
                nContents.userInfo = ["name": "TEST"]
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
                
                let request = UNNotificationRequest(identifier: "TEST", content: nContents, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}
