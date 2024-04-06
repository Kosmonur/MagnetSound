import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let manager = CMMotionManager()
    let myUnit = ToneOutputUnit()
    
    var baseFreq = 0.0
    
    override func viewWillDisappear(_ animated: Bool) {
        myUnit.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myUnit.enableSpeaker()
        myUnit.setToneTime(t: 20000)
        
        manager.magnetometerUpdateInterval = 0.05
        
        manager.startMagnetometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self else {return}
            
            if let x = data?.magneticField.x,
               let y = data?.magneticField.y,
               let z = data?.magneticField.z {
                let freq = sqrt(x*x+y*y+z*z)
                if baseFreq == 0 {
                    baseFreq = freq + 1
                }
                
                if freq > baseFreq {
                    myUnit.setFrequency(freq: freq)
                    myUnit.setToneVolume(vol: freq / 1000)
                } else {
                    myUnit.setToneVolume(vol: 0)
                }
                
                let red = abs(x.truncatingRemainder(dividingBy: 255)) / 255
                let green = abs(y.truncatingRemainder(dividingBy: 255)) / 255
                let blue = abs(z.truncatingRemainder(dividingBy: 255)) / 255
                
                view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
            }
        }
    }
}

