import UIKit


public func degreeToAngle(_ degree:CGFloat) -> CGFloat{
  return (degree / 180.0)  * CGFloat(M_PI)
}

public class DialLayer: CALayer{
  
  let dialLineLength : CGFloat = 8
  override public  func draw(in ctx: CGContext) {
    //    backgroundColor = UIColor.blue.cgColor
    let seconds = 1...60
    
    let degreePerSecond = 360.0 / CGFloat(seconds.count)
    
    for second in seconds{
      let degree = degreePerSecond * CGFloat(second)
      let gradLineWidth : CGFloat = (second % 15 == 0) ?  2: 1
      let gradLineLength : CGFloat = (second % 15 == 0) ? dialLineLength: dialLineLength - 4
      let strokeColor = (second % 15 == 0) ? UIColor.black.cgColor: UIColor.darkGray.cgColor
      ctx.setLineWidth(gradLineWidth)
      ctx.setStrokeColor(strokeColor)
      ctx.saveGState()
      ctx.translateBy(x: bounds.width * 0.5, y: bounds.height * 0.5)
      ctx.rotate(by: degreeToAngle(degree))
      ctx.translateBy(x: 0, y: -bounds.height * 0.5)
      ctx.move(to: CGPoint(x: 0, y: 0))
      ctx.addLine(to:CGPoint(x: 0, y: gradLineLength))
      ctx.restoreGState()
    }
    ctx.strokePath()
  }
}

func makeHourLabel(hour:Int) -> CATextLayer{
  let hour12 = CATextLayer()
  hour12.string = String(describing: hour)
  hour12.contentsScale = UIScreen.main.scale
  hour12.isWrapped = true
  hour12.foregroundColor = UIColor.black.cgColor
  hour12.alignmentMode = kCAAlignmentCenter
//  hour12.backgroundColor = UIColor.gray.cgColor
  return hour12
}


public class ClockView: UIView{
  
  let dialLayer = DialLayer()
  
  public let clockMaskLayer = CAShapeLayer()
  let  hourLabelLayers: [CATextLayer] = {
    return (1...12).map{  makeHourLabel(hour: $0) }
  }()
  
  let hourHandLayer = CAShapeLayer()
  let minuteHandLayer = CAShapeLayer()
  let secondHandLayer = CAShapeLayer()
  
  
  public override init(frame: CGRect) {
    super.init(frame:frame)
    dialLayer.contentsScale = UIScreen.main.scale
    layer.addSublayer(dialLayer)
    
    let baseLabel = UILabel(frame: .zero)
    baseLabel.font = UIFont.systemFont(ofSize: 13)
    baseLabel.text = "12"
    let hourLabelSize = baseLabel.intrinsicContentSize
    
    for hourLabelLayer in hourLabelLayers{
      hourLabelLayer.fontSize = baseLabel.font.pointSize
      hourLabelLayer.frame.size = hourLabelSize
      layer.addSublayer(hourLabelLayer)
    }
    
    hourHandLayer.backgroundColor = UIColor.brown.cgColor 
    secondHandLayer.backgroundColor = UIColor.red.cgColor
    minuteHandLayer.backgroundColor = UIColor.black.cgColor
    
    layer.addSublayer(hourHandLayer)
    layer.addSublayer(minuteHandLayer)
    layer.addSublayer(secondHandLayer)
    
    secondHandLayer.zPosition = 3
    hourHandLayer.zPosition = 2
    minuteHandLayer.zPosition = 1
  }
  
  
  var radius: CGFloat {
    return min(bounds.width, bounds.height) * 0.5
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Not yet implemented")
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    dialLayer.frame = bounds
    dialLayer.setNeedsDisplay()
    
    let clockMaskPath = UIBezierPath(ovalIn: bounds)
    clockMaskLayer.frame = bounds
    clockMaskLayer.path = clockMaskPath.cgPath
    layer.mask = clockMaskLayer
    
    
    for (index,hourLabel) in hourLabelLayers.enumerated(){
      let hour = index + 1
      let  labelRadius = self.radius - hourLabel.frame.size.height * 0.5 - dialLayer.dialLineLength
      let degree = (360.0 / CGFloat(hourLabelLayers.count)) * CGFloat(hour)
      let tranX = labelRadius * sin(degreeToAngle(degree))
      let tranY = labelRadius - ( labelRadius * cos(degreeToAngle(degree)))
      
      // First put in 12
      hourLabel.position = CGPoint(x: bounds.midX, y: hourLabel.frame.size.height * 0.5 + dialLayer.dialLineLength)
      hourLabel.frame = hourLabel.frame.offsetBy(dx:tranX, dy: tranY)
    }
    
    let clockCenter = CGPoint(x: bounds.midX, y: bounds.midY)
    let secondHandLength = radius - dialLayer.dialLineLength
    
    secondHandLayer.bounds = CGRect(x:0, y: 0, width: secondHandLength, height: 2)
    secondHandLayer.position = clockCenter
    secondHandLayer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
    
    minuteHandLayer.bounds = CGRect(x: 0, y: 0, width: secondHandLength * 0.8, height: 3)
    minuteHandLayer.position = clockCenter
    minuteHandLayer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
    

    hourHandLayer.bounds = CGRect(x: 0, y: 0, width: secondHandLength * 0.5, height: 4)
    hourHandLayer.position = clockCenter
    hourHandLayer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
    tick()
    
  }
  
  public func tick(){
    updateTime(date: Date())
  }
  
  
  public func updateTime(date:Date){
    let calendar = NSCalendar.current
    let comps = calendar.dateComponents([.hour,.minute,.second], from: date)
    
    let baseRotationAngle = CGFloat(M_PI_2)
    let hourRotationAngle = (CGFloat(comps.hour! % 12) / 24.0) * CGFloat(2.0 * M_PI) - baseRotationAngle
    let minuteRotationAngle = (CGFloat(comps.minute!) / 60.0) * CGFloat(2.0 * M_PI) - baseRotationAngle
    let secondRotationAngle = (CGFloat(comps.second!) / 60.0) * CGFloat(2.0 * M_PI) - baseRotationAngle
    
    hourHandLayer.setAffineTransform(CGAffineTransform(rotationAngle:hourRotationAngle))
    minuteHandLayer.setAffineTransform(CGAffineTransform(rotationAngle:minuteRotationAngle))
    secondHandLayer.setAffineTransform(CGAffineTransform(rotationAngle:secondRotationAngle))
    
  }
  
  
}

