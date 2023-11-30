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
    @IBOutlet var facultyBtn: UIButton!
    
    @IBOutlet var todayDate: UILabel!
    @IBOutlet var textView: UITextView!
    
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
        // Adjust the logic here based on your requirements
        // This is just a placeholder implementation
        return weekday - 2
    }
    
    func displayTextForSelectedOption(_ selectedOption: String) {
        var textToDisplay: String
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: selectedDate!)
        let menuIndex = getMenuIndexForWeekday(weekday) + indexOffset
        
        guard let unwrappedDate = selectedDate else {
            // Handle the case when 'selectedDate' is nil
            // For example, print an error message or provide a default value.
            print("Error: selectedDate is nil.")
            return
        }
        switch selectedOption {
        case "라면타임 & 조식류":
            textToDisplay = "1"
            fetchingJsonArray2()
            // Show student menu for 라면타임 & 조식류
            if weekday == 1 || weekday == 7 {
                // If it's a weekend, display a specific message
                textView.text = "주말에는 학식을 운영하지 않습니다 :)"
            } else if weekday >= 2 && weekday <= 6 {
                // For weekdays (Monday to Friday), display the regular schedule
                let index = weekday - 2
                if index < jsonArray_fac.count {
                    textView.text = jsonArray_fac[index]["text"]
                } else {
                    textView.text = "학식을 운영하지 않습니다."
                }
            }
        case "단품코너":
            textToDisplay = "2"
            fetchingJsonArray2()
            if weekday == 1 || weekday == 7 {
                // If it's a weekend, display a specific message
                textView.text = "주말에는 학식을 운영하지 않습니다 :)"
            } else if weekday >= 2 && weekday <= 6 {
                // For weekdays (Monday to Friday), display the regular schedule
                let index = weekday + 3
                if index < jsonArray_fac.count {
                    textView.text = jsonArray_fac[index]["text"]
                } else {
                    textView.text = "학식을 운영하지 않습니다."
                }
            }
            // Handle other options as needed
        case "오늘의 백반":
            textToDisplay = "3"
            fetchingJsonArray2()
            if weekday == 1 || weekday == 7 {
                // If it's a weekend, display a specific message
                textView.text = "주말에는 학식을 운영하지 않습니다 :)"
            } else if weekday >= 2 && weekday <= 6 {
                // For weekdays (Monday to Friday), display the regular schedule
                let index = weekday + 8
                if index < jsonArray_fac.count {
                    textView.text = jsonArray_fac[index]["text"]
                } else {
                    textView.text = "학식을 운영하지 않습니다."
                }
            }
        case "교직원 식당":
            textToDisplay = "4"
            fetchingJsonArray()
            if weekday == 1 || weekday == 7 {
                // If it's a weekend, display a specific message
                textView.text = "주말에는 학식을 운영하지 않습니다 :)"
            } else if weekday >= 2 && weekday <= 6 {
                // For weekdays (Monday to Friday), display the regular schedule
                let index = weekday - 2
                if index < jsonArray_fac.count {
                    textView.text = jsonArray_fac[index]["text"]
                } else {
                    textView.text = "학식을 운영하지 않습니다."
                }
            }
        default:
            textToDisplay = "Unknown Option"
            textView.text = "Invalid option selected."
        }
        print("Selected Option: \(textToDisplay)")
    }
    
    /*func showText() {
        guard let selectedDate = selectedDate else {
            print("Selected date is nil.")
            return
        }
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: selectedDate)
        
        if weekday == 1 || weekday == 7 {
            // If it's a weekend, display a specific message
            textView.text = "주말에는 학식을 운영하지 않습니다 :)"
        } else if weekday >= 2 && weekday <= 6 {
            // For weekdays (Monday to Friday), display the regular schedule
            let index = weekday - 2
            if index < jsonArray_fac.count {
                textView.text = jsonArray_fac[index]["text"]
            } else {
                textView.text = "학식을 운영하지 않습니다."
            }
        }
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchingJsonArray()
        imgView.image = UIImage(named: "수뭉.png")
        // Set up the date label
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일 (EEE)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let formattedDate = dateFormatter.string(from: currentDate)
        
    
        todayDate.text = "오늘 날짜 : \(formattedDate)"
        
        // Set the initial selected date to the current date
        selectedDate = currentDate
        
        // Load JSON data from the app bundle
        if let path = Bundle.main.path(forResource: "menu_student", ofType: "json") {
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
        //showText()
    }
    
    
    func fetchingJsonArray() {
        guard let fileLocation = Bundle.main.url(forResource: "menu_faculty", withExtension: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: fileLocation)
            let result = try JSONDecoder().decode([FacultyArrayMenu].self, from: data)
            self.model = result
            // Assuming you want to use the model elsewhere in your code
            // If you only need jsonArray, you can remove the following line
            jsonArray_fac = model.map { ["text": $0.text] }
        } catch {
            print("Parsing Error: \(error)")
        }
    }
    
    func fetchingJsonArray2() {
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
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = options[row]
        displayTextForSelectedOption(selectedOption)
    }

    /*
    @IBAction func facultyBtnTapped(_ sender: UIButton) {
        // Show the faculty-specific content (e.g., the first row of JSON)
        if jsonArray_fac.count > 0 {
            if let firstRowText = jsonArray_fac[0]["text"] {
                textView.text = firstRowText
            } else {
                textView.text = "No faculty content available."
            }
        } else {
            textView.text = "No faculty content available."
        }
    }*/
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        // Update the selectedDate when the date picker value changes
        selectedDate = sender.date
        
        // Get the selected day of the week
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: selectedDate!)

        // Determine the selected option based on the day of the week
        var selectedOption: String
        switch weekday {
        case 2...6: // Monday to Friday
            selectedOption = "라면타임 & 조식류"
        case 1, 7: // Sunday or Saturday
            selectedOption = "주말에는 학식을 운영하지 않습니다 :)"
        default:
            selectedOption = "Unknown Option"
        }

        // Update the menu based on the selected option
        if let lastOption = lastSelectedOption, lastOption != selectedOption {
            // If the option has changed, update the menu
            displayTextForSelectedOption(selectedOption)
            lastSelectedOption = selectedOption
        } else {
            // If the option is the same as the last one, do nothing (optional)
        }
    }

}
