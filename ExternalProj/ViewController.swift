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
    @IBOutlet weak var calendar: FSCalendar!
    
    let request: NSFetchRequest<AlarmInfo> = AlarmInfo.fetchRequest()
    var fetchResult = [AlarmInfo]()
    var result: [AlarmInfoModel] = []
    let identifier = "AlarmCollectionViewCell"
    
    lazy var AlarmView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size: CGSize = UIScreen.main.bounds.size
        layout.itemSize = CGSize(width: size.width - 40, height: 60)
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        layout.sectionFootersPinToVisibleBounds = true

        let AlarmView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.view.addSubview(AlarmView)
        AlarmView.dataSource = self
        AlarmView.delegate = self
        AlarmView.isPagingEnabled = false
        AlarmView.backgroundColor = .clear
        AlarmView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        AlarmView.layer.borderWidth = 1.0;
        AlarmView.layer.cornerRadius = 5.0;
        AlarmView.register(AlarmCollectionViewCell.self, forCellWithReuseIdentifier: self.identifier)
        return AlarmView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchContact()
        configureUI()
        self.settingCal()
//        let request: NSFetchRequest<AlarmInfo> = AlarmInfo.fetchRequest()
//        PersistenceManager.shared.deleteAll(request: request)
//        let arr = PersistenceManager.shared.fetch(request: request)
//        if arr.isEmpty {
//            print("clean") // Print "clean"
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        OperationQueue.main.addOperation { // DispatchQueue도 가능.
            self.fetchContact()
        }
    }
    
    func configureUI() {
        self.view.addSubview(self.AlarmView)
        
        self.AlarmView.snp.makeConstraints {
            $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
            $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-20)
            $0.top.equalTo(self.calendar.snp.bottom).offset(-10)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
}

// MARK: 달력 설정
extension ViewController {
    func settingCal() {
        // 달력의 평일 날짜 색깔
        calendar.appearance.titleDefaultColor = .black
        // 달력의 토,일 날짜 색깔
        calendar.appearance.titleWeekendColor = .red
        // 달력의 맨 위의 년도, 월의 색깔
        calendar.appearance.headerTitleColor = .systemPink
        // 달력의 요일 글자 색깔
        calendar.appearance.weekdayTextColor = .orange
        
        // 달력의 년월 글자 바꾸기
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        
        // 달력의 요일 글자 바꾸는 방법 1
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 달력의 요일 글자 바꾸는 방법 2
        calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "토"
        
        // Delegate 설정
        calendar.delegate = self
        calendar.dataSource = self
    }
}

// MARK: 클릭 시 Modal화면 표시
extension ViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        guard let modalPresentView = self.storyboard?.instantiateViewController(identifier: "SetAlarmViewController") as? SetAlarmViewController else { return }
        modalPresentView.searchCompletion = { flag in
            if(flag){
                self.fetchContact()
            }
        }
        // 날짜를 원하는 형식으로 저장하기 위한 방법입니다.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateText = dateFormatter.string(from: date)
        modalPresentView.date = "\(dateText)"

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
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as? AlarmCollectionViewCell else { return UICollectionViewCell() }
        
        let month = Calendar.current.dateComponents([.month], from: result[indexPath.row].date)
        let day = Calendar.current.dateComponents([.day], from: result[indexPath.row].date)
        
        cell.date.text = "\(month.month!)월 \(day.day!)일"
        cell.subject.text = result[indexPath.row].subject
        cell.note.text = result[indexPath.row].note
        return cell
    }
}

// MARK: 데이터 불러오기_수정
extension ViewController {
    func fetchContact() {
        result.removeAll()
        var fetchResult = PersistenceManager.shared.fetch(request: request) // [AlarmInfo]
        self.fetchResult = fetchResult
        fetchResult.forEach {
            let Info = AlarmInfoModel(activation: $0.activation, date: $0.date!, note: $0.note!, subject: $0.subject!)
            result.append(Info)
        }
        print("변환된 것 : \(result.count)")
        AlarmView.reloadData()
    }
}
