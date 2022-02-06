//
//  UIViewController.swift
//  CommonExtensions
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//
import UIKit
import SafariServices
import MapKit
import CoreLocation

public var hasTopNotch: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0 > 20
    }
    return false
}

public var topNotch: CGFloat {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    }
    return 0
}

public var bottomNotch: CGFloat {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    return 0
}

public extension UIViewController {
    
    func showShare(for pdf: Data) {
        let vc = UIActivityViewController(
            activityItems: [pdf],
            applicationActivities: nil
        )
        present(vc, animated: true)
    }
    
    func showShare(for pdf: URL, completion: @escaping (URL) -> Void) {
        let vc = UIActivityViewController(
            activityItems: [pdf],
            applicationActivities: nil
        )
        vc.completionWithItemsHandler = { _, _, _, _ in
            completion(pdf)
        }
        present(vc, animated: true)
    }

    
    func showShare(forLink link: String, templateText: String? = nil) {
        if let url = URL(string: link) {
            var sharingItems: [Any] = []
            if let text = templateText {
                sharingItems.append(text)
            }
            sharingItems.append(url)
            let vc = UIActivityViewController(
                activityItems: sharingItems,
                applicationActivities: nil)
            present(vc, animated: true)
        }
    }
    
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func popVCToBottom() {
        navigationController?.popToBottom()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc func dismissNavigation() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func popOrDismiss() {
        guard let nav = navigationController else {
            dismissVC()
            return
        }
        if nav.viewControllers.count > 1 {
            popVC()
        } else {
            dismissVC()
        }
    }
    
    func prepareForSlideupAnimation() {
        //hero.isEnabled = true
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    func prepareForFadeInAnimation() {
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
//    func slideup(_ view: UIView) {
//        view.hero.modifiers = [.duration(0.4), .translate(y: view.frame.height), .useGlobalCoordinateSpace]
//    }
    
    var isPresentedModally: Bool {
        
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar || false
    }
    
    func showAlert(title: String? = "", message: String?, actionTitle: String = "OK", actionCallback: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (_) in
            actionCallback?()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(title: String? = "", message: String?, positiveTitle: String = "Yes", positiveAction: (() -> Void)? = nil, negativeTitle: String = "No", negativeAction:  (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: negativeTitle, style: .default, handler: { (_) in
            if negativeAction == nil { alertController.dismiss(animated: true, completion: nil) }
            negativeAction?()
        }))
        
        alertController.addAction(UIAlertAction(title: positiveTitle, style: .default, handler: { (_) in
            if positiveAction == nil { alertController.dismiss(animated: true, completion: nil) }
            positiveAction?()
        }))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func showInputAlert(title: String? = "", message: String? = "", submitAction: ((String) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = message
            textField.clearButtonMode = .whileEditing
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        })

        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let inputText = alert?.textFields![0].text ?? "" // Force unwrapping because we know it exists.
            submitAction?(inputText)
            alert?.dismiss(animated: true, completion: nil)
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func showForceInputAlert(title: String? = "", message: String? = "", submitAction: ((String) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = message
            textField.clearButtonMode = .whileEditing
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak alert] (action) in
            guard let inputText = alert?.textFields![0].text else { return }
            if !inputText.isEmpty {
                submitAction?(inputText)
                alert?.dismiss(animated: true, completion: nil)
            }
        }
        
        submitAction.isEnabled = false
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alert.textFields![0], queue: OperationQueue.main) { (notification) in
            let inputText = alert.textFields![0].text ?? ""
            submitAction.isEnabled = !inputText.isEmpty
        }
        
        alert.addAction(submitAction)

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func openURL(_ url: String) {
        if let url = URL(string: url) {
            if #available(iOS 11.0, *) {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true)
            } else {
                UIApplication.shared.open(url, options: [:])
            }
            
        }
    }
    
    func openURLInSafari(_ url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func replaceRootVC(with vc: UIViewController, duration: TimeInterval = 0.4, options: UIView.AnimationOptions = .transitionCrossDissolve) {
        guard let window = UIApplication.shared.keyWindow else { return }
        window.rootViewController = vc
        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
    }
    
    @objc
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    func call(phone no: String) {
        guard let url = URL(string: "tel://\(no)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    static func canOpenGoogleMap() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
    }
    
    static func canOpenAppleMap() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "http://maps.apple.com/maps")!)
    }
    
    func openGoogleMap(with coordinate: (lat: String, long: String)) {
         guard let url = URL(string: "comgooglemaps://?q=\(coordinate.lat),\(coordinate.long)") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func openAppleMap(with coordinate: (lat: Double?, long: Double?),  name: String?) {
//        guard let url = URL(string: "http://maps.apple.com/maps?saddr=\(coordinate.lat),\(coordinate.long)") else { return }
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        let coordinate = CLLocationCoordinate2DMake(coordinate.lat ?? 0,coordinate.long ?? 0)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
        mapItem.name = name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    func loadViewFromNib(nib: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nib, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func openAppStore(using url: String) {
        
        guard let url = URL(string: url) else {
            print("invalid app store url")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("can't open app store url")
        }
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("can't open setting")
        }
    }
    
    func openAppSetting() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString + (Bundle.main.bundleIdentifier ?? "")) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            } else {
                print("can't open app setting")
            }
        } else {
            print("can't open app setting")
        }
    }
    
    func showSettingsAlert(title: String, message: String) {
        if let appSettingURL = URL(string: UIApplication.openSettingsURLString) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { (_) -> Void in
                UIApplication.shared.open(appSettingURL, options: [:], completionHandler: nil)
            }))
            present(alert, animated: true)
        }
    }
}

extension UINavigationController {
    func pushFromBottom(_ viewControllerToPush: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        DispatchQueue.main.async {
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.pushViewController(viewControllerToPush, animated: false)
        }
    }
    
    func popToBottom() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        DispatchQueue.main.async {
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.popViewController(animated: false)
        }
    }
    
    func popTo<VC: UIViewController>(_ vc: VC.Type) {
        let vcs = viewControllers
        let index = vcs.firstIndex { $0 is VC }
        index.map { viewControllers[$0] }.then {
            popToViewController($0, animated: true)
        }
    }
    
    func replaceNPopTo<VC: UIViewController>(_ vc: VC.Type, with resetVC: UIViewController) {
        let vcs = viewControllers
        let index = vcs.firstIndex { $0 is VC }
        index.then {
            viewControllers[$0] = resetVC
        }
        popToViewController(resetVC, animated: true)
    }
    
    func contain<VC: UIViewController>(_ vc: VC.Type) -> Bool {
        viewControllers.contains { $0 is VC }
    }

}

public extension UIView {
    
    func animSlideUp(){
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 3, options: [.transitionCurlUp],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
    
    ////////////////////////////////////////////////
    // MARK: - Utilities
    ////////////////////////////////////////////////
    
    @IBInspectable var viewCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
//            self.layer.cornerRadius = newValue
        }
    }
    
    // Load Nib with ease
    class func fromNib<T: UIView>(_ view: T.Type, bundle: Bundle = .main) -> T {
        return bundle.loadNibNamed(T.className, owner: nil, options: nil)![0] as! T
    }
    
    func loadViewFromNib(nib: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nib, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func addSubViews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func showView() {
        isHidden = false
    }
    
    func hideView() {
        isHidden = true
    }
    
    func animateBorderColor(from oldColor: UIColor = .clear, to color: UIColor = .clear, withDuration duration: CFTimeInterval = 0.3, lay: CALayer? = nil) {
        let borderColor = CABasicAnimation(keyPath: "borderColor")
        borderColor.fromValue = oldColor.cgColor
        borderColor.toValue = color.cgColor
        borderColor.duration = duration
        if let lay = lay {
            lay.borderWidth = 1
            lay.borderColor = UIColor.red.cgColor
            lay.add(borderColor, forKey: "borderColor")
            lay.borderColor = color.cgColor
            return
        }
        layer.add(borderColor, forKey: "borderColor")
        layer.borderColor = color.cgColor
    }
    
    /// For two color combos, should add the first one again to make sure it smooths out.
    /// Example: To make [Red, Blue] gradient, add as [Red, Blue, Red] colors
    func addConicGradientBorder(colors: [CGColor], borderWidth: CGFloat, endPoint: CGPoint = .init(x: 1, y: 0)) {
        let gradient = CAGradientLayer()
        gradient.type = .conic
        gradient.startPoint = .init(x: 0.5, y: 0.5)
        gradient.endPoint = endPoint
        gradient.frame =  CGRect(origin: .zero, size: self.frame.size)
        gradient.colors = colors

        let shape = CAShapeLayer()
        shape.lineWidth = borderWidth
        shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.viewCornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape

        self.layer.addSublayer(gradient)
    }
    
    func mask(with image: String) {
        let imageView = UIImageView(image: UIImage(named: image))
        mask = imageView
    }
    //round specfic corner of view
    func maskByRoundingCorners(_ masks: UIRectCorner, withRadii radii: CGSize = CGSize(width: 10, height: 10)) {
        let rounded = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: masks, cornerRadii: radii)

        let shape = CAShapeLayer()
        shape.path = rounded.cgPath

        self.layer.mask = shape
    }

    func addBorder(toEdges edges: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.black.cgColor
        yourViewBorder.lineDashPattern = [2, 2]
        yourViewBorder.frame = self.bounds
        yourViewBorder.fillColor = nil
        let rounded = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        yourViewBorder.path = rounded.cgPath
        self.layer.addSublayer(yourViewBorder)
    }
    
    func addBorder(color: UIColor? = .black, thickness: CGFloat, radius: CGFloat) {
        self.clipsToBounds = true
        self.borderColor = color
        self.borderWidth = thickness
        self.viewCornerRadius = radius
    }
    
    ////////////////////////////////////////////////
    // MARK: Syntatic Sugar for NSlayoutConstraint
    ////////////////////////////////////////////////
    func fillToSuperview(withPadding padding: UIEdgeInsets) {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor, padding: padding)
    }
    
    func fillToSuperview() {
        fillToSuperview(withPadding: .zero)
    }
    
    func fillToSuperviewSafeArea() {
        anchor(top: superview?.safeAreaLayoutGuide.topAnchor, leading: superview?.safeAreaLayoutGuide.leadingAnchor, bottom: superview?.safeAreaLayoutGuide.bottomAnchor, trailing: superview?.safeAreaLayoutGuide.trailingAnchor, padding: .zero)
    }
    
    func removeAllConstraints() {
        self.constraints.forEach { self.removeConstraint($0) }
    }
    
    func aspectRatio(_ ratio: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0).isActive = true
    }
    
    func centerInSuperview() {
        anchor(centerX: superview?.centerXAnchor, centerY: superview?.centerYAnchor)
    }
    
    func anchorSize(to view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero, centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func addShadow(with color: UIColor? = UIColor(white: 0, alpha: 0.1), opacity: Float = 1, radius: CGFloat = 3, offset: CGSize = CGSize(width: 0, height: 2)) {
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowColor = color?.cgColor
    }
    
    func removeShadow() {
        layer.shadowOpacity = 0
        layer.shadowOffset = .init()
        layer.shadowRadius = 0
        layer.shadowColor = UIColor.clear.cgColor
    }
    
    func addCornerAndShadow(corner: CGFloat, color: UIColor = UIColor(white: 0, alpha: 0.1), opacity: Float = 1, radius: CGFloat = 3, offset: CGSize = CGSize(width: 0, height: 2)) {
        
        self.layer.cornerRadius = corner
        self.clipsToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
    }
    
    ////////////////////////////////////////////////
    // MARK: Inner Shadow for each specific side
    ////////////////////////////////////////////////
    // different inner shadow styles
    enum InnerShadowSide {
        case all, left, right, top, bottom, topAndLeft, topAndRight, bottomAndLeft, bottomAndRight, exceptLeft, exceptRight, exceptTop, exceptBottom
    }
    
    // define function to add inner shadow
    func addInnerShadow(onSide: InnerShadowSide, shadowColor: UIColor, shadowSize: CGFloat, cornerRadius: CGFloat = 0.0, shadowOpacity: Float) {
        // define and set a shaow layer
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowSize
        shadowLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        // define shadow path
        let shadowPath = CGMutablePath()
        
        // define outer rectangle to restrict drawing area
        let insetRect = bounds.insetBy(dx: -shadowSize * 2.0, dy: -shadowSize * 2.0)
        
        // define inner rectangle for mask
        let innerFrame: CGRect = { () -> CGRect in
            switch onSide {
            case .all:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
            case .left:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .right:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .top:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case.bottom:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndLeft:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndRight:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndLeft:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndRight:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .exceptLeft:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptRight:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptTop:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            case .exceptBottom:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            }
        }()
        
        // add outer and inner rectangle to shadow path
        shadowPath.addRect(insetRect)
        shadowPath.addRect(innerFrame)
        
        // set shadow path as show layer's
        shadowLayer.path = shadowPath
        
        // add shadow layer as a sublayer
        layer.addSublayer(shadowLayer)
        
        // hide outside drawing area
        clipsToBounds = true
    }
    
    /**
     change red border color
     */
    func error() {
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    /**
     change green border color
     */
    func valid() {
        self.layer.borderColor = UIColor.green.cgColor
    }
    /**
     screenshot of a view
     */
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    enum Corner {
        case TOP_LEFT
        case TOP_RIGHT
        case BOT_LEFT
        case BOT_RIGHT
    }
    
    func addCornerRadius(corners: [Corner], radius: CGFloat) {
        self.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = radius
            var toCorners: CACornerMask = []
            for c in corners {
                if c == .TOP_LEFT {
                    toCorners.update(with: .layerMinXMinYCorner)
                } else if c == .TOP_RIGHT {
                    toCorners.update(with: .layerMaxXMinYCorner)
                } else if c == .BOT_LEFT {
                    toCorners.update(with: .layerMinXMaxYCorner)
                } else if c == .BOT_RIGHT {
                    toCorners.update(with: .layerMaxXMaxYCorner)
                }
            }
            if toCorners.isEmpty { return }
            self.layer.maskedCorners = toCorners
            
        } else {
            var toCorners: UIRectCorner = []
            for c in corners {
                if c == .TOP_LEFT {
                    toCorners.update(with: .topLeft)
                } else if c == .TOP_RIGHT {
                    toCorners.update(with: .topRight)
                } else if c == .BOT_LEFT {
                    toCorners.update(with: .bottomLeft)
                } else if c == .BOT_RIGHT {
                    toCorners.update(with: .bottomRight)
                }
            }
            if toCorners.isEmpty {return}
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: toCorners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    func fade(inward: Bool = false, duration: Double = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = inward ? 1 : 0
        })
    }
   
    func drawDottedLine(_ color: UIColor, lineWidth: CGFloat, lineLength: NSNumber, lineGap: NSNumber, startPoint: CGPoint, endPoint: CGPoint) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineDashPattern = [lineLength, lineGap]

        let path = CGMutablePath()
        path.addLines(between: [startPoint, endPoint])
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
}

// MARK: - Properties
public extension UIView {
    
    /// Border color of view; also inspectable from Storyboard.
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }
    
    /// Border width of view; also inspectable from Storyboard.
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// Corner radius of view; also inspectable from Storyboard.
//    @IBInspectable var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.masksToBounds = true
//            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
//        }
//    }
    
    /// Height of view.
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    /// Check if view is in RTL format.
    var isRightToLeft: Bool {
        if #available(iOS 10.0, *, tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }
    
    /// Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// Shadow color of view; also inspectable from Storyboard.
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    /// Size of view.
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
    
    /// Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    /// Width of view.
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    /// x origin of view.
    // swiftlint:disable:next identifier_name
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    /// y origin of view.
    // swiftlint:disable:next identifier_name
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
}

public extension UIView {

    class func getAllSubviews<T: UIView>(from parenView: UIView) -> [T] {
        return parenView.subviews.flatMap { subView -> [T] in
            var result = getAllSubviews(from: subView) as [T]
            if let view = subView as? T { result.append(view) }
            return result
        }
    }

    class func getAllSubviews(from parenView: UIView, types: [UIView.Type]) -> [UIView] {
        return parenView.subviews.flatMap { subView -> [UIView] in
            var result = getAllSubviews(from: subView) as [UIView]
            for type in types {
                if subView.classForCoder == type {
                    result.append(subView)
                    return result
                }
            }
            return result
        }
    }

    func getAllSubviews<T: UIView>() -> [T] {
        return UIView.getAllSubviews(from: self) as [T]
    }
    
    func get<T: UIView>(all type: T.Type) -> [T] {
        return UIView.getAllSubviews(from: self) as [T]
    }
    
    func get(all types: [UIView.Type]) -> [UIView] {
        return UIView.getAllSubviews(from: self, types: types)
    }
    
    /// Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable var shadowAlpha: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
}

import Foundation

public extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

public extension UIColor {

    convenience init(rgb: (CGFloat, CGFloat, CGFloat), alpha: CGFloat = 1) {
        self.init(red: rgb.0/255, green: rgb.1/255, blue: rgb.2/255, alpha: alpha)
    }
}

// below codes are from swifthexcolor lib

#if os(iOS) || os(tvOS)
    import UIKit
    typealias SWColor = UIColor
#else
    import Cocoa
    typealias SWColor = NSColor
#endif

private extension Int {
    func duplicate4bits() -> Int {
        return (self << 4) + self
    }
}

/// An extension of UIColor (on iOS) or NSColor (on OSX) providing HEX color handling.
public extension SWColor {
    /**
     Create non-autoreleased color with in the given hex string. Alpha will be set as 1 by default.

     - parameter hexString: The hex string, with or without the hash character.
     - returns: A color with the given hex string.
     */
    convenience init?(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }

    private convenience init?(hex3: Int, alpha: Float) {
        self.init(red:   CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
                  green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
                  blue:  CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0,
                  alpha: CGFloat(alpha))
    }

    private convenience init?(hex6: Int, alpha: Float) {
        self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
    }

    /**
     Create non-autoreleased color with in the given hex string and alpha.

     - parameter hexString: The hex string, with or without the hash character.
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: A color with the given hex string and alpha.
     */
    convenience init?(hexString: String, alpha: Float) {
        var hex = hexString

        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = String(hex[hex.index(after: hex.startIndex)...])
        }

        guard let hexVal = Int(hex, radix: 16) else {
            self.init()
            return nil
        }

        switch hex.count {
        case 3:
            self.init(hex3: hexVal, alpha: alpha)
        case 6:
            self.init(hex6: hexVal, alpha: alpha)
        default:
            // Note:
            // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
            // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
            // in future releases, not a feature. -- Apple Forum
            self.init()
            return nil
        }
    }

    /**
     Create non-autoreleased color with in the given hex value. Alpha will be set as 1 by default.

     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - returns: A color with the given hex value
     */
    convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }

    /**
     Create non-autoreleased color with in the given hex value and alpha

     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: color with the given hex value and alpha
     */
    convenience init?(hex: Int, alpha: Float) {
        if (0x000000 ... 0xFFFFFF) ~= hex {
            self.init(hex6: hex, alpha: alpha)
        } else {
            self.init()
            return nil
        }
    }
}
