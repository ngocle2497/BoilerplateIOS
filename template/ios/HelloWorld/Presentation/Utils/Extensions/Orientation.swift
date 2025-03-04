import SwiftUI

func modifyOrientation(_ orientation: UIInterfaceOrientationMask) {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        AppDelegate.orientation = orientation
        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientation))
        windowScene.keyWindow?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
    }
}

class OrientationViewController: UIViewController {
    var loaded = false
    var orientation: UIInterfaceOrientationMask = .portrait {
        didSet {
            if loaded {
                modifyOrientation(orientation)
            }
            loaded = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        modifyOrientation(orientation)
    }
}

struct OrientationView: UIViewControllerRepresentable {
    var orientation: UIInterfaceOrientationMask = .portrait
    

    
    func makeUIViewController(context: Context) -> OrientationViewController {
        OrientationViewController()
    }
    
    func updateUIViewController(_ uiViewController: OrientationViewController, context: Context) {
        if uiViewController.orientation != orientation {
            uiViewController.orientation = orientation
        }
    }
}

extension View {
    func orientation(_ orientation: UIInterfaceOrientationMask?) -> some View {
        background(OrientationView(orientation: orientation ?? .portrait))
    }
}
