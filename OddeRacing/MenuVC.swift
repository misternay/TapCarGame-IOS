import UIKit

class MenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func onPressStart(_ sender: Any) {
        redirectToProcess()
    }
    
    
    func redirectToProcess(){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let mainVc = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(mainVc, animated: true)
    }
}
