

import UIKit

class hotelsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var appSuggest: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var paymentNeeded: UILabel!
    @IBOutlet weak var canceletion: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var smallImg: UIImageView!
    @IBOutlet weak var rateImg: UIImageView!
    @IBOutlet weak var adImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
