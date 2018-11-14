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
        
        StorageDataSource.getDefaults(){ (locationList,distance, seconds, calories,run, speedList) in
            self.speedList = speedList
        }
        
        setChart(values: speedList)
    }

    
}
