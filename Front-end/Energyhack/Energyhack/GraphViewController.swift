//
//  GraphViewController.swift
//  Pythia
//
//  Created by Alexey Potapov on 28/01/2017.
//  Copyright © 2017 Community. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import Charts

class GraphViewController: UIViewController, ChartViewDelegate {
    
    var graphModel: GraphModel?
    @IBOutlet weak var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.delegate = self;
        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.drawGridBackgroundEnabled = true
        chartView.pinchZoomEnabled = true
        chartView.backgroundColor = UIColor(white: 204.0/255.0, alpha: 1.0)
        
        let l = chartView.legend
        l.form =  .line
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11.0)!
        l.textColor = UIColor.white
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 11.0)!
        xAxis.labelTextColor = UIColor.white
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = UIColor(red:51/255.0, green:181/255.0, blue:229/255.0, alpha:1.0)
        leftAxis.axisMaximum = 120.0
        leftAxis.axisMinimum = 0.0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawZeroLineEnabled = false
        leftAxis.granularityEnabled = true
        
        let rightAxis = chartView.rightAxis
        rightAxis.labelTextColor = UIColor.red
        rightAxis.axisMaximum = 120.0;
        rightAxis.axisMinimum = 0.0;
        rightAxis.drawGridLinesEnabled = false
        rightAxis.granularityEnabled = false
        
        chartView.animate(xAxisDuration:2.5)
        reloadEnergyData()
    }
    
    func reloadEnergyData() {
        
        Alamofire.request("http://35.157.113.140:8080/api/grafSpotreba/1000/12").responseObject {
            [unowned self] (response: DataResponse<GraphModel>) in
            
            self.graphModel = response.result.value
            print(self.graphModel?.values ?? "niilllll")
            self.reloadGraph()
        }
    }
    
    func reloadGraph() {
        var chartDataArray: [ChartDataEntry] = []
        var inc = 0
        for element in (graphModel?.values)! {
            chartDataArray.append(ChartDataEntry(x: Double(inc), y: Double(element)))
            inc += 1
        }
        
        var lineChartDataSet: LineChartDataSet
        if let data = chartView.data {
            if data.dataSetCount > 0 {
                lineChartDataSet = chartView.data?.dataSets.first as! LineChartDataSet
                lineChartDataSet.values = chartDataArray
                chartView.data?.notifyDataChanged()
                chartView.notifyDataSetChanged()
            }
        } else {
            lineChartDataSet =  LineChartDataSet(values: chartDataArray, label: "DataSet1")
            lineChartDataSet.axisDependency = .left
            lineChartDataSet.setColor(UIColor(red:51/255.0, green:181/255.0, blue:229/255.0, alpha:1.0))
            lineChartDataSet.setCircleColor(UIColor.white)
            lineChartDataSet.lineWidth = 2.0
            lineChartDataSet.circleRadius = 3.0;
            lineChartDataSet.fillAlpha = 65/255.0;
            lineChartDataSet.fillColor = UIColor(red:51/255.0, green:181/255.0, blue:229/255.0, alpha:1.0)
            //[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
            lineChartDataSet.highlightColor = UIColor(red:51/255.0, green:181/255.0, blue:229/255.0, alpha:1.0)
            //[UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
            lineChartDataSet.drawCircleHoleEnabled = false
            
            let data = LineChartData(dataSet: lineChartDataSet)
            data.setValueTextColor(UIColor.white)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 9.0))
            
            chartView.data = data;
        }
    }
}
