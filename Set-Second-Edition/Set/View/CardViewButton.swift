//
//  CardViewButton.swift
//  Set
//
//  Created by Ishankhonov Azizkhon on 7/12/18.
//  Copyright © 2018 Ishankhonov Azizkhon. All rights reserved.
//

import UIKit

class CardViewButton: UIButton {

  
    var colorCardButton : Variant?
    {
        didSet {
            setNeedsDisplay()
        }
    }
    var shapeCardButton: Variant?
    {
        didSet {
            setNeedsDisplay()
        }
    }
    var shadeCardButton: Variant?
    {
        didSet {
            setNeedsDisplay()
        }
    }
    var numberCardButton: Variant?
    {
        didSet {
            setNeedsDisplay()
        }
    }
      
    
    /// The path containing all shapes of this view.
    var path: UIBezierPath?
    
    /// The rect in which each path is drawn.
    private var drawableRect: CGRect {
        let drawableWidth = frame.size.width * 0.9
        let drawableHeight = frame.size.height * 0.9
        
        return CGRect(x: frame.size.width * 0.05,
                      y: frame.size.height * 0.05,
                      width: drawableWidth,
                      height: drawableHeight)
    }
    
    private var shapeHorizontalMargin: CGFloat {
        return drawableRect.width * 0.05
    }
    
    private var shapeVerticalMargin: CGFloat {
        return drawableRect.height * 0.05
    }
    
    private var shapeWidth: CGFloat {
        return (drawableRect.width - (2 * shapeHorizontalMargin)) / 3.33
    }
    
    private var shapeHeight: CGFloat {
        return (drawableRect.height - (2 * shapeVerticalMargin)) / 3.33
    }
    
    private var drawableCenter: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    /// Draws the ovals to the drawable rect
    func drawOval(number: Int) {
       
        let centerX = frame.size.width/2
        let centerY = frame.size.height/2
        
        path = UIBezierPath()
        let radius:CGFloat = sqrt(shapeWidth*shapeHeight)/2
        
        let insetY:CGFloat = 0.5*radius
        let insetX:CGFloat = 0.5*radius
        
        switch number {
        case 1:
            path?.append(createOval(CGPoint(x: centerX, y: centerY), radius))
        case 2:
            path?.append(createOval(CGPoint(x: centerX - insetX, y: centerY - radius - insetY), radius))
            path?.append(createOval(CGPoint(x: centerX + insetX, y: centerY + radius + insetY), radius))
        case 3:
            path?.append(createOval(CGPoint(x: centerX - insetX, y: centerY - 2*radius - insetY), radius))
            path?.append(createOval(CGPoint(x: centerX, y: centerY), radius))
            path?.append(createOval(CGPoint(x: centerX + insetX, y: centerY + 2*radius + insetY), radius))
        default:
            path?.append(createOval(CGPoint(x: centerX, y: centerY), radius))
        }
       
    }
    
    func createOval(_ center : CGPoint, _ radius : CGFloat) -> UIBezierPath{

        let circle = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        return circle
    }
    
    func drawTriangle(number: Int)
    {
        let centerX = frame.size.width/2
        let centerY = frame.size.height/2
       
        path = UIBezierPath()
        let radiusR:CGFloat = sqrt(shapeWidth*shapeHeight)/2
        let radiusSmallR=radiusR/2
        let triangleSide = radiusR*3/sqrt(3)
        
        let insetY:CGFloat = radiusR+radiusSmallR/2
        let insetX:CGFloat = 0.5*radiusR
        
        let aPoint = CGPoint(x: centerX, y: centerY-radiusR)
        let bPoint = CGPoint(x: centerX+triangleSide/2, y: centerY+radiusSmallR)
        let cPoint = CGPoint(x: centerX-triangleSide/2, y: centerY+radiusSmallR)
        
        switch number {
            case 1:
                path?.append(createTriangle(aPoint:aPoint,bPoint:bPoint,cPoint: cPoint))
            case 2:
                path?.append(
                createTriangle(
                    aPoint:CGPoint(x:aPoint.x-insetX, y:aPoint.y-insetY),
                    bPoint:CGPoint(x:bPoint.x-insetX, y:bPoint.y-insetY),
                    cPoint: CGPoint(x:cPoint.x-insetX, y:cPoint.y-insetY)))
                path?.append(
                createTriangle(
                    aPoint:CGPoint(x:aPoint.x+insetX, y:aPoint.y+insetY),
                    bPoint:CGPoint(x:bPoint.x+insetX, y:bPoint.y+insetY),
                    cPoint: CGPoint(x:cPoint.x+insetX, y:cPoint.y+insetY)))
            case 3:
                path?.append(
                    createTriangle(
                    aPoint:CGPoint(x:aPoint.x-2*insetX, y:aPoint.y-2*insetY),
                    bPoint:CGPoint(x:bPoint.x-2*insetX, y:bPoint.y-2*insetY),
                    cPoint: CGPoint(x:cPoint.x-2*insetX, y:cPoint.y-2*insetY)))
                path?.append(
                    createTriangle(
                    aPoint:CGPoint(x:aPoint.x, y:aPoint.y),
                    bPoint:CGPoint(x:bPoint.x, y:bPoint.y),
                    cPoint: CGPoint(x:cPoint.x, y:cPoint.y)))
                path?.append(
                    createTriangle(
                    aPoint:CGPoint(x:aPoint.x+2*insetX, y:aPoint.y+2*insetY),
                    bPoint:CGPoint(x:bPoint.x+2*insetX, y:bPoint.y+2*insetY),
                    cPoint: CGPoint(x:cPoint.x+2*insetX, y:cPoint.y+2*insetY)))
            default:
                path?.append(createTriangle(aPoint:aPoint,bPoint:bPoint,cPoint: cPoint))
        }
        
    }
  
    
    func createTriangle(aPoint:CGPoint, bPoint:CGPoint,cPoint:CGPoint) -> UIBezierPath{
       
        let triangle=UIBezierPath()
        triangle.move(to: aPoint)
        triangle.addLine(to: bPoint)
        triangle.addLine(to: cPoint)
        triangle.close()
        return triangle
    }
    func drawRectangle(number: Int)
    {
        let centerX = frame.size.width/2
        let centerY = frame.size.height/2
        
        path = UIBezierPath()
        let side:CGFloat = sqrt(shapeWidth*shapeHeight)
        
        let insetY:CGFloat = side*0.75
        let insetX:CGFloat = side*0.25
        
        switch number {
        case 1:
            path?.append(drawRectangle(centerX: centerX,centerY: centerY,width: side,height: side))
        case 2:
            path?.append(drawRectangle(centerX: centerX-insetX,centerY: centerY-insetY,width: side,height: side))
            path?.append(drawRectangle(centerX: centerX+insetX,centerY: centerY+insetY,width: side,height: side))
        case 3:
            path?.append(drawRectangle(centerX: centerX-insetX,centerY: centerY-2*insetY,width: side,height: side))
             path?.append(drawRectangle(centerX: centerX,centerY: centerY,width: side,height: side))
            path?.append(drawRectangle(centerX: centerX+insetX,centerY: centerY+2*insetY,width: side,height: side))
        default:
            path?.append(drawRectangle(centerX: centerX,centerY: centerY,width: side,height: side))
        }
    }
    func drawRectangle(centerX: CGFloat,centerY:CGFloat, width:CGFloat, height: CGFloat) -> UIBezierPath
    {
        let rectangle = UIBezierPath(rect: CGRect(x: centerX-width/2, y: centerY-height/2, width: width, height: height))
        return rectangle
    }
    override func draw(_ rect: CGRect) {
        guard  let color = colorCardButton else {
            return
        }
        guard let shape = shapeCardButton  else {
            return
        }
        guard let shade = shadeCardButton else {
            return
        }
        guard let number = numberCardButton else {
            return
        }
        
        switch shape {
        case Variant.v1:
            drawOval(number: number.rawValue)
        case Variant.v2:
            drawRectangle(number: number.rawValue)
        case Variant.v3:
            drawTriangle(number: number.rawValue)
            
        }
        
        
        switch shade {
        case Variant.v1:
            color.getColor().setFill()
            path!.fill()
            
        case Variant.v2:
            color.getColor().setStroke()
            path!.lineWidth = 0.02 * frame.size.width
            path!.stroke()
            
        case Variant.v3:
            path!.lineWidth = 0.02 * frame.size.width
            color.getColor().setStroke()
            path!.stroke()
            path!.addClip()
            
            var currentX: CGFloat = 0
            
            let stripedPath = UIBezierPath()
            stripedPath.lineWidth = 0.01 * frame.size.width
            
            while currentX < frame.size.width {
                stripedPath.move(to: CGPoint(x: currentX, y: 0))
                stripedPath.addLine(to: CGPoint(x: currentX, y: frame.size.height))
                currentX += 0.03 * frame.size.width
            }
            
            color.getColor().setStroke()
            stripedPath.stroke()
            
            break
        }
        
    }
    

}
