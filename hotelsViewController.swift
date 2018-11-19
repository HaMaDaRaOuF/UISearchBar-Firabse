

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SystemConfiguration
import Zingle
import Kingfisher
import MapKit
import IQKeyboardManagerSwift


fileprivate let SearchBarHeight: Int = 40
class hotelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UISearchBarDelegate {

     @IBOutlet weak var tableView: UITableView!
     @IBOutlet weak var searchBar: UISearchBar!
    
    var refHotels: DatabaseReference!
    let locationManager = CLLocationManager()

    let DubaiColor = UIColor(red: 78/255, green: 80/255, blue: 92/255, alpha: 1)
    let tealBlue = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
    var isSearching: Bool = false
    //list to store all the artist
    var hotelList = [hotelsModel]()
    var filterHotels = [hotelsModel]()
    struct GlobalVariable{
        static var name = hotel?.name
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.setNavigationBarHidden(false, animated: true)
     
        if Reachability.isConnectedToNetwork(){
            
            print("Internet Connection Available!")
            
            refHotels = Database.database().reference().child("Hotels")
            
            //observing the data changes
            refHotels.observe(DataEventType.value, with: { (snapshot) in
                
                //if the reference have some values
                if snapshot.childrenCount > 0 {
                    
                    //clearing the list
                    self.hotelList.removeAll()
                    
                    //iterating through all the values
                    for hotel in snapshot.children.allObjects as! [DataSnapshot] {
                        //getting values
                        let key = self.refHotels.childByAutoId().key
                        let hotelObject = hotel.value as? [String: AnyObject]
                        let name  = hotelObject?["name"]
                        let Id  = hotelObject?["ID"]
                        let location = hotelObject?["location"]
                        let number = hotelObject?["number"]
                        let about = hotelObject?["about"]
                        let img = hotelObject?["img"]
                        let fBPage = hotelObject?["fBPage"]
                        let book = hotelObject?["book"]
                        let GPS = hotelObject?["GPS"]
                        let latitude = hotelObject?["latitude"]
                        let longtude = hotelObject?["longtude"]
                        let sImg = hotelObject?["sImg"]
                        let rateImg = hotelObject?["rateImg"]
                        let numberOfRate = hotelObject?["numberOfRate"]
                        let paidAd = hotelObject?["paidAdd"]
                        let SMS = hotelObject?["sms"]
                        let appSuggest = hotelObject?["appSuggest"]
                        let price = hotelObject?["price"]
                        let paymentNeeded = hotelObject?["paymentNeeded"]
                        let cancelation = hotelObject?["cancelation"]
                        let img1 = hotelObject?["img1"]
                        let img2 = hotelObject?["img2"]
                        let img3 = hotelObject?["img3"]
                        let img4 = hotelObject?["img4"]
                        let img5 = hotelObject?["img5"]
                        let img6 = hotelObject?["img6"]
                        let img7 = hotelObject?["img7"]
                        let img8 = hotelObject?["img8"]
                        let img9 = hotelObject?["img9"]
                        let img10 = hotelObject?["img10"]

                        
                        //creating artist object with model and fetched values
                        let hotel = hotelsModel(id: Id as! String?, name: name as! String?, appSuggest: appSuggest as! String?, location: location as! String?, number: number as! String?, content: about as! String?, img: img as! String?, FBPage: fBPage as! String?,book: book as! String?, GPS: GPS as! String?, latitude: latitude as! NSNumber?, longtude: longtude as! NSNumber?, sImg: sImg as! String?, paidAd: paidAd as! String?, SMS: SMS as! String?, price: price as! String?, paymentNeeded: paymentNeeded as! String?, cancelation: cancelation as! String?, rateImg: rateImg as! String?, img1: img1 as! String?, img2: img2 as? String, img3: img3 as? String, img4: img4 as! String?, img5: img5 as! String?, img6: img6 as! String?, img7: img7 as! String?, img8: img8 as! String?, img9: img9 as! String?, img10: img10 as! String?)

                        
                        //appending it to list
                        self.hotelList.append(hotel)
                    }
                    //reloading the tableview
                    self.tableView.reloadData()
                    
                }
            })
        } else {
            print("Internet Connection not Available!")
            Zingle.init(duration: 0.5, delay: 3)
                .message(message: "Internet Connection not Available!")
                //.messageIcon(icon: #imageLiteral(resourceName: "warning-icon"))
                .messageColor(color: .darkGray)
                .messageFont(font: UIFont.init(name: "AmericanTypewriter", size: 15.0)!)
                .backgroundColor(color: UIColor.white)
                .show()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
       if isSearching{
            return filterHotels.count
        } else {
        return hotelList.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! hotelsTableViewCell

        
            
        //the artist object
        let hotel: hotelsModel
        //getting the artist of selected position
        hotel = hotelList[indexPath.row]
        
        //adding values to labels
        cell.lblName.text = hotel.name
        cell.lblLocation.text = hotel.location
        cell.appSuggest.text = hotel.appSuggest
        cell.price.text = hotel.price
        cell.canceletion.text = hotel.cancelation
        cell.paymentNeeded.text = hotel.paymentNeeded
        
        if let imgUrl = hotel.img{
            let url = URL(string: imgUrl)
            cell.img.kf.setImage(with: url)
            cell.img.clipsToBounds = true
            cell.img.layer.cornerRadius = 10
            cell.img.layer.shadowColor = UIColor.black.cgColor
            cell.img.layer.shadowOpacity = 1.8
            cell.img.layer.shadowOffset = CGSize(width: 5, height: 0)
        }
        if let sImgUrl = hotel.sImg{
            let url = URL(string: sImgUrl)
            cell.smallImg.kf.setImage(with: url)
            
        }
        if let adImg = hotel.paidAd{
            let url = URL(string: adImg)
            cell.adImg.kf.setImage(with: url)
            
        }
        if let rateImgURL = hotel.rateImg{
            let url = URL(string: rateImgURL)
            cell.rateImg.kf.setImage(with: url)
            
        }
        
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
        cell.layer.transform = transform
        
        UIView.animate(withDuration: 1.0, animations: {
            
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        })
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        
        if isSearching{
            
            cell.lblName?.text = filterHotels[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if #available(iOS 10.0, *) {
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            print("Selected")
            let hotel = self.hotelList[indexPath.row]
            performSegue(withIdentifier: "hotelDetailes", sender: hotel)
            
        } else {
            // Fallback on earlier versions
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="hotelDetailes"{
            let dest = segue.destination as! hotelsDetailesViewController
            dest.hotel = sender as? hotelsModel
          
            
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
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false;
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterHotels.removeAll(keepingCapacity: false)
        let searchPredicate = searchBar.text!
        filterHotels = hotelList.filter( {$0.name?.range(of: searchPredicate) != nil})
        
        filterHotels.sort {$0.name! < $1.name! }
        isSearching = (filterHotels.count == 0) ? false: true
        tableView?.reloadData()
    }
    
}
/*
 filterDealers = dealerList.filter({ (text) -> Bool in
 
 let temp: NSString = text.EntityName! as NSString
 let range = temp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
 return range.location != NSNotFound
 
 })
 
 if(filterDealers.count == 0){
 searchActive = false;
 } else {
 searchActive = true;
 }
 refreshTable()
 */
