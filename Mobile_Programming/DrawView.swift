//
//  DrawView.swift
//  Quiz
//
//  Created by Nahal Khalkhali on 11/30/21.
//

import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
    
    var defaultcolors = UIColor.black
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int? {
        willSet {
            // If new line selected while another line is selected...
            // Hide menu
            if newValue != selectedLineIndex {
                let menu = UIMenuController.shared
                if menu.isMenuVisible {
                    menu.setMenuVisible(false, animated: true)
                }
            }
        }
        
        didSet {
            // If line is deselected...
            // Hide menu
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                if menu.isMenuVisible {
                    menu.setMenuVisible(false, animated: true)
                }
            }
        }
    }
    var panRecognizer: UIPanGestureRecognizer!
    var longPressRecognizer: UILongPressGestureRecognizer!
    
    // MARK: - IBInspectables
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // double tap recognizer
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        // tap recognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        // long press recognizer
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DrawView.longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        // pan recognizer
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DrawView.panLine(_:)))
        panRecognizer.delegate = self
        panRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(panRecognizer)
    }
    
    // MARK: - GestureRecognizers
    
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        
        let alert = UIAlertController(title: "Warning", message: "Do you want to delete everythin on the screen?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.selectedLineIndex = nil
            self.currentLines.removeAll()
            self.finishedLines.removeAll()
            self.setNeedsDisplay()
        }
        alert.addAction(deleteAction)
        
        //Present the alert controller
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a tap")
        
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
        // Grab the menu controller
        let menu = UIMenuController.shared
        
        if selectedLineIndex != nil {
            
            // Make DrawView the target of menu item action messages
            becomeFirstResponder()
            
            // Create a new "Delete" UIMenuItem
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(DrawView.deleteLine(_:)))
            // Create a new Change color Option UIMenuItem
            let changeBlue = UIMenuItem(title: "Blue", action: #selector(DrawView.changeBlue(_:)))
            let changeRed = UIMenuItem(title: "Red", action: #selector(DrawView.changeRed(_:)))
            let changePink = UIMenuItem(title: "Pink", action: #selector(DrawView.changePink(_:)))
            let changeBrown = UIMenuItem(title: "Brown", action: #selector(DrawView.changeBrown(_:)))
            menu.menuItems = [deleteItem, changeBlue, changeRed, changePink, changeBrown]
            // Tell the menu where it should come from,
            // and show it
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)
        }
        
        setNeedsDisplay()
    }
 
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a long press")
        let point = gestureRecognizer.location(in: self)
        
        if gestureRecognizer.state == .began {
            
            selectedLineIndex = indexOfLine(at: point)
            
            if selectedLineIndex != nil {
                currentLines.removeAll()
            }
        }
        else if gestureRecognizer.state == .ended {
            selectedLineIndex = nil
            
            let menu = UIMenuController.shared
            
            let changeBlue = UIMenuItem(title: "Blue", action: #selector(DrawView.setBlue(_:)))
            let changeRed = UIMenuItem(title: "Red", action: #selector(DrawView.setRed(_:)))
            let changePink = UIMenuItem(title: "Pink", action: #selector(DrawView.setPink(_:)))
            let changeBrown = UIMenuItem(title: "Brown", action: #selector(DrawView.setBrown(_:)))
            menu.menuItems = [changeBlue, changeRed, changePink, changeBrown]
            
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)

            
        }
        
        setNeedsDisplay()
    }
    
    @objc func panLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognized a pan")
        
        guard longPressRecognizer.state == .changed
        else {
                return
        }
        
        // If a line is selected...
        if let index = selectedLineIndex {
            // When the pan recognizer changes its position...
            if gestureRecognizer.state == .changed {
                // How far has the pan moved?
                let translation = gestureRecognizer.translation(in: self)
                
                // Add the translation to the current beginning and end points of the line
                // Make sure there are no copy and paste typos!
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                
                // Redraw screen
                setNeedsDisplay()
            }
        }
    }
    
    // MARK: - Responder
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Draw
    
    func stroke(_ line: Line, colors: UIColor?) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        
        if(colors == nil){
            line.getColor().setStroke()
        }
        else{
            colors?.setStroke()
        }
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        // Draw finished lines in black
//        finishedLineColor.setStroke()
        for line in finishedLines {
            stroke(line, colors: nil )
        }
        
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            stroke(line, colors: currentLineColor )
        }
        
        if let index = selectedLineIndex {
//            UIColor.green.setStroke()
            let selectedLine = finishedLines[index]
            stroke(selectedLine, colors: UIColor.green)
        }
    }
    
    /// Returns the index of the Line closest to a given point
    func indexOfLine(at point: CGPoint) -> Int? {
        // Find a line close to point
        // Start from reverse, to prefer the latter drawn lines
        for (index, line) in finishedLines.enumerated().reversed() {
            let begin = line.begin
            let end = line.end
            
            // Check a few points on the line
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                // If the tapped point is within 10 points, let's return this line
                if hypot(x - point.x, y - point.y) < 10.0 {
                    return index
                }
            }
        }
        
        // If nothing is close enough to the tapped point,
        // then we did not select a line
        return nil
    }
    
    //MARK: - UIMenuController
    
    @objc func deleteLine(_ sender: UIMenuController) {
        // Remove the selected line from the list of finishedLines
        if let index = selectedLineIndex {
            finishedLines.remove(at: index)
            selectedLineIndex = nil
            
            // Redraw everything
            setNeedsDisplay()
        }
    }
    @objc func changeBlue(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].setColor(color: UIColor.blue)
            stroke(finishedLines[index], colors: nil)

            // Redraw everything
            setNeedsDisplay()
        }
    }
    @objc func changePink(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].setColor(color: UIColor.magenta)
            stroke(finishedLines[index], colors: nil)

            // Redraw everything
            setNeedsDisplay()
        }
    }
    @objc func changeRed(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].setColor(color: UIColor.red)
            stroke(finishedLines[index], colors: nil)

            // Redraw everything
            setNeedsDisplay()
        }
    }
    @objc func changeBrown(_ sender: UIMenuController) {
        if let index = selectedLineIndex {
            finishedLines[index].setColor(color: UIColor.brown)
            stroke(finishedLines[index], colors: nil)

            // Redraw everything
            setNeedsDisplay()
        }
    }
    
    //SET FOR THE LONG PAUSE 
    @objc func setBlue(_ sender: UIMenuController) {
        defaultcolors = UIColor.blue
        // Redraw everything
        setNeedsDisplay()
    }
    @objc func setRed(_ sender: UIMenuController) {
        defaultcolors = UIColor.red
        // Redraw everything
        setNeedsDisplay()
    }
    @objc func setPink(_ sender: UIMenuController) {
        defaultcolors = UIColor.magenta
        // Redraw everything
        setNeedsDisplay()
    }
    @objc func setBrown(_ sender: UIMenuController) {
        defaultcolors = UIColor.brown
        // Redraw everything
        setNeedsDisplay()
    }

    
    

    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let newLine = Line(begin: location, end: location, color: 4)
            
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                line.setColor(color: defaultcolors)
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        
        currentLines.removeAll()
        
        setNeedsDisplay()
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UIView {
    open func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
           var screenshotImage :UIImage?
           let layer = UIApplication.shared.keyWindow!.layer
           let scale = UIScreen.main.scale
           UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
           guard let context = UIGraphicsGetCurrentContext() else {return nil}
           layer.render(in:context)
           screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           if let image = screenshotImage, shouldSave {
               UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
           }
           return screenshotImage
       }
}

