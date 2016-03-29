//
//  UITextViewWithPlaceHolder.swift
//  Appster
//
//  Created by Vien Vu  on 3/23/16.
//  Copyright © 2016 Appsters. All rights reserved.
//

import UIKit

private let UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.2

@IBDesignable class UITextViewWithPlaceHolder: UITextView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var placeHolder: String?
    @IBInspectable var placeHolderColor: UIColor?
    
    private var labelPlaceHolder: UILabel?

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        labelPlaceHolder = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if placeHolder == nil {
            self.placeHolder = ""
        }
        
        if placeHolderColor == nil {
            self.placeHolderColor = UIColor.lightGrayColor()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textChanged(_:)), name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        self.placeHolder = ""
        self.placeHolderColor = UIColor.lightGrayColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textChanged(_:)), name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.placeHolder = ""
        self.placeHolderColor = UIColor.lightGrayColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(textChanged(_:)), name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    
    func textChanged(notification: NSNotification) {
        if self.placeHolder!.characters.count == 0 {
            return
        }
        UIView.animateWithDuration(UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION, animations: {() -> Void in
            if self.text.characters.count == 0 {
                self.viewWithTag(9999)!.alpha = 1
            }
            else {
                self.viewWithTag(9999)!.alpha = 0
            }
        })
    }
    
    override func drawRect(rect: CGRect) {
        if self.placeHolder!.characters.count > 0 {
            if labelPlaceHolder == nil {
                self.labelPlaceHolder = UILabel(frame: CGRectMake(8, 8, self.bounds.size.width - 16, 0))
                self.labelPlaceHolder!.lineBreakMode = .ByWordWrapping
                self.labelPlaceHolder!.numberOfLines = 0
                self.labelPlaceHolder!.font = self.font
                self.labelPlaceHolder!.backgroundColor = UIColor.clearColor()
                self.labelPlaceHolder!.textColor = self.placeHolderColor
                self.labelPlaceHolder!.alpha = 0
                self.labelPlaceHolder!.tag = 9999
                self.addSubview(labelPlaceHolder!)
            }
            self.labelPlaceHolder!.text = self.placeHolder
            labelPlaceHolder!.sizeToFit()
            self.sendSubviewToBack(labelPlaceHolder!)
        }
        if self.text.characters.count == 0 && self.placeHolder!.characters.count > 0 {
            self.viewWithTag(9999)!.alpha = 1
        }
        super.drawRect(rect)
    }
    
}
