//
//  ViewController.swift
//  ExternalProj
//
//  Created by 이동헌 on 2021/12/02.
//

import UIKit
import FSCalendar
import SnapKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var Calendar: FSCalendar!
    
    let identifier = "AlarmCollectionViewCell"
    
    lazy var AlarmView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size: CGSize = UIScreen.main.bounds.size
        layout.itemSize = CGSize(width: size.width - 40, height: size.height * 0.3)
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        layout.sectionFootersPinToVisibleBounds = true
        
        let AlarmView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.view.addSubview(AlarmView)
        AlarmView.dataSource = self
        AlarmView.delegate = self
        AlarmView.isPagingEnabled = false
        AlarmView.backgroundColor = .clear
        AlarmView.register(AlarmCollectionViewCell.self, forCellWithReuseIdentifier: self.identifier)
        return AlarmView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingCal()
    }

}

// MARK: 달력 설정
extension ViewController {
    func settingCal() {
        // 달력의 평일 날짜 색깔
        Calendar.appearance.titleDefaultColor = .black
        // 달력의 토,일 날짜 색깔
        Calendar.appearance.titleWeekendColor = .red
        // 달력의 맨 위의 년도, 월의 색깔
        Calendar.appearance.headerTitleColor = .systemPink
        // 달력의 요일 글자 색깔
        Calendar.appearance.weekdayTextColor = .orange
        
        // 달력의 년월 글자 바꾸기
        Calendar.appearance.headerDateFormat = "YYYY년 M월"
        
        // 달력의 요일 글자 바꾸는 방법 1
        Calendar.locale = Locale(identifier: "ko_KR")
        
        // 달력의 요일 글자 바꾸는 방법 2
        Calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        Calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        Calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        Calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        Calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        Calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        Calendar.calendarWeekdayView.weekdayLabels[6].text = "토"
        
        // Delegate 설정
        Calendar.delegate = self
        Calendar.dataSource = self
    }
}

// MARK: 클릭 시 Modal화면 표시
extension ViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        guard let modalPresentView = self.storyboard?.instantiateViewController(identifier: "SetAlarmViewController") as? SetAlarmViewController else { return }
        
        // 날짜를 원하는 형식으로 저장하기 위한 방법입니다.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        modalPresentView.date = dateFormatter.string(from: date)

        self.present(modalPresentView, animated: true, completion: nil)
    }
}

extension ViewController: FSCalendarDataSource {
    
}

// MARK: CollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
}

// MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as? AlarmCollectionViewCell else { return UICollectionViewCell() }

        return cell
    }
}

// MARK: 데이터 불러오기_수정
extension ViewController {
    func fetchContact() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
            
        do {
           let contact = try context.fetch(AlarmInfo.fetchRequest()) as! [AlarmInfo]
           contact.forEach {
               print($0.subject)
          }
        } catch {
           print(error.localizedDescription)
        }
    }
}
