import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let manager = CMMotionManager()
    let myUnit = ToneOutputUnit()
    
    override func viewWillDisappear(_ animated: Bool) {
        myUnit.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        myUnit.setFrequency(freq: 1000)
        myUnit.setToneVolume(vol: 1)
        myUnit.enableSpeaker()
        myUnit.setToneTime(t: 20000)
        
        manager.magnetometerUpdateInterval = 0.05
        manager.startMagnetometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self else {return}
            
            if let x = data?.magneticField.x,
               let y = data?.magneticField.y,
               let z = data?.magneticField.z {
                let freq = 100 + 5*sqrt(x*x+y*y+z*z)
                myUnit.setFrequency(freq: freq)
                
                let red = abs(x.truncatingRemainder(dividingBy: 255)) / 255
                let green = abs(y.truncatingRemainder(dividingBy: 255)) / 255
                let blue = abs(z.truncatingRemainder(dividingBy: 255)) / 255
                
                view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
            }
        }
    }
}
