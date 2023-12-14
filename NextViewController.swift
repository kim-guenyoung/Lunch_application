import UIKit

class NextViewController: UIViewController {

    var displayedText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use displayedText as needed, e.g., set it to a label
        let label = UILabel(frame: CGRect(x: 50, y: 100, width: 300, height: 30))
        label.text = displayedText
        view.addSubview(label)
    }
}
