

import UIKit
import MapKit
import Social
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SystemConfiguration
import SafariServices
import Kingfisher
import Spring
import ImageSlideshow

class hotelsDetailesViewController: UIViewController, MKMapViewDelegate {

    var hotel : hotelsModel?
    var refHotels: DatabaseReference!
    let locationManager = CLLocationManager()
    
    var userBlind: Bool = false
    
    
    let DubaiColor = UIColor(red: 78/255, green: 80/255, blue: 92/255, alpha: 1)
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var sImg: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var about: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var img1: UIButton!
    @IBOutlet weak var img2: UIButton!
    @IBOutlet weak var img3: UIButton!
    @IBOutlet weak var img4: UIButton!
    @IBOutlet weak var img5: UIButton!
    
    //SmallphotosView
    @IBOutlet weak var imgOneButtonView: UIButton!
    @IBOutlet weak var imgTwoButtonView: UIButton!
    @IBOutlet weak var imgThreeButtonView: UIButton!
    @IBOutlet weak var imgfourButtonView: UIButton!
    @IBOutlet weak var imgFiveButtonView: UIButton!
    @IBOutlet weak var imgSixButtonView: UIButton!
    //Images Slider
    @IBOutlet var slideshow: ImageSlideshow!
    
//    let kingfisherSource = [KingfisherSource(urlString: "\(hotel.img)")!, KingfisherSource(urlString: "\(hotel.img)")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.title = "Restaurants"
        if Reachability.isConnectedToNetwork(){
            
            print("Internet Connection Available!")
            readRestaurantName()
            btnToImage()
            let latitudeNumber = hotel!.latitude as! NSNumber
            let longtudeNumber = hotel!.longtude as! NSNumber
            // 4) Set location of the map: Fuengirola - Malaga 36.5417° N, 4.6250° W
            restaurantsDetailsViewController.setMapLocation(mapView: mapView, latitude: CLLocationDegrees(truncating: latitudeNumber), longitud: CLLocationDegrees(truncating: longtudeNumber))
           
            // Do any additional setup after loading the view.
            print("\(hotel!.longtude) \(hotel?.latitude)")
            self.name.text = hotel?.name!
            self.location.text = hotel?.location
            self.about.text = hotel?.content
            
            if let profileImgUrl = hotel?.img{
                img.loadImagUsingCacheWithUrlString(urlString: profileImgUrl)
            }
            if let profileImgUrlsImg = hotel?.sImg{
                sImg.loadImagUsingCacheWithUrlString(urlString: profileImgUrlsImg)
            }
        } else {
            print("Internet Connection Not Available!")
            let alert = EMAlertController(icon: UIImage(named: "alertIconTest"), title: "Internet Error", message: "Internet Connection Not Available!")
            let action1 = EMAlertAction(title: "OK", style: .cancel) {
                // Perform Action
            }
            alert.addAction(action: action1)
            self.present(alert, animated: true, completion: nil)
        }
        
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        let kingfisherSource = [KingfisherSource(urlString: "\(hotel!.img1 ?? "ant")")!, KingfisherSource(urlString: "\(hotel!.img2 ?? "any")")!,KingfisherSource(urlString: "\(hotel!.img3 ?? "ant")")!, KingfisherSource(urlString: "\(hotel!.img4 ?? "any")")!,KingfisherSource(urlString: "\(hotel!.img5 ?? "ant")")!, KingfisherSource(urlString: "\(hotel!.img6 ?? "any")")!,KingfisherSource(urlString: "\(hotel!.img7 ?? "ant")")!, KingfisherSource(urlString: "\(hotel!.img8 ?? "any")")!,KingfisherSource(urlString: "\(hotel!.img9 ?? "ant")")!, KingfisherSource(urlString: "\(hotel!.img10 ?? "any")")!]
        
        slideshow.setImageInputs(kingfisherSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(oldOfDubaiViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    func readRestaurantName(){
        let vds = VDSTextToSpeech.shared
        if userBlind == true {
            vds.text = hotel?.name ?? "no text found."
            print("\(vds.text)")
            vds.speak()
        }
    }

    //Images Slider
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    //Map Functions
    static func setMapLocation(mapView: MKMapView, latitude: CLLocationDegrees, longitud: CLLocationDegrees, zoom: Double = 0.008){
        
        // define the map zoom span
        let latitudZoomLevel : CLLocationDegrees = zoom
        let longitudZoomLevel : CLLocationDegrees = zoom
        let zoomSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latitudZoomLevel, longitudeDelta: longitudZoomLevel)
        
        // use latitud and longitud to create a location coordinate
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitud)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitud))
        
        annotation.title = "Restaurant"
        
        mapView.addAnnotation(annotation)
        
        // define and set the region of our map using the zoom map and location
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: zoomSpan)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "mapViewidentifier"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            
            annotationView!.image = UIImage(named: "UnnonationIcon")!
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    func btnToImage() {
        
        if let img1 = hotel?.img1{
            let url = URL(string: img1)
            self.img1.kf.setImage(with: url, for: .normal)
        }
        if let img2 = hotel?.img2{
            let url = URL(string: img2)
            self.img2.kf.setImage(with: url, for: .normal)
        }
        if let img3 = hotel?.img3{
            let url = URL(string: img3)
            self.img3.kf.setImage(with: url, for: .normal)
        }
        if let img4 = hotel?.img4{
            let url = URL(string: img4)
            self.img4.kf.setImage(with: url, for: .normal)
        }
        if hotel?.img6 != "" {
            self.img5.text("more..")
        } else {
            if let img5 = hotel?.img5{
                let url = URL(string: img5)
                self.img5.kf.setImage(with: url, for: .normal)
                imgFiveButtonView.isHidden = false
            }
        }
        
    }
    
    public class Reachability {
        
        class func isConnectedToNetwork() -> Bool {
            
            var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            
            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
            if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
                return false
            }
            
            // Working for Cellular and WIFI
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            let ret = (isReachable && !needsConnection)
            
            return ret
            
        }
    }

    @IBAction func callBtn(_ sender: Any) {
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        } else {
            // Fallback on earlier versions
        }
        guard let number = URL(string: "tel://" + (self.hotel?.number)!) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(number)
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func smsBtn(_ sender: Any) {
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            if hotel?.SMS == "" {
                print("This Restaurant Haven't This Option Yet Sorry")
            } else {
                if let appURL = URL(string: "messenger://") {
                    let canOpenUrl = UIApplication.shared.canOpenURL(appURL)
                    print(canOpenUrl)
                    let appName = "fb-messenger-api"
                    let appScheme = "\(appName)://"
                    guard let number = URL(string: "\(appScheme)" + (hotel!.SMS)!) else { return }
                    if UIApplication.shared.canOpenURL(number as! URL)
                    {
                        UIApplication.shared.open(number, options:[:], completionHandler: nil)
                    }
                }
            }
        }
    }
    @IBAction func GPSBtn(_ sender: Any) {
        guard let urlString = URL(string: "http://" + (self.hotel?.GPS)!) else { return }
        if #available(iOS 10.0, *) {
            //UIApplication.shared.open(urlString)
            //SFSafariViewController(url: urlString, entersReaderIfAvailable: true)
            let vc = SFSafariViewController(url: urlString, entersReaderIfAvailable: true)
            vc.modalPresentationStyle = .pageSheet
            if #available(iOS 10.0, *) {
                vc.preferredControlTintColor = .white
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 10.0, *) {
                vc.preferredBarTintColor = DubaiColor
            } else {
                // Fallback on earlier versions
            }
            vc.delegate = self as? SFSafariViewControllerDelegate
            
            self.present(vc, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        } else {
            // Fallback on earlier versions
        }
    }
    @IBAction func bookBtn(_ sender: Any) {
        if hotel!.book == " " {
            let alert = EMAlertController(icon: UIImage(named: "alertIconTest"), title: "Sorry", message: "This Hotel Dosn't Have This Option")
            let action1 = EMAlertAction(title: "OK", style: .cancel) {
                // Perform Action
            }
            alert.addAction(action: action1)
            self.present(alert, animated: true, completion: nil)
        } else {
            if #available(iOS 10.0, *) {
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            } else {
                // Fallback on earlier versions
            }
            guard let number = URL(string: "http://" + (self.hotel?.book)!) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(number)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    @IBAction func img1Btn(_ sender: Any) {
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            didTap()
        } else {}
    }
    @IBAction func img2Btn(_ sender: Any) {
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            didTap()
        } else {}
    }
    @IBAction func img3Btn(_ sender: Any) {
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            didTap()
        } else {}
    }
    @IBAction func img4Btn(_ sender: Any) {
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            didTap()
        } else {}
    }
    @IBAction func moreBtn(_ sender: Any) {
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            didTap()
        } else {}
    }
    //Share Btn
    @IBAction func shareBtn(_ sender: Any) {
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            let num = "1"
            if num == "1" {
                //let image4.image = UIImage(named: "p1")
                let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
                vc?.add(sImg.image!)
                vc?.setInitialText("Portsaid")
                vc?.setInitialText("بورسعيد زمان")
                self.present(vc!, animated: true, completion: nil)
                
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
}
