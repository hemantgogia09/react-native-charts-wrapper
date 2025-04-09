//  Created by xudong wu on 24/02/2017.
//  Copyright wuxudong
//

import Charts
import SwiftyJSON

class RNBarChartView: RNBarChartViewBase {

    let _chart: BarChartView
    let _dataExtract : BarDataExtract
    
    override var chart: BarChartView {
        return _chart
    }
    
    override var dataExtract: DataExtract {
        return _dataExtract
    }
    
    override init(frame: CoreGraphics.CGRect) {

        self._chart = BarChartView(frame: frame)
        self._dataExtract = BarDataExtract()

        super.init(frame: frame)

        self._chart.delegate = self
        _chart.rightAxis.enabled=false
        _chart.leftAxis.axisMinimum = 0.0
        _chart.leftAxis.gridColor = UIColor.init(hex: "#E5E5E5")
        _chart.leftAxis.zeroLineColor = UIColor.init(hex: "#808080")
        _chart.leftAxis.drawZeroLineEnabled = true
        
        self.addSubview(_chart)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _chart.frame = self.bounds // Adjust the chart's frame to fill the entire component's bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    public convenience init(hex: String) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1

        let hexColor = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        var valid = false

        if scanner.scanHexInt64(&hexNumber) {
            if hexColor.count == 8 {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                valid = true
            }
            else if hexColor.count == 6 {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000ff) / 255
                valid = true
            }
        }

        #if DEBUG
            assert(valid, "UIColor initialized with invalid hex string")
        #endif

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
