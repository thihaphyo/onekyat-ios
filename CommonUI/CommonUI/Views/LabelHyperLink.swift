//
//  LabelHyperLink.swift
//  CommonUI
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import UIKit

public protocol LabelHyperLinkProtocol: AnyObject {
    func labelHyperLink(onTappedUrlInLabel urlString: String)
}

public class LabelHyperLink: UILabel {
    
    var hyperRanges: [NSRange] = []
    var urlStrings: [String] = []
    public weak var delegate: LabelHyperLinkProtocol?
    
    public func setHyperLink(fullText: String, hyperLinkText: [String], urlString: [String], textColor: UIColor, hyperLinkColor: UIColor, textFont: UIFont, linkFont: UIFont, underLineForLink: Bool = false, textAlign: NSTextAlignment = .center, lineSpacing: CGFloat = 1.2, delegate: LabelHyperLinkProtocol? = nil) {
        
        self.urlStrings = urlString
        self.numberOfLines = 0
        
        let nsString = fullText as NSString
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlign
        paragraphStyle.lineHeightMultiple = lineSpacing
        
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [
            .paragraphStyle: paragraphStyle,
            .font: textFont,
            .foregroundColor: textColor
        ])
        
//        label.attributedText = NSAttributedString(string: "Text", attributes:
//        [.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        hyperRanges = []
        for links in hyperLinkText {
            let range = nsString.range(of: links)
            
            if underLineForLink {
                attributedString.addAttributes([
                    .foregroundColor: hyperLinkColor,
                    .font: linkFont,
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ], range: range)
            } else {
                attributedString.addAttributes([
                    .foregroundColor: hyperLinkColor,
                    .font: linkFont
                ], range: range)
            }
            
            hyperRanges.append(range)
        }
        
        self.textAlignment = textAlign
        self.attributedText = attributedString
        
        self.delegate = delegate
        if delegate != nil { setTapGesture() }
    }
    
    public func addImage(imgName: String) {
        
        // create our NSTextAttachment
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: imgName)
        imageAttachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)

        // wrap the attachment in its own attributed string so we can append it
        let imageString = NSAttributedString(attachment: imageAttachment)

        // add the NSTextAttachment wrapper to our full string, then add some more text.
        if let att = self.attributedText {
            let fullString = NSMutableAttributedString(attributedString: att)
            fullString.append(NSAttributedString(string: " "))
            fullString.append(imageString)
            fullString.append(NSAttributedString(string: " "))
            self.attributedText = fullString
        }
    }
    
    public func setTapGesture() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:))))
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: self)
        let index = indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        for i in 0..<hyperRanges.count {
            if checkRange(hyperRanges[i], contain: index) {
                self.delegate?.labelHyperLink(onTappedUrlInLabel: urlStrings[i])
                break
            }
        }
    }
    
    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
    
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}

