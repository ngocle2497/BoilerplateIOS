import Foundation
import UIKit
import Combine

enum KeyboardEventType {
    case willShow
    case didShow
    case willHide
    case didHide
}

class ViewController<VM: ViewModel>: UIViewController, UIGestureRecognizerDelegate {
    
    private let viewModel: VM!
    var bag = Set<AnyCancellable>()
    private var tap: UITapGestureRecognizer?
    
    /// Set true to listen keyboard event. Default: false
    var listenKeyboardChange: Bool = false {
        didSet {
            setupKeyboardChange()
        }
    }
    
    /// Click root view to hide keyboard. Default: false
    var hideKeyboardWhenClickOutSide: Bool = false {
        didSet {
            setupHideKeyboard()
        }
    }
    
    /// View model
    var vm: VM {
        get {
            return viewModel
        }
    }
    
    /// Status bar style. Default: default
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            self.updateStatusBar()
        }
    }
    
    /// Change screen orientation. Default: .portrait
    var screenOrientation: UIInterfaceOrientationMask = .portrait {
        didSet {
            if #available(iOS 16.0, *) {
                self.navigationController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            } else {
                UIDevice.current.setValue(screenOrientation, forKey: "orientation")
            }
        }
    }
    
    ///  Enable swipe to back. Default: true
    var getureEnabled = true {
        didSet {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = getureEnabled
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask  {
        get {
            return screenOrientation
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
        GLOBAL_SETTING.theme.sink(with: self, receiveValue: { vc, _ in
            vc.themeUpdate()
        }).store(in: &bag)
        
        GLOBAL_SETTING.language.sink(with: self, receiveValue: { vc, _ in
            vc.languageUpdate()
        }).store(in: &bag)
        
        GLOBAL_SETTING.fontSize.sink(with: self, receiveValue: { vc, _ in
            vc.fontSizeUpdate()
        }).store(in: &bag)
        
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
            keyboardChange(type: .willShow, keyboardSize: keyboardSize)
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
    /// Called when keyboard status change (will show, did show, will hide, did hide). Required listenKeyboardChange: true
    func keyboardChange(type: KeyboardEventType, keyboardSize: CGRect) {
        
    }
    
    /// Called on  view did load
    func setup() {

    }
    
    /// Called when theme update or view loaded
    func setupView() {
        
    }
    
    /// Called when fontSize update or view loaded or language update
    func setupText() {
        
    }
    
    /// Called when view loaded to setting up combine
    func setupCombine() {
        
    }
    
    /// Called when fontSize update or view loaded
    func fontSizeUpdate() {
        setupText()
    }
    
    /// Called when language update or view loaded
    func languageUpdate() {
        setupText()
    }
    
    /// Called when theme update or view loaded
    func themeUpdate() {
        setupView()
    }
}

class ViewModel {
    private(set) var bag = Set<AnyCancellable>()
    
    deinit {
        print("\(String(describing: self)) de-init")
    }
}
