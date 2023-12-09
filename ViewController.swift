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
    
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var lbl: UIPickerView!
    
    @IBOutlet var imgView: UIImageView!
    
    // 교직원 식당 json파싱을 위한 코드
    
    var isPriceDisplayed = false
    
    var jsonArray_fac: [[String: String]] = []
    var model = [FacultyArrayMenu]()
    
    // 학생식당 json파싱을 위한 코드
    var jsonArray_stu: [[String: String]] = []
    var model_student = [StudentArrayMenu]()
    
    var selectedDate: Date?
    let highlightWords = ["돼지갈비찜", "새우"]
    let indexOffset = 0  // You may need to adjust the value based on your requirements
    
    var lastSelectedOption: String?
    
    let options = ["라면타임 & 간식류", "단품코너", "오늘의 백반", "교직원 식당"]
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
                let warningAlert = UIAlertController(title: "교직원 식당", message: "주말에는 교직원 식당을 운영하지 않습니다.", preferredStyle: .alert)
                warningAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                // Present the warning alert after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.present(warningAlert, animated: true, completion: nil)
                }
            }

        case "라면타임 & 간식류":
            if weekday >= 2 && weekday <= 6 {
                let index = getMenuIndexForWeekday(weekday) + indexOffset
                if index < jsonArray_stu.count {
                    textView.text = jsonArray_stu[index]["text"]
                } else {
                    textView.text = "학식을 ! 운영하지 않습니다."
                }
            } else {
                // alert로 띄우기
                let warningAlert = UIAlertController(title: "라면타임 & 간식류", message: "주말에는 라면타임 & 간식류를 운영하지 않습니다.", preferredStyle: .alert)
                warningAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                // Present the warning alert after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.present(warningAlert, animated: true, completion: nil)
                }
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
                // alert로 띄우기
                let warningAlert = UIAlertController(title: "경고", message: "주말에는 단품 코너를 운영하지 않습니다.", preferredStyle: .alert)
                warningAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                // Present the warning alert after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.present(warningAlert, animated: true, completion: nil)
                }
            }
        case "오늘의 백반":
            if weekday == 6 {
                textView.text = "단품 코너를 이용해주세요."
            } else if weekday >= 2 && weekday <= 6 {
                let index = getIndexForTodaySpecial(weekday)
                print("Weekday: \(weekday), Index for Today Special: \(index)")
                
                if index - 1 < jsonArray_stu.count {
                    textView.text = jsonArray_stu[index - 1]["text"]
                }
                else{
                    let alert = UIAlertController(title: "오늘의 백반 운영 안내", message: "주말에는 오늘의 백반을 운영하지 않습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        default:
            if weekday >= 2 && weekday <= 6 {
                let index = getMenuIndexForWeekday(weekday) + indexOffset
                if index < jsonArray_fac.count {
                    textView.text = jsonArray_fac[index]["text"]
                } else {
                    // Handle the case where jsonArray_fac is empty or index is out of bounds
                    textView.text = "학식을 운영하지 않습니다."
                }
            } else {
                // alert로 띄우기
                let alert = UIAlertController(title: "교직원 식당 운영 안내", message: "주말에는 교직원 식당을 운영하지 않습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
        
        highlightWords.forEach { word in
            if textView.text.contains(word) {
                highlightTextInTextView(textView.text, highlightText: word)
            }
        }
        
        textView.textAlignment = .center
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
        imgView.isUserInteractionEnabled = true // Enable user interaction

        // Bring the imgView to the front
        imgView.bringSubviewToFront(view)
        
        let currentDate = Date()
        selectedDate = currentDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM월 dd일 (EEE)"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        let formattedDate = dateFormatter.string(from: currentDate)
        
        if let lastSelectedOption = lastSelectedOption {
            displayTextForSelectedOption(lastSelectedOption)
        } else {
            // Handle the case where the user hasn't picked a restaurant yet
            print("Please select a restaurant.")
        }
        
        //        todayDate.text = "오늘 날짜 : \(formattedDate)"
        //        todayDate.text = "선택된 날짜: \(dateFormatter.string(from: selectedDate!))"
        
        pickerView.selectRow(0, inComponent: 0, animated: true)
        lastSelectedOption = options[0]
        
        // Load JSON data for faculty menu
        pickerView.delegate = self
        pickerView.dataSource = self
        displayTextForSelectedOption(lastSelectedOption!)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imgViewTapped(_:)))
        imgView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    
    @objc func imgViewTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedOption = lastSelectedOption else {
            return
        }

        // Toggle the price display state
        isPriceDisplayed.toggle()

        // Show or hide price based on the state
        if isPriceDisplayed {
            showPrice(for: selectedOption)
        } else {
            // If the price is not displayed, show the original text
            displayTextForSelectedOption(selectedOption)
        }
    }
    
    func showPrice(for option: String) {
        var priceText: String

        // 선택한 옵션에 따라 가격 텍스트를 결정합니다.
        switch option {
        case "라면타임 & 간식류":
            priceText = "라면타임 & 간식류 가격: $X.XX"
        case "단품코너":
            priceText = "단품코너 가격: $X.XX"
        case "오늘의 백반":
            priceText = "오늘의 백반 가격: 5000원"
        case "교직원 식당":
            priceText = "교직원 식당 가격: 7000원"
        default:
            priceText = "가격 정보 없음"
        }

        // 가격을 textView에 표시합니다.
        textView.text = priceText
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
            print(jsonArray_fac)
        } catch {
            print("Parsing Error: \(error)")
        }
    }
    func highlightTextInTextView(_ text: String, highlightText: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: highlightText, options: .caseInsensitive)
        
        if range.location != NSNotFound {
            attributedString.addAttribute(.backgroundColor, value: UIColor.yellow, range: range)
        }
        
        // Keep the existing text attributes, such as font size
        attributedString.addAttributes([.font: textView.font as Any], range: NSRange(location: 0, length: attributedString.length))
        
        textView.attributedText = attributedString
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
        
        
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date())
        
        // Update the selected date
        selectedDate = sender.date
        
        // Check if the selected date is in the current week
        if let selectedDate = selectedDate, !isDateInCurrentWeek(selectedDate) {
            // Display an alert informing the user that the menu information cannot be loaded for dates outside of the current week
            let warningAlert = UIAlertController(title: "주의", message: "학식을 불러올 수 없습니다.", preferredStyle: .alert)
            warningAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                // Set the date picker's date back to the current date
                sender.date = Date()
                self.selectedDate = sender.date
                self.displayTextForSelectedOption(self.lastSelectedOption ?? "")
            }))
            
            // Present the warning alert after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.present(warningAlert, animated: true, completion: nil)
            }
            
            // Display a message in the textView
            textView.text = "학식 정보를 불러올 수 없습니다!"
        } else {
            // Check if lastSelectedOption is not nil before updating the menu
            if let lastSelectedOption = lastSelectedOption {
                displayTextForSelectedOption(lastSelectedOption)
            } else {
                // Handle the case where the user hasn't picked a restaurant yet
                print("Please select a restaurant.")
            }
        }
    }
    func isDateInCurrentWeek(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let currentWeek = calendar.component(.weekOfYear, from: Date())
        let selectedWeek = calendar.component(.weekOfYear, from: date)
        
        return currentWeek == selectedWeek
    }
    
    func clearAlert() {
        // Clear any existing alert
        if presentedViewController is UIAlertController {
            dismiss(animated: true, completion: nil)
        }
    }
}
