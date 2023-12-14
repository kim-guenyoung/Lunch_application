//
//  restaurant_ViewController.swift
//  NavigationController
//
//  Created by 김근영 on 12/10/23.
//

import UIKit

struct FacultyArrayMenu: Codable{
    var text: String
}
struct StudentArrayMenu: Codable {
    var text: String
}

class restaurant_ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var sendBtn: UIButton!
    
    @IBOutlet var pickerView: UIPickerView!
    
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var imgView: UIImageView!
    
    // 교직원 식당 json파싱을 위한 코드
    var receivedValue: String?
    var isPriceDisplayed = false
    var jsonArray_fac: [[String: String]] = []
    var model = [FacultyArrayMenu]()
    
    // 학생식당 json파싱을 위한 코드
    var jsonArray_stu: [[String: String]] = []
    var model_student = [StudentArrayMenu]()
    
    var selectedDate: Date?
    let indexOffset = 0
    var lastSelectedOption: String?
    let choList: [Character] = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
    let jungList: [Character] = ["ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ", "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ", "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"]
    let jongList: [String] = ["", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ", "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ", "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"]
    
    
    let options = ["라면타임 & 간식류", "단품코너", "오늘의 백반", "교직원 식당"]
    func getMenuIndexForWeekday(_ weekday: Int) -> Int {
        return weekday - 2
    }
    
    func displayTextForSelectedOption(_ selectedOption: String) {
        guard let unwrappedDate = selectedDate else {
            print("Error: selectedDate is nil.")
            return
        }
        var menuText: String = ""
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: unwrappedDate)
        switch selectedOption {
        case "교직원 식당":
            if weekday >= 2 && weekday <= 6 {
                let index = getMenuIndexForWeekday(weekday) + indexOffset
                if index < jsonArray_fac.count {
                    textView.text = jsonArray_fac[index]["text"]
                } else {
                    let alert = UIAlertController(title: "경고", message: "학식 정보가 없습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.present(alert, animated: true, completion: nil)
                    }
                    textView.text = "학식을 운영하지 않습니다."
                }
            } else {
                // alert 띄우기
                let warningAlert = UIAlertController(title: "교직원 식당", message: "주말에는 교직원 식당을 운영하지 않습니다.", preferredStyle: .alert)
                warningAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.present(warningAlert, animated: true, completion: nil)
                }
            }
            
        case "라면타임 & 간식류":
            if weekday >= 2 && weekday <= 6 {
                let index = getMenuIndexForWeekday(weekday) + indexOffset
                if index < jsonArray_stu.count {
                    textView.text = jsonArray_stu[index]["text"]
                    textView.textAlignment = .center
                } else {
                    let alert = UIAlertController(title: "경고", message: "학식 정보가 없습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    textView.text = "학식을 운영하지 않습니다."
                }
            } else {
                // alert 띄우기
                let warningAlert = UIAlertController(title: "라면타임 & 간식류", message: "주말에는 라면타임 & 간식류를 운영하지 않습니다.", preferredStyle: .alert)
                warningAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
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
                    let alert = UIAlertController(title: "경고", message: "학식 정보가 없습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.present(alert, animated: true, completion: nil)
                    }
                    textView.text = "학식을 운영하지 않습니다."
                }
            } else {
                // alert 띄우기
                let warningAlert = UIAlertController(title: "단품코너 운영 안내", message: "주말에는 단품 코너를 운영하지 않습니다.", preferredStyle: .alert)
                warningAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.present(warningAlert, animated: true, completion: nil)
                }
            }
        case "오늘의 백반":
            if weekday == 6 {
                textView.text = "단품 코너를 이용해주세요."
            } else if weekday >= 2 && weekday <= 6 {
                let index = getIndexForTodaySpecial(weekday)
                if index - 1 < jsonArray_stu.count {
                    textView.text = jsonArray_stu[index - 1]["text"]
                }
                else{
                    let alert = UIAlertController(title: "오늘의 백반 안내", message: "주말에는 오늘의 백반을 운영하지 않습니다.", preferredStyle: .alert)
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
                    let alert = UIAlertController(title: "경고", message: "학식 정보가 없습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.present(alert, animated: true, completion: nil)
                    }
                    textView.text = "학식을 운영하지 않습니다."
                }
            } else {
                // alert로 띄우기
                let alert = UIAlertController(title: "교직원 식당 운영 안내", message: "주말에는 교직원 식당을 운영하지 않습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
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
        
        let todaySpecialIndex = adjustedIndex + 10
        return max(min(weekday + 9, 14), 11)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingJsonArray()
        fetchingJsonArray_student()
        if let data = receivedValue {
            // data를 사용하여 원하는 동작 수행
            print("Received Data: \(data)")
        }
        imgView.image = UIImage(named: "수뭉.png")
        imgView.isUserInteractionEnabled = true
        
        // z-index
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
            print("")
        }
        
        pickerView.selectRow(0, inComponent: 0, animated: true)
        lastSelectedOption = options[0]
        
        pickerView.delegate = self
        pickerView.dataSource = self
        displayTextForSelectedOption(lastSelectedOption!)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imgViewTapped(_:)))
        imgView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func combineJamo(_ inputStr: String) -> String {
        var result = ""
        var i = 0
        
        while i < inputStr.count {
            let index1 = inputStr.index(inputStr.startIndex, offsetBy: i)
            let index2 = inputStr.index(inputStr.startIndex, offsetBy: i + 1)
            let index3 = inputStr.index(inputStr.startIndex, offsetBy: i + 2)
            
            // 종성 여부 확인
            if i + 2 < inputStr.count && jongList.contains(String(inputStr[index3])) {
                let choIndex = choList.firstIndex(of: Character(String(inputStr[index1])))!
                let jungIndex = jungList.firstIndex(of: Character(String(inputStr[index2])))!
                let jongIndex = jongList.firstIndex(of: String(inputStr[index3]))!
                
                let unicodeScalar = UnicodeScalar(0xAC00 + choIndex * 21 * 28 + jungIndex * 28 + jongIndex)!
                result.append(String(unicodeScalar))
                
                i += 3
            } else {
                // 종성 X -> 종성 없이 조합
                let choIndex = choList.firstIndex(of: Character(String(inputStr[index1])))!
                let jungIndex = jungList.firstIndex(of: Character(String(inputStr[index2])))!
                
                let unicodeScalar = UnicodeScalar(0xAC00 + choIndex * 21 * 28 + jungIndex * 28)!
                result.append(String(unicodeScalar))
                
                i += 2
            }
        }
        
        return result
    }
    
    @objc func imgViewTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedOption = lastSelectedOption else {
            return
        }
        //수뭉이 누르면 가격정보 보이게
        isPriceDisplayed.toggle()
        
        if isPriceDisplayed {
            showPrice(for: selectedOption)
        } else {
            displayTextForSelectedOption(selectedOption)
        }
    }
    
    func showPrice(for option: String) {
        var priceText: String
        
        switch option {
        case "라면타임 & 간식류":
            var menuPrices: [String] = []
            if textView.text.contains("라밥") {
                menuPrices.append("라밥 : 4500원")
            }
            
            if textView.text.contains("만두라면") {
                menuPrices.append("만두라면 : 4000원")
            }
            
            if textView.text.contains("해장라면") {
                menuPrices.append("해장라면 : 4000원")
            }
            
            if textView.text.contains("치즈") {
                menuPrices.append("치즈라면 : 4000원")
            }
            
            if textView.text.contains("떡") {
                menuPrices.append("떡라면 : 4000원")
            }
            
            if textView.text.contains("만두") {
                menuPrices.append("만두라면 : 4000원")
            }
            if textView.text.contains("카페") {
                menuPrices.append("카페/디저트는 키오스크\n확인 부탁드립니다.")
            }
            priceText = menuPrices.joined(separator: "\n")
            
        case "단품코너":
            var menuPrices: [String] = []
            if textView.text.contains("등심돈까스") {
                menuPrices.append("등심돈까스 : 6000원")
            }
            if textView.text.contains("고구마돈까스") {
                menuPrices.append("고구마돈까스 : 6000원")
            }
            if textView.text.contains("생선까스") {
                menuPrices.append("생선까스 : 5800원")
            }
            if textView.text.contains("치즈돈까스") {
                menuPrices.append("치즈돈까스 : 6000원")
            }
            if textView.text.contains("제육덮밥") {
                menuPrices.append("제육덮밥 : 5500원")
            }
            if textView.text.contains("소고기쌀국수") {
                menuPrices.append("소고기쌀국수 : 5000원")
            }
            if textView.text.contains("소고기카레덮밥") {
                menuPrices.append("소고기카레덮밥 : 5500원")
            }
            if textView.text.contains("야채비빔만두") {
                menuPrices.append("야채비빔만두 : 5000원")
            }
            if textView.text.contains("버터갈릭감자튀김") {
                menuPrices.append("버터갈릭감자튀김 : 3500원")
            }
            if textView.text.contains("미니핫도그") {
                menuPrices.append("미니핫도그 : 4000원")
            }
            if textView.text.contains("소떡소떡") {
                menuPrices.append("소떡소떡 : 3500원")
            }
            if textView.text.contains("오징어옥수수핫바") {
                menuPrices.append("오징어옥수수핫바 : 2500원")
            }
            if textView.text.contains("치킨마요덮밥") {
                menuPrices.append("치킨마요덮밥 : 5500원")
            }
            if textView.text.contains("돌솥알밥") {
                menuPrices.append("돌솥알밥 : 6000원")
            }
            priceText = menuPrices.joined(separator: "\n")
        case "오늘의 백반":
            priceText = "오늘의 백반 : 5000원"
        case "교직원 식당":
            priceText = "교직원 식당 : 7000원"
        default:
            priceText = "가격 정보 없음"
        }
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
        
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date())
        
        selectedDate = sender.date
        
        // alert -> 현재 날짜로 가게끔
        if let selectedDate = selectedDate, !isDateInCurrentWeek(selectedDate) {
            let warningAlert = UIAlertController(title: "주의", message: "학식을 불러올 수 없습니다.", preferredStyle: .alert)
            warningAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                sender.date = Date()
                self.selectedDate = sender.date
                self.displayTextForSelectedOption(self.lastSelectedOption ?? "")
            }))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.present(warningAlert, animated: true, completion: nil)
            }
            
            textView.text = "학식 정보를 불러올 수 없습니다!"
        } else { //마지막 옵션으로 가게끔
            if let lastSelectedOption = lastSelectedOption {
                displayTextForSelectedOption(lastSelectedOption)
            } else {
                print("")
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
        if presentedViewController is UIAlertController {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func updateTextColorIfNeeded() {
        guard let labelText = resultLabel.text, let textViewText = textView.text else {
            return
        }
        if !labelText.isEmpty {
            //String 대신 NSString 사용
            let attributedString = NSMutableAttributedString(string: textViewText)

            for char in labelText {
                let charString = String(char)
                let range = (textViewText as NSString).range(of: charString)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
                attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Verdana-Bold", size: 23.0)!, range: NSRange(location: 0, length: textViewText.count))
            }

            textView.attributedText = attributedString
            textView.textAlignment = .center
        }
    }
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        if let inputText = textField.text {
            let combine_result = combineJamo(inputText)
            resultLabel.text = "입력: \(combine_result)"
            updateTextColorIfNeeded()
            
        }
    }
}
