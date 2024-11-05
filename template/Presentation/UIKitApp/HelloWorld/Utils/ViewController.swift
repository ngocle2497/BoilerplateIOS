import Foundation
import UIKit
import Combine

enum KeyboardEventType {
    case wilShow
    case didShow
    case willHide
    case didHide
}

class ViewController<VM: ViewModel>: UIViewController, UIGestureRecognizerDelegate {
    
    private let viewModel: VM!
    var bag = Set<AnyCancellable>()
    private var tap: UITapGestureRecognizer?
    var listenKeyboardChange: Bool = false {
        didSet {
            setupKeyboardChange()
        }
    }
    
    var hideKeyboardWhenClickOutSide: Bool = false {
        didSet {
            setupHideKeyboard()
        }
    }
    
    var vm: VM {
        get {
            return viewModel
        }
    }
    
    var statusBarStyle: UIStatusBarStyle = .darkContent {
        didSet {
            self.updateStatusBar()
        }
    }
    
    var screenOrientations: UIInterfaceOrientationMask = .portrait {
        didSet {
            if #available(iOS 16.0, *) {
                self.navigationController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            } else {
                UIDevice.current.setValue(screenOrientations, forKey: "orientation")
            }
        }
    }
    
    var getureEnabled = true {
        didSet {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = getureEnabled
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask  {
        get {
            return screenOrientations
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return statusBarStyle
        }
    }
    
    required init(vm: VM, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        viewModel = vm
        let resourceName = nibNameOrNil ?? String(describing: Self.self)
        if Bundle.main.path(forResource: resourceName, ofType: "xib") == nil {
            super.init(nibName: nil, bundle: nil)
        } else {
            super.init(nibName: resourceName, bundle: nibBundleOrNil)
        }
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterKeyboardChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatusBar()
        setupKeyboardChange()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap!.cancelsTouchesInView = true
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        setup()
        setupCombine()
    }
    
    // MARK: - Private ==============
    private func setupHideKeyboard() {
        guard let tap else {
            return
        }
        self.view.removeGestureRecognizer(tap)
        if hideKeyboardWhenClickOutSide {
            self.view.addGestureRecognizer(tap)
        }
    }
    private func setupKeyboardChange() {
        unRegisterKeyboardChange()
        if listenKeyboardChange {
            registerKeyboardChange()
        }
    }
    private func updateStatusBar() {
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private func registerKeyboardChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    private func unRegisterKeyboardChange() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardChange(type: .wilShow, keyboardSize: keyboardSize)
        }
    }
    
    @objc private func keyboardDidShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardChange(type: .didShow, keyboardSize: keyboardSize)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardChange(type: .willHide, keyboardSize: keyboardSize)
        }
    }
    
    @objc private func keyboardDidHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardChange(type: .didHide, keyboardSize: keyboardSize)
        }
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - Public ==============
    func keyboardChange(type: KeyboardEventType, keyboardSize: CGRect) {
        
    }
    func setup() {
        GLOBAL_SETTING.theme.dropFirst().sink(with: self, receiveValue: { vc, _ in
            vc.themeUpdate()
        }).store(in: &bag)
        
        GLOBAL_SETTING.language.dropFirst().sink(with: self, receiveValue: { vc, _ in
            vc.languageUpdate()
        }).store(in: &bag)
        
        GLOBAL_SETTING.fontSize.dropFirst().sink(with: self, receiveValue: { vc, _ in
            vc.fontSizeUpdate()
        }).store(in: &bag)
    }
    
    func setupView() {
        
    }
    
    func setupText() {
        
    }
    
    func setupCombine() {
        
    }
    
    func fontSizeUpdate() {
        setupText()
    }
    
    func languageUpdate() {
        setupText()
    }
    
    func themeUpdate() {
        setupView()
    }
}

class ViewModel {
    private(set) var bag = Set<AnyCancellable>()
    
    deinit {
        print("\(String(describing: self)) deinit")
    }
}
