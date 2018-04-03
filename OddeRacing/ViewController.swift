import UIKit
import Foundation

class ViewController: UIViewController {
    //MARK: -VARIABLE
    var timer = Timer()
    var score: Int = 0
    var saveState = [CGFloat]()
    var counter = 0
    var countEm = 0
    var speed:CGFloat  = 20
    var duration:Double = 1
    
    //MARK: -IBOUTLET
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func tapMiddle(_ sender: Any) {
        updateMoved(number: 160)
    }
    @IBAction func TapLeft(_ sender: Any) {
        updateMoved(number: 25)
    }
    
    @IBAction func tapRight(_ sender: Any) {
        updateMoved(number: 300)
    }
    
    //MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        genPlayerCar()
        gameStart()
    }
    
    //MARK: - GAME FUNCTION
    @objc func updateCounting(){
        scoreLabel.text = "\(score)"
        spawnEmCar()
        self.view.subviews.forEach { (res) in
            if res.restorationIdentifier?.contains("em") ?? false{
                UIView.animate(withDuration: 1, animations: {
                    self.checkCollision(em: res)
                })
            }
        }
        updateSpeed()
    }
    
    func checkCollision(em:UIView){
        self.view.subviews.forEach({ (viewCar) in
            if viewCar.restorationIdentifier?.contains("player") ?? false{
                    self.updateScore(player: viewCar, eme: em)
                }else{
                em.frame.origin.y += speed
            }
        })
    }
    
    func updateScore(player:UIView,eme:UIView){
        if eme.frame.intersects(player.frame){
            self.displayAlert()
            self.timer.invalidate()
        }else{
            eme.frame.origin.y += speed
        }
    }
    
    func spawnEmCar(){
        counter += 1
        let directionSpawn = [25,160,300]
        if counter  == 5{
            destroyCar()
            self.createEme(emCar: "\(self.countEm)",direction: directionSpawn.sample())
            self.createEme(emCar: "\(self.countEm)",direction: directionSpawn.sample())
            countEm += 2
            counter = 0
        }
    }
    
    func displayAlert(){
        let alert = UIAlertController(title: "GAME OVER", message: "SCORE = \(score)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "กลับหน้าหลัก", style: UIAlertActionStyle.default, handler: { res in
            self.backToPrevious()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func backToPrevious(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func gameStart(){
        let alert = UIAlertController(title: "PREPARE FOR START", message: "ARE U READY", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "START!", style: UIAlertActionStyle.default, handler: { (res) in
            self.timerSheduler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func timerSheduler(){
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCounting), userInfo: nil, repeats: true)
    }
    
    func updateMoved(number:CGFloat){
       self.view.subviews.forEach { (car) in
            if car.restorationIdentifier?.contains("player") ?? false{
                car.bringSubview(toFront: view)
                UIImageView.animate(withDuration: 0.3, animations: {
                    car.frame.origin.x = number
                })
            }
        }
    }
    
    func updateSpeed(){
        if score >= 10{
            self.speed = 40
            self.duration = 0.6
        }else if score >= 20{
            self.speed = 50
            self.duration = 0.3
        }else{
        }
    }
    
    //MARK: -Gennarate Car
    
    func genPlayerCar(){
        var imageView : UIImageView
        imageView  = UIImageView(frame: CGRect(x: view.frame.midX-30, y: view.frame.maxY-100, width: 60, height: 50));
        imageView.restorationIdentifier = "player"
        imageView.image = UIImage(named: "SimpleYellowCarTopView")
        self.view.addSubview(imageView)
    }
    
    func createEme(emCar: String, direction: Int){
        var imageView : UIImageView
        imageView  = UIImageView(frame: CGRect(x: direction, y: 0, width: 60, height: 50));
        imageView.restorationIdentifier = "em\(emCar)"
        imageView.image = UIImage(named:"redCar")
        self.view.addSubview(imageView)
    }
    
    func destroyCar(){
        self.view.subviews.forEach { (eme) in
            if eme.restorationIdentifier?.contains("em") ?? false && eme.frame.origin.y > 600{
                    eme.removeFromSuperview()
                self.score += 1
            }
        }
    }
}
extension Array {
    func sample() -> Element {
        let randomIndex = Int(arc4random_uniform(UInt32(3)))
        return self[randomIndex]
    }
}

