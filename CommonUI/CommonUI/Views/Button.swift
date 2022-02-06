//
//  Button.swift
//  CommonUI
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import Foundation
import Utilities
import RxSwift
import RxCocoa
import RxSwiftExt

enum ToggleState {
    case show
    case hide
}

public class Button: UIButton {
    
    public let tapped: PublishSubject<Void> = .init()
    
    public override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let longPressed = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressed))
        self.addGestureRecognizer(longPressed)
        self.addTarget(self, action: #selector(handleTapped), for: .touchUpInside)
    }
    
    @objc func handleTapped() {
        bounce(completion: { [weak self] isFinished in
            if isFinished {
                self?.tapped.onNext(())
            }
        })
    }
    
    @objc func handleLongPressed(_ gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            animate(.show)
            
        case .ended:
            animate(.hide)
            
        default:
            print("touch long: ", gesture.state)
        }
    }
    
    
    func animate(_ state: ToggleState) {
        
        UIView.animate(withDuration: 0.15, delay: 0, options: state == .show ? .curveEaseIn : .curveEaseOut, animations: { [weak self] in
            
            switch state {
            case .show:
                self?.select()
                
            case .hide:
                self?.unselect()
            }
        }, completion: { [weak self] isFinished in
            if isFinished && state == .hide {
                self?.tapped.onNext(())
            }
        })
    }
    
    func bounce(completion: @escaping (Bool) -> Void) {
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            
            self?.select()
            
        }, completion: { [weak self] isFinished in
            if isFinished {
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                    self?.unselect()
                }, completion: completion)
            }
        })
    }
    
    public override var isEnabled: Bool {
        didSet {
            isEnabled ? Styles.mainButtonStyle(self) : Styles.mainButtonDisabledStyle(self)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        layer.cornerRadius = 4
        titleLabel?.font = Styles.nBL8()
        isEnabled = true
    }
    
}

extension Button {
    
    func select() {
        transform = .init(scaleX: 0.97, y: 0.97)
        layoutIfNeeded()
    }
    
    func unselect() {
        transform = .identity
        layoutIfNeeded()
    }
}
