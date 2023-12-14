//
//  ViewController.swift
//  NavigationController
//
//  Created by 김근영 on 12/10/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrdata = ["학식", "PineTree", "BLUEPOT", "ing"]
    
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var sideview: UIView!
    
    @IBOutlet var sidebar: UITableView!
    
    var isSideViewOpen: Bool = false
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.lbl.text = arrdata[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC: UIViewController

        switch indexPath.row {
        case 0:
            let restaurant = self.storyboard?.instantiateViewController(withIdentifier: "restaurant") as! restaurant_ViewController
            destinationVC = restaurant
        case 1:
            let pinetree = self.storyboard?.instantiateViewController(withIdentifier: "pinetree") as! PineTreeViewController
            destinationVC = pinetree
        case 2:
            let bluepot = self.storyboard?.instantiateViewController(withIdentifier: "bluepot") as! BluePotViewController
            destinationVC = bluepot
        case 3:
            let ing = self.storyboard?.instantiateViewController(withIdentifier: "ing") as! ingViewController
            destinationVC = ing
        default:
            return
        }

        self.navigationController?.pushViewController(destinationVC, animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imgView.image = UIImage(named: "수뭉.png")
        sideview.isHidden = true
        sidebar.backgroundColor = UIColor.groupTableViewBackground
        isSideViewOpen = false
    }
    
    @IBAction func btnmenu(_ sender: UIButton) {
        sidebar.isHidden = false
        sideview.isHidden = false
        
        self.view.bringSubviewToFront(sideview)
        if !isSideViewOpen{
            isSideViewOpen = true
            sideview.frame = CGRect(x: 393, y: 103, width: 0, height: 749)
            sidebar.frame = CGRect(x:393, y: 103, width: 0, height: 749)
            
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("TableAnimation", context: nil)
            
            UIView.animate(withDuration: 0.3) {
                self.sideview.frame = CGRect(x: 158, y: 103, width: 237, height: 749)
                self.sidebar.frame = CGRect(x: 24, y: 0, width: 213, height: 749)
            }
            UIView.commitAnimations()
        }
        else{
            sidebar.isHidden = true
            sideview.isHidden = true
            isSideViewOpen = false
            
            sideview.frame = CGRect(x: 158, y: 103, width: 0, height: 749)
            sidebar.frame = CGRect(x:24, y: 0, width: 0, height: 749)
            
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("TableAnimation", context: nil)
            
            sideview.frame = CGRect(x: 158, y: 103, width: 237, height: 496)
            sidebar.frame = CGRect(x: 24, y: 0, width: 213, height: 476)
            
            UIView.commitAnimations()
        }
    }
}
