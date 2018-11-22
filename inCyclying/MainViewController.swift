import Charts

class MainViewController: UIViewController{
    
    @IBOutlet weak var barChartView: LineChartView!
    
    var speedList: [Double] = []
    
    func setChart(values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Units Sold")
        chartDataSet.mode = .cubicBezier
        chartDataSet.cubicIntensity = 0.2
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.colors = [UIColor.red]
        chartDataSet.lineWidth = 2
        let chartData = LineChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
       
        let gradientColors = [UIColor.red.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0,0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
            else {
            print("gradient error.")
            return
        }
        
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90)
        chartDataSet.drawFilledEnabled = true
        
        barChartView.data = chartData
        
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.highlightPerTapEnabled = false
        barChartView.leftAxis.axisMinimum = 0
        barChartView.highlightPerDragEnabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.drawLabelsEnabled = true
        
    }
    
    override func viewDidLoad() {
        
        StorageDataSource.getDefaults(){ (locationList,distance, seconds, calories,run, speedList, maxSpeed) in
            self.speedList = speedList
        }

        setChart(values: speedList)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        StorageDataSource.getDefaults(){ (locationList,distance, seconds, calories,run, speedList,maxSpeed) in
            self.speedList = speedList
        }


        setChart(values: speedList)
    }

    
}
