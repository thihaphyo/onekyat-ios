import UIKit
import Utilities
import CommonExtensions

public class NavView: UIView {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var svNav: UIStackView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet public weak var btnBack: UIButton!
    @IBOutlet public weak var heightConst: NSLayoutConstraint!
    @IBOutlet public weak var btnRightAction: UIButton!
    @IBOutlet public weak var btnRightAction2: UIButton!
    @IBOutlet public weak var btnFav: UIButton!
    @IBOutlet public weak var btnShare: UIButton!
    @IBOutlet public weak var leftPadding: NSLayoutConstraint!
    
    public var enableAutoBackAction = true
    
    public var backButtonImage: UIImage? = UIImage(named: "ico.nav.back")?.withRenderingMode(.alwaysTemplate) {
        didSet {
            btnBack.setImage(backButtonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            btnBack.tintColor = .white
        }
    }
    
    public var enableBackAction = true {
        didSet {
            btnBack.isHidden = !enableBackAction
            leftPadding.constant = enableBackAction ? 10 : 20
        }
    }
    
    public var rightActionImage: UIImage? {
        didSet {
            btnRightAction.setTitle("", for: .normal)
            btnRightAction.setImage(rightActionImage, for: .normal)
            enableRightAction = true
        }
    }
    
    public var rightAction2Image: UIImage? {
        didSet {
            btnRightAction2.setTitle("", for: .normal)
            btnRightAction2.setImage(rightAction2Image, for: .normal)
            enableRightAction2 = true
        }
    }
    
    public var enableRightAction = false {
        didSet {
            if enableRightAction {
                btnRightAction.showView()
                //btnRightAction.addTarget(self, action: #selector(handleBackAction), for: .touchUpInside)
            } else {
                btnRightAction.hideView()
            }
        }
    }
    
    public var enableRightAction2 = false {
        didSet {
            if enableRightAction2 {
                btnRightAction2.showView()
                //btnRightAction.addTarget(self, action: #selector(handleBackAction), for: .touchUpInside)
            } else {
                btnRightAction2.hideView()
            }
        }
    }
    
    public var enableShareAction = false {
        didSet {
            enableShareAction ? btnShare.showView() : btnShare.hideView()
        }
    }
    
    public var enableFavAndShareAction = false {
        didSet {
            if enableFavAndShareAction {
                btnFav.showView()
                btnShare.showView()
                //btnRightAction.addTarget(self, action: #selector(handleBackAction), for: .touchUpInside)
            } else {
                btnFav.hideView()
                btnShare.hideView()
            }
        }
    }
    
    public var favState = false {
        didSet {
            if favState {
                btnFav.setImage(.load(named: "heart.fill"), for: .normal)
            } else {
                btnFav.setImage(.load(named: "heart.empty"), for: .normal)
            }
        }
    }
    
    @IBInspectable public var title: String? = nil {
        didSet {
            lblTitle.text = title
        }
    }
    
    public var alignment: NSTextAlignment? {
        didSet {
            lblTitle.textAlignment = alignment ?? .center
        }
    }
    
    public var rightTitle: String? {
        didSet {
            btnRightAction.setTitle(rightTitle, for: .normal)
        }
    }
    
    public var rightTitle2: String? {
        didSet {
            btnRightAction2.setTitle(rightTitle2, for: .normal)
        }
    }
    
    @IBInspectable public var bgColor: UIColor = .white {
        didSet {
            container.backgroundColor = bgColor
        }
    }
    public var didTapRightAction: (() -> Void)?
    public var didTapRightAction2: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupViews()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        heightConst.constant = hasTopNotch ? 120 : 100
    }
        
    func setupViews() {
        guard let navView = loadViewFromNib() else { return }
        
        navView.frame = bounds
        navView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(navView)

        lblTitle.textAlignment = .left
//        lblTitle.font = Font.asapRegular.size(18)
        if enableAutoBackAction {
            btnBack.addTarget(self, action: #selector(handleBackAction), for: .touchUpInside)
        }
        
        btnRightAction.addTarget(self, action: #selector(self.handleRightAction), for: .touchUpInside)
        btnRightAction.addTarget(self, action: #selector(self.handleRightAction2), for: .touchUpInside)
        
        //lblTitle.superview?.backgroundColor = .red
    }
    
    @objc func handleBackAction() {
        if (parentViewController?.navigationController) != nil && (parentViewController?.navigationController?.viewControllers.count ?? 0 > 1) {
            parentViewController?.popVC()
        } else {
            parentViewController?.dismissVC()
        }
    }
    
    @objc func handleRightAction() {
        didTapRightAction?()
    }
    
    @objc func handleRightAction2() {
        didTapRightAction2?()
    }
    
    fileprivate func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view
    }
    
}

public extension UIImage {
    static func load(named: String, in bundle: Bundle = CommonUI.bundle()) -> UIImage? {
        UIImage(named: named, in: bundle, compatibleWith: nil)
    }
}


class CommonUIBundle { }

public func bundle() -> Bundle {
    Bundle(for: CommonUIBundle.self)
}


public extension Bundle {
    static var commonUI: Bundle {
        Bundle(for: CommonUIBundle.self)
    }
}
