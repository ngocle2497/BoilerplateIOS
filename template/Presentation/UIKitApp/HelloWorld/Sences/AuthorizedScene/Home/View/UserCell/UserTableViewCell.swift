import UIKit
import Domain

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension UserTableViewCell {
    func setData(user: User) {
        userNameLabel.text = user.name
    }
}
