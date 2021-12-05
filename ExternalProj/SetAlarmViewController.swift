//
//  SetAlarmViewController.swift
//  ExternalProj
//
//  Created by 이동헌 on 2021/12/03.
//

import UIKit
import SnapKit
import CoreData
import FSCalendar

class SetAlarmViewController: UIViewController {
    
    typealias completion = (Bool)->Void
    var searchCompletion:completion!
    
    lazy var pageTitle: UILabel = {
       let pageTitle = UILabel()
        pageTitle.text = ""
        pageTitle.textColor = .black
        pageTitle.font = UIFont(name: "GmarketSansBold", size: CGFloat(18))
        return pageTitle
    }()
    
    lazy var timeLabel: UILabel = {
       let timeLabel = UILabel()
        timeLabel.text = "시간 입력"
        timeLabel.font = UIFont(name: "GmarketSansBold", size: CGFloat(17))
        timeLabel.textColor = .black
        return timeLabel
    }()
    
    lazy var timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        return timePicker
    }()
    
    lazy var subject: UITextField = {
        let subject = UITextField()
        subject.placeholder = "제목을 입력해주세요"
        subject.font = UIFont(name: "GmarketSansBold", size: CGFloat(15))
        subject.borderStyle = .roundedRect
        subject.clearButtonMode = .whileEditing
        return subject
    }()
    
    lazy var note: UITextView = {
        let note = UITextView()
        note.delegate = self
        note.text = ""
        note.textColor = UIColor.darkGray
        note.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        note.layer.borderWidth = 1.0;
        note.layer.cornerRadius = 5.0;
        note.text = "내용을 입력해주세요."
        note.font = UIFont(name: "GmarketSansBold", size: CGFloat(13))
        return note
    }()
    
    lazy var saveBtn: UIButton = {
       let saveBtn = UIButton()
        saveBtn.setImage(UIImage(systemName: "plus"), for: .normal)
        saveBtn.addTarget(self, action: #selector(pushBtn), for: .touchUpInside)
        return saveBtn
    }()
    
    var date: String = "2021-12-04"

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.pageTitle.text = date
        requestNotificationAuthorization()
    }
    
    @objc func pushBtn() {
        print("저장 완료")
        // 설정 시간에서 현재 시간을 뺀 시간을 구해서 time에 넣기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let realDate: Date = dateFormatter.date(from: date)!
        let year = Calendar.current.dateComponents([.year], from: realDate)
        let month = Calendar.current.dateComponents([.month], from: realDate)
        let day = Calendar.current.dateComponents([.day], from: realDate)
        let hour = Calendar.current.dateComponents([.hour], from: timePicker.date)
        let min = Calendar.current.dateComponents([.minute], from: timePicker.date)
        
        
        let cal = DateComponents(year: year.year, month: month.month, day: day.day, hour: hour.hour, minute: min.minute)
        let calDate = Calendar.current.date(from: cal)
        
        // 미래에서 - 오늘
        let distanceSecond = Calendar.current.dateComponents([.second], from: Date(), to: calDate!).second
        print("떨어져 있는 초 : \(distanceSecond)")
        
        // 노티 정보 저장, 0보다 큰 시간이 남아있어야지 알림 등록
        if distanceSecond! > 0 {
            setNoti(subject: subject.text!, note: note.text, time: Double(distanceSecond!))
        }
        // DB에 저장
        saveInfo(date: calDate!, subject: subject.text!, note: note.text)
        
        dismiss(animated: true, completion: nil)
        self.searchCompletion(true)
    }
    
    func configureUI() {
        self.view.addSubview(self.pageTitle)
        self.view.addSubview(self.timeLabel)
        self.view.addSubview(self.timePicker)
        self.view.addSubview(self.subject)
        self.view.addSubview(self.note)
        self.view.addSubview(self.saveBtn)
        
        self.pageTitle.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.centerX.equalTo(self.view.safeAreaLayoutGuide.snp.centerX).offset(0)
        }
        
        self.timeLabel.snp.makeConstraints {
            $0.top.equalTo(self.pageTitle.snp.bottom).offset(40)
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
        }
        
        self.timePicker.snp.makeConstraints {
            $0.top.equalTo(self.pageTitle.snp.bottom).offset(40)
            $0.left.equalTo(self.timeLabel.snp.right).offset(10)
            $0.centerY.equalTo(self.timeLabel.snp.centerY).offset(0)
        }
        
        self.subject.snp.makeConstraints {
            $0.top.equalTo(self.timePicker.snp.bottom).offset(20)
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(20)
            $0.height.equalTo(self.view.safeAreaLayoutGuide.snp.height).multipliedBy(0.05)
        }
        
        self.note.snp.makeConstraints {
            $0.top.equalTo(self.subject.snp.bottom).offset(20)
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(20)
            $0.height.equalTo(self.view.safeAreaLayoutGuide.snp.height).multipliedBy(0.3)
        }
        
        self.saveBtn.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(20)
            $0.centerY.equalTo(self.pageTitle.snp.centerY).offset(0)
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
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } else {
            return ;
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
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)

        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
}

extension SetAlarmViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      textView.text = nil
      textView.textColor = UIColor.black
    }
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "내용을 입력해주세요."
      textView.textColor = UIColor.lightGray
    }
  }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
