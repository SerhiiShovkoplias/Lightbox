import UIKit

protocol HeaderViewDelegate: class {
    func headerView(_ headerView: HeaderView, didPressLeftButton leftButton: UIButton)
    func headerView(_ headerView: HeaderView, didPressCloseButton closeButton: UIButton)
}

open class HeaderView: UIView {
    open fileprivate(set) lazy var closeButton: UIButton = { [unowned self] in
        let title = NSAttributedString(
            string: LightboxConfig.CloseButton.text,
            attributes: LightboxConfig.CloseButton.textAttributes)
        
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(closeButtonDidPress(_:)),
                         for: .touchUpInside)
        

        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            let attributedString = AttributedString(title)
            configuration.attributedTitle = attributedString
            configuration.image = LightboxConfig.CloseButton.image
            configuration.imagePadding = 6.0
            configuration.baseForegroundColor = attributedString.foregroundColor
            button.configuration = configuration
        } else {
            button.setAttributedTitle(title, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 8.0)
            if let image = LightboxConfig.CloseButton.image {
                button.setImage(image, for: .normal)
            }
        }
        
        if let size = LightboxConfig.CloseButton.size {
            button.frame.size = size
        } else {
            button.sizeToFit()
        }
        
        button.isHidden = !LightboxConfig.CloseButton.enabled
        
        return button
    }()
    
    open fileprivate(set) lazy var leftButton: UIButton = { [unowned self] in
        let title = NSAttributedString(
            string: LightboxConfig.LeftButton.text,
            attributes: LightboxConfig.LeftButton.textAttributes)
        
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(leftButtonDidPress(_:)),
                         for: .touchUpInside)
        

        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.plain()
            let attributedString = AttributedString(title)
            configuration.attributedTitle = attributedString
            configuration.image = LightboxConfig.LeftButton.image
            configuration.imagePadding = 6.0
            configuration.baseForegroundColor = attributedString.foregroundColor
            button.configuration = configuration
        } else {
            button.setAttributedTitle(title, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 8.0)
            if let image = LightboxConfig.LeftButton.image {
                button.setImage(image, for: .normal)
            }
        }
        
        if let size = LightboxConfig.LeftButton.size {
            button.frame.size = size
        } else {
            button.sizeToFit()
        }
        
        button.isHidden = !LightboxConfig.LeftButton.enabled
        
        return button
    }()
    
    weak var delegate: HeaderViewDelegate?
    
    // MARK: - Initializers
    
    public init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.clear
        
        [closeButton, leftButton].forEach { addSubview($0) }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func leftButtonDidPress(_ button: UIButton) {
        delegate?.headerView(self, didPressLeftButton: button)
    }
    
    @objc func closeButtonDidPress(_ button: UIButton) {
        delegate?.headerView(self, didPressCloseButton: button)
    }
}

// MARK: - LayoutConfigurable

extension HeaderView: LayoutConfigurable {
    
    @objc public func configureLayout() {
        let topPadding: CGFloat
        
        if #available(iOS 11, *) {
            topPadding = safeAreaInsets.top + 10.0
        } else {
            topPadding = 0
        }
        
        closeButton.frame.origin = CGPoint(
            x: bounds.width - closeButton.frame.width - 17,
            y: topPadding
        )
        
        leftButton.frame.origin = CGPoint(
            x: 17,
            y: topPadding
        )
    }
}
