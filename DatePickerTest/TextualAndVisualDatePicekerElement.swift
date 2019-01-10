//
//  TextualAndVisualDatePicekerElement.swift
//
//  Created by Flo on 15.12.18.
//  Copyright © 2018 TheraPsy IT OG. All rights reserved.
//

import Cocoa
import AppKit
import Carbon.HIToolbox
import Bond

class TextualAndVisualDatePickerElement: NSDatePicker {
    private var popover : NSPopover?
    @objc dynamic var visualDatePicker : NSDatePicker!
    override func becomeFirstResponder() -> Bool {
        showPopover(sender: self)
        return super.becomeFirstResponder()
    }
    
    override func keyDown(with event: NSEvent) {
        switch Int(event.keyCode) {
        case kVK_Escape:
            endPopover()
        default:
            break
        }
        super.keyDown(with: event)
    }
    override func resignFirstResponder() -> Bool {
        endPopover()
        return super.resignFirstResponder()
    }
    
    func showPopover(sender: NSDatePicker) {
        let controller = NSViewController()
        if DateAndTimeVisible(picker: self) {//TODO: somehow use Autolayout?
            controller.view = NSView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(276), height: CGFloat(148)))
        }
        else {
            controller.view = NSView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(139), height: CGFloat(148)))
        }
        
        if popover == nil {
            popover = NSPopover()
            popover!.contentViewController = controller
            popover!.contentSize = controller.view.frame.size
            popover!.appearance = NSAppearance.current
            popover!.animates = true
            
            visualDatePicker = NSDatePicker(frame: controller.view.frame)
            visualDatePicker.datePickerMode = .single
            visualDatePicker.isEnabled = true
            visualDatePicker.datePickerStyle = .clockAndCalendar
            visualDatePicker.datePickerElements = sender.datePickerElements
            
            self.reactive.objectValue.bidirectionalBind(to: visualDatePicker.reactive.objectValue)
            
            //using KVO
            visualDatePicker.bind(.value, to: self, withKeyPath: "dateValue", options: [:])
            
            //using setValue
            _ = self.reactive.objectValue.observeNext(with: {self.setValue($0, forKey: "dateValue")})
            _ = visualDatePicker.reactive.objectValue.observeNext(with: {sender.setValue($0, forKey: "dateValue")})
            
            //using willChange
            _ = self.reactive.objectValue.observeNext(with: {self.visualDatePicker.willChangeValue(forKey: "dateValue"); self.visualDatePicker.dateValue = $0 as! Date; self.visualDatePicker.didChangeValue(forKey: "dateValue")})
            _ = visualDatePicker.reactive.objectValue.observeNext(with: {self.willChangeValue(forKey: "dateValue"); self.dateValue = $0 as! Date; self.didChangeValue(forKey: "dateValue")})
            
            controller.view.addSubview(visualDatePicker)
        }
        popover!.show(relativeTo: sender.bounds, of: sender as NSView, preferredEdge: NSRectEdge.minY)
        
    }
    func endPopover(){
        if popover != nil {
            popover!.close()
        }
    }
    
    private func DateAndTimeVisible(picker : NSDatePicker) -> Bool {
        return picker.datePickerElements.rawValue &
            NSDatePicker.ElementFlags.hourMinute.rawValue > 0 &&
            picker.datePickerElements.rawValue &
            NSDatePicker.ElementFlags.yearMonthDay.rawValue > 0
            ||
            picker.datePickerElements.rawValue &
            NSDatePicker.ElementFlags.hourMinuteSecond.rawValue > 0 &&
            picker.datePickerElements.rawValue &
            NSDatePicker.ElementFlags.yearMonthDay.rawValue > 0
            ||
            picker.datePickerElements.rawValue &
            NSDatePicker.ElementFlags.hourMinute.rawValue > 0 &&
            picker.datePickerElements.rawValue &
            NSDatePicker.ElementFlags.yearMonth.rawValue > 0
            ||
            picker.datePickerElements.rawValue &
            NSDatePicker.ElementFlags.hourMinuteSecond.rawValue > 0 &&
            picker.datePickerElements.rawValue &
            NSDatePicker.ElementFlags.yearMonthDay.rawValue > 0
    }
    
    override public class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        if key == "dateValue" {
            return Set(["visualDatePicker.dateValue"])
        }
        if key == "visualDatePicker.dateValue" {
            return Set(["dateValue"])
        }
        return super.keyPathsForValuesAffectingValue(forKey: key)
    }

}
