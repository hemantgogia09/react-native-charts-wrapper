//  Created by xudong wu on 24/02/2017.
//  Copyright wuxudong
//

import Charts
import SwiftyJSON

class RNPieChartView: RNChartViewBase {
    let _chart: PieChartView;
    let _dataExtract : PieDataExtract;

    override var chart: PieChartView {
        return _chart
    }

    override var dataExtract: DataExtract {
        return _dataExtract
    }
  
    override init(frame: CoreGraphics.CGRect) {

        self._chart = PieChartView(frame: frame)
        self._dataExtract = PieDataExtract()

        super.init(frame: frame)

        self._chart.delegate = self
        self.addSubview(_chart)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDrawSliceText(_ enabled: Bool) {
        chart.drawEntryLabelsEnabled = enabled
    }


    func setUsePercentValues(_ enabled: Bool) {
        chart.usePercentValuesEnabled = enabled
    }


    func setCenterText(_ text: String) {
        chart.centerText = text
    }

    func setStyledCenterText(_ data: NSDictionary) {
        let json = BridgeUtils.toJson(data)

        var attrString: NSMutableAttributedString?
        if json["text"].string == nil
        {
            attrString = nil
        }
        else
        {
            #if os(OSX)
                let paragraphStyle = NSParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
            #else
                let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            #endif
            paragraphStyle.lineBreakMode = NSLineBreakMode.byTruncatingTail
            paragraphStyle.alignment = .center


            var color : NSUIColor?
            if json["color"].int != nil {
                color = RCTConvert.uiColor(json["color"].intValue)
            } else {
                color = UIColor.black
            }

            let fontSize = json["size"].float != nil ? CGFloat(json["size"].floatValue) : CGFloat(12)

            let textValue = json["text"].stringValue
            
            if(textValue.isEmpty){
                attrString = NSMutableAttributedString(string: textValue)
                attrString?.setAttributes([
                    NSAttributedString.Key.foregroundColor: color!,
                    NSAttributedString.Key.font: NSUIFont.systemFont(ofSize: fontSize),
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                    ], range: NSMakeRange(0, attrString!.length))
            }else{
                let data = textValue.split(separator: "\n")
                
                print("Data ---->", data[0])
                attrString = NSMutableAttributedString(string: String(data[0]))
                if #available(iOS 8.2, *) {
                    attrString?.setAttributes([
                        NSAttributedString.Key.foregroundColor: color!,
                        NSAttributedString.Key.font: NSUIFont.systemFont(ofSize: 30,weight: .bold),
                        NSAttributedString.Key.paragraphStyle: paragraphStyle
                    ], range: NSMakeRange(0, attrString!.length))
                } else {
                    // Fallback on earlier versions
                }
                
                let devider = NSMutableAttributedString(string: "\n")
                attrString?.append(devider)
                
                let normalString = NSMutableAttributedString(string: String(data[1]))
                normalString.setAttributes([
                    NSAttributedString.Key.foregroundColor: color!,
                    NSAttributedString.Key.font: NSUIFont.systemFont(ofSize: fontSize),
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ], range: NSMakeRange(0, normalString.length))
                
                attrString?.append(normalString)
                
            }
            
        }

        chart.centerAttributedText = attrString
        
        chart.centerTextOffset = CGPoint(x:0,y:-30)
    }

    func setCenterTextRadiusPercent(_ radiusPercent: NSNumber) {
        chart.centerTextRadiusPercent = CGFloat(truncating: radiusPercent) / 100.0
    }


    func setHoleRadius(_ percent: NSNumber) {
        chart.holeRadiusPercent = CGFloat(truncating: percent) / 100.0
    }


    func setHoleColor(_ color: Int) {
        chart.holeColor = RCTConvert.uiColor(color)
    }


    func setTransparentCircleRadius(_ percent: NSNumber) {
        chart.transparentCircleRadiusPercent = CGFloat(truncating: percent) / 100.0
    }

    func setTransparentCircleColor(_ color: Int) {
        chart.transparentCircleColor = RCTConvert.uiColor(color)
    }

    func setEntryLabelColor(_ color: Int) {
        chart.entryLabelColor = RCTConvert.uiColor(color)
    }

    func setEntryLabelTextSize(_ size: NSNumber) {
        chart.entryLabelFont = chart.entryLabelFont?.withSize(CGFloat(truncating: size))
    }
    
    func setDrawEntryLabels(_ enabled: Bool) {
        chart.drawEntryLabelsEnabled = enabled
    }

    func setMaxAngle(_ maxAngle: NSNumber) {
        chart.maxAngle = CGFloat(truncating: maxAngle)
    }

    func setMinOffset(_ minOffset: NSNumber) {
        chart.minOffset = CGFloat(truncating: minOffset)
    }

    func setRotationEnabled(_ enabled: Bool) {
        chart.rotationEnabled = enabled
    }

    func setRotationAngle(_ angle: NSNumber) {
        chart.rotationAngle = CGFloat(truncating: angle)
    }

    override func didSetProps(_ changedProps: [String]!) {
        super.didSetProps(changedProps)
        
        let pieChartDataSet = chart.data?.dataSets[0] as? PieChartDataSet

        pieChartDataSet?.entryLabelColor = chart.entryLabelColor
        pieChartDataSet?.entryLabelFont = chart.entryLabelFont
    }
}
