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
    
    //    @IBOutlet var facultyBtn: UIButton!
    
    
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
                    textView.text = "학식을@ 운영하지 않습니다."
                }
            } else {
                textView.text = "주말에는 교직원 식당을 운영하지 않습니다."
            }
        default:
            if weekday >= 2 && weekday <= 6 {
                let index = getMenuIndexForWeekday(weekday) + indexOffset
                if index < jsonArray_fac.count {
                    textView.text = jsonArray_fac[index]["text"]
                } else {
                    textView.text = "학식을@ 운영하지 않습니다."
                }
            } else {
                print("주말에는 해당 옵션을 이용할 수 없습니다.")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchingJsonArray()
        imgView.image = UIImage(named: "수뭉.png")

        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일 (EEE)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let formattedDate = dateFormatter.string(from: currentDate)

        todayDate.text = "오늘 날짜 : \(formattedDate)"
        selectedDate = currentDate

        pickerView.selectRow(0, inComponent: 0, animated: true)
        lastSelectedOption = options[0]
        if let path = Bundle.main.path(forResource: "menu_faculty", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path))
                if let parsedArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: String]] {
                    jsonArray_fac = parsedArray
                }
            } catch {
                print("Error reading or parsing JSON file: \(error)")
            }
        }
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

