//
//  ingViewController.swift
//  NavigationController
//
//  Created by 김근영 on 12/10/23.
//

import UIKit

class ingViewController: UIViewController {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lbl1: UILabel!
    
    @IBOutlet var lbl2: UILabel!
    
    @IBOutlet var lbl3: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = UIImage(named: "ing.jpg")
        imgView.alpha = 0.5
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        
        let currentDate = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: currentDate)
        let currentWeekday = calendar.component(.weekday, from: currentDate)
        
        // 현재 날짜가 평일이고, 시간이 평일 오전 8시부터 오후 6시 사이인 경우
        if (currentWeekday >= 2 && currentWeekday <= 6) && (currentHour >= 12 && currentHour <= 18) {
            lbl1.textColor = UIColor.systemGreen
        }

        // 토요일인 경우
        else if currentWeekday == 7 {
            lbl3.textColor = UIColor.red
        }
        // 일요일인 경우
        else if currentWeekday == 1 {
            lbl3.textColor = UIColor.red
        }
        // 평일이지만 8시부터 오후 6시 사이가 아닌 경우
        else {
            lbl1.textColor = UIColor.red
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
