//
//  ViewController.swift
//  Lunch_
//
//  Created by 김근영 on 11/25/23.
//

import UIKit

struct FacultyArrayMenu: Codable{
    var text: String
}
struct StudentArrayMenu: Codable {
    var text: String
}


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var textView: UITextView!
    
    
    @IBOutlet var todayDate: UILabel!

    @IBOutlet var imgView: UIImageView!
    // 교직원 식당 json파싱을 위한 코드
    var jsonArray_fac: [[String: String]] = []
    var model = [FacultyArrayMenu]()
    
    // 학생식당 json파싱을 위한 코드
    var jsonArray_stu: [[String: String]] = []
    var model_student = [StudentArrayMenu]()
    
    var selectedDate: Date?
    
    let indexOffset = 0  // You may need to adjust the value based on your requirements
    
    var lastSelectedOption: String?
    
    let options = ["라면타임 & 조식류", "단품코너", "오늘의 백반", "교직원 식당"]
    func getMenuIndexForWeekday(_ weekday: Int) -> Int {
        return weekday - 2
    }

    func displayTextForSelectedOption(_ selectedOption: String) {
        guard let unwrappedDate = selectedDate else {
            print("Error: selectedDate is nil.")
            return
        }

        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: unwrappedDate)

        switch selectedOption {
        case "교직원 식당":
            if weekday >= 2 && weekday <= 6 {
                let index = getMenuIndexForWeekday(weekday) + indexOffset
                if index < jsonArray_fac.count {
                    textView.text = jsonArray_fac[index]["text"]
                } else {
                    textView.text = "학식을 운영하지 않습니다."
                }
            } else {
            // alert로 띄우기
            let alert = UIAlertController(title: "교직원 식당 운영 안내", message: "주말에는 교직원 식당을 운영하지 않습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
          }
            
        case "라면타임 & 조식류":
            if weekday >= 2 && weekday <= 6{
                let index = getMenuIndexForWeekday(weekday) + indexOffset
                if index < jsonArray_stu.count{
                    textView.text = jsonArray_stu[index]["text"]
                } else{
                    textView.text = "학식을 ! 운영하지 않습니다."
                }
            }else{
                textView.text = "주말에는 라면타임 & 조식류를 운영하지 않습니다."
            }
        case "단품코너":
            if weekday >= 2 && weekday <= 6 {
                let index = getIndexForWeekday(weekday)
                if index - 1 < jsonArray_stu.count {
                    textView.text = jsonArray_stu[index - 1]["text"]
                } else {
                    textView.text = "학식을 !! 운영하지 않습니다."
                }
            } else {
                textView.text = "주말에는 단품코너를 운영하지 않습니다."
            }
        
        case "오늘의 백반":
            print("Selected Option: \(selectedOption), Weekday: \(weekday)")

            if weekday == 6 {
                textView.text = "단품 코너를 이용해주세요."
            } else if weekday == 7 || weekday == 1{
                textView.text = "주말에는 학식을 운영하지 않습니다."
            } else {
                let index = getIndexForTodaySpecial(weekday)
                print("Weekday: \(weekday), Index for Today Special: \(index)")
                if index - 1 < jsonArray_stu.count {
                    textView.text = jsonArray_stu[index - 1]["text"]
                } else {
                    textView.text = "학식을 운영하지 않습니다."
                }
            }

        default:
            if weekday >= 2 && weekday <= 6 {
                let index = getMenuIndexForWeekday(weekday) + indexOffset
                if index < jsonArray_fac.count {
                    textView.text = jsonArray_fac[index]["text"]
                } else {
                    textView.text = "학식을ㅋㅋ 운영하지 않습니다."
                }
            } else {
                print("주말에는 해당 옵션을 이용할 수 없습니다.")
            }
        }
    }

    
    func getIndexForWeekday(_ weekday: Int) -> Int {
        // Ensure that the adjusted index is within the range [6, 10]
        return max(min(weekday + 4, 10), 6)
    }
    func getIndexForTodaySpecial(_ weekday: Int) -> Int {
        // Adjust the index offset based on your requirements
        let adjustedIndex = getMenuIndexForWeekday(weekday) + indexOffset
        
        // Ensure that the adjusted index is within the range [11, 14] for "오늘의 백반"
        let todaySpecialIndex = adjustedIndex + 10 // Add 10 to get the correct range [11, 14]
        return max(min(weekday + 9, 14), 11)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchingJsonArray()
        fetchingJsonArray_student()
        
        // Set up the imgView
        imgView.image = UIImage(named: "수뭉.png")
        
        // Bring the imgView to the front
        imgView.bringSubviewToFront(view)

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일 (EEE)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let formattedDate = dateFormatter.string(from: currentDate)

        
//        todayDate.text = "오늘 날짜 : \(formattedDate)"
//        todayDate.text = "선택된 날짜: \(dateFormatter.string(from: selectedDate!))"
            
        pickerView.selectRow(0, inComponent: 0, animated: true)
        lastSelectedOption = options[0]

        // Load JSON data for faculty menu
        pickerView.delegate = self
        pickerView.dataSource = self
        displayTextForSelectedOption(lastSelectedOption!)
    }


    func fetchingJsonArray() {
        guard let fileLocation = Bundle.main.url(forResource: "menu_faculty", withExtension: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: fileLocation)
            let result = try JSONDecoder().decode([FacultyArrayMenu].self, from: data)
            self.model = result
            jsonArray_fac = model.map { ["text": $0.text] }
        } catch {
            print("Parsing Error: \(error)")
        }
    }

    func fetchingJsonArray_student() {
        guard let fileLocation = Bundle.main.url(forResource: "menu_student", withExtension: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: fileLocation)
            let result = try JSONDecoder().decode([StudentArrayMenu].self, from: data)
            self.model_student = result
            jsonArray_stu = model_student.map { ["text": $0.text] }
        } catch {
            print("Parsing Error: \(error)")
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = options[row]
        displayTextForSelectedOption(selectedOption)
        lastSelectedOption = selectedOption
    }
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        
        // Check if lastSelectedOption is not nil before updating the menu
        if let lastSelectedOption = lastSelectedOption {
            displayTextForSelectedOption(lastSelectedOption)
        } else {
            // Handle the case where the user hasn't picked a restaurant yet
            print("Please select a restaurant.")
        }
    }
}

