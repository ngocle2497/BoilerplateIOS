import UIKit

class ProfileViewController: ViewController<ProfileViewModel> {

    @IBOutlet weak var logoutButon: UIButton!
    
    static func create(with viewModel: ProfileViewModel) -> ProfileViewController {
        return ProfileViewController(vm: viewModel)
    }
    
    override func setup() {
        logoutButon.publisher(for: .touchUpInside).sink(with: self) { vc, _ in
            vc.vm.logout()
        }.store(in: &bag)
    }

}
