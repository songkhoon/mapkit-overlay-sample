//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

var str = "Hello, playground"

class ViewController: UIViewController {
    
    let degreesToRadians: (CGFloat) -> CGFloat = {
        return $0 / 180.0 * CGFloat(CGFloat.pi)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
    
    private func testImage() {
        var overlayImage = UIImage(named: "overlay_park.png")
        let originImage = UIImageView(image: overlayImage)
        //        originImage.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        originImage.backgroundColor = .blue
        originImage.contentMode = .scaleAspectFit
        view.addSubview(originImage)
        overlayImage = rotateImage(image: overlayImage!, angle: degreesToRadians(45), flipVertical: 0, flipHorizontal: 0)
        let image = UIImageView(image: overlayImage)
        //        image.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        image.frame.origin = CGPoint.zero
        image.backgroundColor = .red
        view.addSubview(image)
        view.layoutIfNeeded()
        
        originImage.translatesAutoresizingMaskIntoConstraints = false
        originImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        originImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        originImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        originImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        image.topAnchor.constraint(equalTo: originImage.bottomAnchor).isActive = true
        image.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        image.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    func rotateImage(image:UIImage, angle:CGFloat, flipVertical:CGFloat, flipHorizontal:CGFloat) -> UIImage? {
        let ciImage = CIImage(image: image)
        
        let filter = CIFilter(name: "CIAffineTransform")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setDefaults()
        
        let newAngle = angle * CGFloat(-1)
        
        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, CGFloat(newAngle), 0, 0, 1)
        transform = CATransform3DRotate(transform, CGFloat(Double(flipVertical) * M_PI), 0, 1, 0)
        transform = CATransform3DRotate(transform, CGFloat(Double(flipHorizontal) * M_PI), 1, 0, 0)
        
        let affineTransform = CATransform3DGetAffineTransform(transform)
        
        filter?.setValue(NSValue(cgAffineTransform: affineTransform), forKey: "inputTransform")
        
        let contex = CIContext(options: [kCIContextUseSoftwareRenderer:true])
        
        let outputImage = filter?.outputImage
        let cgImage = contex.createCGImage(outputImage!, from: (outputImage?.extent)!)
        
        let result = UIImage(cgImage: cgImage!)
        return result
    }
    
    func crop(image: UIImage, cropRect: CGRect) {
        UIGraphicsBeginImageContextWithOptions(cropRect.size, true, image.scale)
    }

    
}


let controller = ViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = controller