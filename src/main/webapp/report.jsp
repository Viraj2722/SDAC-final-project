<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generated Report</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/apexcharts/3.42.0/apexcharts.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <style>
        /* Reuse styles from Admin Dashboard */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: #f0f2f5;
            color: #1a1a1a;
        }

        .layout-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styles */
        .sidebar {
            width: 280px;
            background-color: white;
            box-shadow: 2px 0 4px rgba(0,0,0,0.1);
            padding: 2rem 0;
            position: fixed;
            height: 100vh;
            z-index: 100;
        }

        .sidebar-header {
            padding: 0 1.5rem 2rem 1.5rem;
            border-bottom: 1px solid #eee;
            margin-bottom: 1rem;
        }

        .sidebar-logo {
            color: #4834d4;
            font-size: 1.5rem;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .sidebar-btn {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            width: 100%;
            padding: 1rem 1.5rem;
            background: none;
            border: none;
            color: #666;
            text-align: left;
            font-size: 0.95rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .sidebar-btn:hover {
            background-color: #f8f9fa;
            color: #4834d4;
        }

        .sidebar-btn.active {
            background-color: #4834d4;
            color: white;
            position: relative;
        }

        /* Main Content Area */
        .main-content {
            flex: 1;
            margin-left: 280px;
            background-color: #f0f2f5;
        }
        .report-header, .report-section { background: white; padding: 25px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); margin-left:20px; margin-right: 20px; margin-top:20px;}
        .section-title { color: #2c3e50; border-bottom: 2px solid #f0f0f0; padding-bottom: 10px; margin-bottom: 20px; }
        .download-btn, .back-btn { padding: 8px 16px; background-color: #2c3e50; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .download-btn:hover, .back-btn:hover { background-color: #34495e; }
    </style>
</head>
<body>
    <div class="layout-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <div class="sidebar-logo">
                    <i class="fas fa-shield-alt"></i>
                    Admin Panel
                </div>
            </div>
            <button class="sidebar-btn" onclick="location.href='DashboardServlet'">
                <i class="fas fa-chart-pie"></i>
                Dashboard
            </button>
            <button class="sidebar-btn" onclick="location.href='usermanagement.jsp'">
                <i class="fas fa-users"></i>
                User Management
            </button>
            <button class="sidebar-btn" onclick="location.href='feedbackmanagement.jsp'">
                <i class="fas fa-comments"></i>
                Feedback Management
            </button>
            <button class="sidebar-btn" onclick="location.href='productmanagement.jsp">
                <i class="fas fa-box-open"></i>
                Product Management
            </button>
            <button class="sidebar-btn" onclick="location.href='algomonitoring.jsp'">
                <i class="fas fa-chart-line"></i>
                Algorithm Monitoring
            </button>
            <button class="sidebar-btn active" onclick="location.href='ReportServlet'">
                <i class="fas fa-file-download"></i>
                Report Generation
            </button>
        </div>
        <!-- Main Content -->
        <div class="main-content">
        <div class="report-header">
            <div class="row">
                <div class="col-md-8">
                    <h2>Complete Analysis Report</h2>
                    <p>Generated on: <%= LocalDate.now().format(DateTimeFormatter.ofPattern("MM/dd/yyyy")) %></p>
                </div>
                <div class="col-md-4 text-end">
                    <button class="download-btn" onclick="downloadReport('pdf')">Download PDF</button>
                </div>
            </div>
        </div>

        <!-- ABC Analysis Section -->
        <div class="report-section">
            <div class="d-flex justify-content-between align-items-center">
                <h3 class="section-title">ABC Analysis</h3>
                <div>
                    <button class="download-btn" onclick="downloadChartData('abcChart', 'abc-analysis', 'pdf')">Download PDF</button>
                </div>
            </div>
            <div id="abcChart" class="chart-container"></div>
        </div>

        <!-- Sales Analysis Section -->
        <div class="report-section">
            <div class="d-flex justify-content-between align-items-center">
                <h3 class="section-title">Sales Trend Analysis</h3>
                <div>
                    <button class="download-btn" onclick="downloadChartData('salesChart', 'sales-analysis', 'pdf')">Download PDF</button>
                  
                </div>
            </div>
            <div id="salesChart" class="chart-container"></div>
        </div>

        <!-- Demand Analysis Section -->
        <div class="report-section">
            <div class="d-flex justify-content-between align-items-center">
                <h3 class="section-title">Demand Forecast Analysis</h3>
                <div>
                    <button class="download-btn" onclick="downloadChartData('demandForecastChart', 'demand-analysis', 'pdf')">Download PDF</button>
                  
                </div>
            </div>
            <div id="demandForecastChart" class="chart-container"></div>
        </div>

        <!-- Inventory Analysis Section -->
        <div class="report-section">
            <div class="d-flex justify-content-between align-items-center">
                <h3 class="section-title">Inventory Turnover Analysis</h3>
                <div>
                    <button class="download-btn" onclick="downloadChartData('inventoryChart', 'inventory-analysis', 'pdf')">Download PDF</button>
                 
                </div>
            </div>
            <div id="inventoryChart" class="chart-container"></div>
        </div>

        <!-- Profitability Analysis Section -->
        <div class="report-section">
            <div class="d-flex justify-content-between align-items-center">
                <h3 class="section-title">Product Profitability Analysis</h3>
                <div>
                    <button class="download-btn" onclick="downloadChartData('profitabilityChart', 'profit-analysis', 'pdf')">Download PDF</button>
                </div>
            </div>
            <div id="profitabilityChart" class="chart-container"></div>
        </div>
    </div>
    </div>

    <script>
        // Chart creation functions
       function createChart(rawSalesData) {
        try {
            let salesData = rawSalesData;
            console.log('Initial salesData:', salesData);

            // Ensure salesData is parsed if it's a string
            if (typeof salesData === 'string') {
                try {
                    salesData = JSON.parse(salesData);
                    console.log('Parsed salesData:', salesData);
                } catch (e) {
                    console.error("Error parsing sales data:", e);
                    document.getElementById('errorMessage').innerHTML = 'Error parsing data: ' + e.message;
                    return;
                }
            }

            // If no data, show an error
            if (!salesData || salesData.length === 0) {
                document.getElementById('errorMessage').innerHTML = 'No sales data available';
                return;
            }

            // Define month order for sorting
            const monthOrder = {
                'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
                'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
            };

            // Sort the salesData array by month
            salesData.sort((a, b) => monthOrder[a.Month] - monthOrder[b.Month]);

            // Transform the sorted sales data into series
            const series = [
                {
                    name: 'Current Month Sales',
                    type: 'column',
                    data: salesData.map(item => ({
                        x: item.Month,
                        y: item.CurrentMonthSales
                    }))
                },
                {
                    name: 'Previous Month Sales',
                    type: 'column',
                    data: salesData.map(item => ({
                        x: item.Month,
                        y: item.PreviousMonthSales
                    }))
                },
                {
                    name: 'Growth Rate (%)',
                    type: 'line',
                    data: salesData.map(item => ({
                        x: item.Month,
                        y: item.GrowthRate
                    }))
                }
            ];

            console.log('Transformed series data:', series);

            // Chart options for ApexCharts
            const options = {
                series: series,
                chart: {
                    height: 500,
                    type: 'line',
                    zoom: { enabled: true },
                    toolbar: {
                        show: true
                    }
                },
                stroke: {
                    width: [0, 0, 3],
                    curve: 'smooth'
                },
                colors: ['#008FFB', '#00E396', '#FEB019'],
                xaxis: {
                    title: { text: 'Months' },
                    categories: salesData.map(item => item.Month),
                    tickPlacement: 'on'
                },
                yaxis: [
                    {
                        title: { text: 'Sales Amount' },
                        labels: {
                            formatter: function(val) {
                                return '$' + val.toFixed(2);
                            }
                        }
                    },
                    {
                        opposite: true,
                        title: { text: 'Growth Rate (%)' },
                        labels: {
                            formatter: function(val) {
                                return val.toFixed(1) + '%';
                            }
                        }
                    }
                ],
                plotOptions: {
                    bar: {
                        columnWidth: '50%',
                        borderRadius: 5
                    }
                },
                dataLabels: {
                    enabled: false
                },
                fill: {
                    opacity: [0.85, 0.85, 1],
                },
                legend: {
                    position: 'top'
                },
                tooltip: {
                    shared: true,
                    intersect: false,
                    y: [
                        {
                            formatter: function(y) {
                                return '$' + y.toFixed(2);
                            }
                        },
                        {
                            formatter: function(y) {
                                return '$' + y.toFixed(2);
                            }
                        },
                        {
                            formatter: function(y) {
                                return y.toFixed(1) + '%';
                            }
                        }
                    ]
                }
            };

            // Create and render the chart
            const chart = new ApexCharts(document.querySelector("#salesChart"), options);
            chart.render();

        } catch (error) {
            console.error("Error in createChart:", error);
            document.getElementById('errorMessage').innerHTML = 'Error creating chart: ' + error.message;
        }
    }
        function createABCChart(rawAbcData) {
            try {
                let abcData = rawAbcData;
                console.log('Initial ABC data:', abcData);
                
                if (typeof abcData === 'string') {
                    try {
                        abcData = JSON.parse(abcData);
                        console.log('Parsed ABC data:', abcData);
                    } catch (e) {
                        console.error("Error parsing ABC data:", e);
                        document.getElementById('abcErrorMessage').innerHTML = 'Error parsing ABC data: ' + e.message;
                        return;
                    }
                }

                if (!abcData || abcData.length === 0) {
                    document.getElementById('abcErrorMessage').innerHTML = 'No ABC classification data available';
                    return;
                }

                // Calculate totals for each classification
                const classifications = abcData.reduce((acc, item) => {
                    if (!acc[item.classification]) {
                        acc[item.classification] = 0;
                    }
                    acc[item.classification] += item.revenue_contribution;
                    return acc;
                }, {});

                // Transform data for the pie chart
                const series = Object.values(classifications);
                const labels = Object.keys(classifications);

                const options = {
                    series: series,
                    chart: {
                        height: 400,
                        type: 'pie'
                    },
                    labels: labels,
                    title: {
                        text: 'Revenue Contribution by ABC Classification',
                        align: 'center'
                    },
                    legend: {
                        position: 'bottom'
                    },
                    tooltip: {
                        y: {
                            formatter: function(value) {
                                return value.toFixed(2) + '%';
                            }
                        }
                    },
                    colors: ['#FF4560', '#00E396', '#FEB019']  // Red for A, Green for B, Yellow for C
                };

                const chart = new ApexCharts(document.querySelector("#abcChart"), options);
                chart.render();
                chartInstances.abcChart = chart;

            } catch (error) {
                console.error("Error in createABCChart:", error);
                document.getElementById('abcErrorMessage').innerHTML = 'Error creating ABC chart: ' + error.message;
            }
        }
        
        function createITRChart(rawInventoryData) {
            try {
                let inventoryData = rawInventoryData;
                console.log('Initial inventoryData:', inventoryData);
                
                // Ensure inventoryData is parsed if it's a string
                if (typeof inventoryData === 'string') {
                    try {
                        inventoryData = JSON.parse(inventoryData);
                        console.log('Parsed inventoryData:', inventoryData);
                    } catch (e) {
                        console.error("Error parsing inventory data:", e);
                        document.getElementById('errorMessage').innerHTML = 'Error parsing data: ' + e.message;
                        return;
                    }
                }

                // If no data, show an error
                if (!inventoryData || inventoryData.length === 0) {
                    document.getElementById('errorMessage').innerHTML = 'No inventory data available';
                    return;
                }

                // Transform the inventory data into a format suitable for the chart
                const series = [
                    {
                        name: 'Turnover Ratio',
                        data: inventoryData.map(item => ({
                            x: item.Name,
                            y: item.InventoryTurnoverRatio
                        }))
                    },
                    {
                        name: 'Days Outstanding',
                        data: inventoryData.map(item => ({
                            x: item.Name,
                            y: item.DaysInventoryOutstanding
                        }))
                    },
                    {
                        name: 'Units Sold',
                        data: inventoryData.map(item => ({
                            x: item.Name,
                            y: item.UnitsSold
                        }))
                    }
                ];

                console.log('Transformed series data:', series);

                // Chart options for ApexCharts
                const options = {
                    series: series,
                    chart: {
                        height: 500,
                        type: 'line',
                        zoom: { enabled: true }
                    },
                    stroke: {
                        width: [3, 3, 2],
                        curve: 'smooth',
                        dashArray: [0, 0, 5]
                    },
                    colors: ['#008FFB', '#00E396', '#FEB019'],
                    xaxis: {
                        title: { text: 'Products' },
                        categories: inventoryData.map(item => item.Name),
                        labels: {
                            rotate: -45,
                            trim: true
                        }
                    },
                    yaxis: [
                        {
                            title: { text: 'Turnover Ratio / Days' },
                            labels: {
                                formatter: function(val) {
                                    return val.toFixed(1);
                                }
                            }
                        },
                        {
                            opposite: true,
                            title: { text: 'Units Sold' }
                        }
                    ],
                    legend: {
                        position: 'top'
                    },
                    tooltip: {
                        shared: true,
                        intersect: false,
                        y: [{
                            formatter: function(value) {
                                return value.toFixed(2) + ' times';
                            }
                        }, {
                            formatter: function(value) {
                                return value.toFixed(0) + ' days';
                            }
                        }, {
                            formatter: function(value) {
                                return value + ' units';
                            }
                        }]
                    }
                };

                // Create and render the chart
                const chart = new ApexCharts(document.querySelector("#inventoryChart"), options);
                chart.render();
                chartInstances.inventoryChart = chart;

            } catch (error) {
                console.error("Error in createChart:", error);
                document.getElementById('errorMessage').innerHTML = 'Error creating chart: ' + error.message;
            }
        }
        
        function createDemandForecastChart(rawDemandData) {
            try {
                let demandData = rawDemandData;
                if (typeof demandData === 'string') {
                    demandData = JSON.parse(demandData);
                }

                if (!demandData || demandData.length === 0) {
                    document.getElementById('errorMessage').innerHTML = 'No demand forecast data available';
                    return;
                }

                const series = [
                    {
                        name: 'Forecast Monthly Demand',
                        data: demandData.map(item => ({
                            x: 'Product ' + item.product_id,
                            y: item.forecast_monthly_demand
                        }))
                    },
                    {
                        name: 'Current Stock',
                        data: demandData.map(item => ({
                            x: 'Product ' + item.product_id,
                            y: item.current_stock
                        }))
                    },
                    {
                        name: 'Suggested Order',
                        data: demandData.map(item => ({
                            x: 'Product ' + item.product_id,
                            y: item.suggested_order
                        }))
                    }
                ];

                const options = {
                    series: series,
                    chart: {
                        height: 500,
                        type: 'bar',
                        stacked: false,
                        toolbar: {
                            show: true,
                            tools: {
                                download: true,
                                selection: false,
                                zoom: true,
                                zoomin: true,
                                zoomout: true,
                                pan: true
                            }
                        }
                    },
                    plotOptions: {
                        bar: {
                            horizontal: false,
                            columnWidth: '80%',
                            borderRadius: 4,
                            dataLabels: {
                                position: 'top'
                            }
                        }
                    },
                    dataLabels: {
                        enabled: false,
                        formatter: function(val) {
                            return Math.round(val);
                        },
                        offsetY: -20,
                        style: {
                            fontSize: '12px',
                            colors: ['#304758']
                        }
                    },
                    colors: ['#008FFB', '#00E396', '#FEB019'],
                    xaxis: {
                        title: { 
                            text: 'Products',
                            style: {
                                fontSize: '14px'
                            }
                        },
                        categories: demandData.map(item => 'Product ' + item.product_id),
                        labels: {
                            rotate: -45,
                            trim: true,
                            style: {
                                fontSize: '12px'
                            }
                        },
                        tickPlacement: 'on'
                    },
                    yaxis: {
                        title: { 
                            text: 'Units',
                            style: {
                                fontSize: '14px'
                            }
                        },
                        labels: {
                            formatter: function(val) {
                                return Math.round(val);
                            }
                        }
                    },
                    legend: {
                        position: 'top',
                        horizontalAlign: 'center',
                        offsetY: 0,
                        fontSize: '14px'
                    },
                    tooltip: {
                        shared: true,
                        intersect: false,
                        y: {
                            formatter: function(value) {
                                return Math.round(value) + ' units';
                            }
                        },
                        custom: function({ series, seriesIndex, dataPointIndex, w }) {
                            const product = demandData[dataPointIndex];
                            return '<div class="custom-tooltip">' +
                                '<p><b>Product ' + product.product_id + '</b></p>' +
                                '<p>Status: ' + product.stock_status.replace(/_/g, ' ').toUpperCase() + '</p>' +
                                '<p>Trend: ' + product.trend.toUpperCase() + '</p>' +
                                '<p>Action: ' + product.action.replace(/_/g, ' ').toUpperCase() + '</p>' +
                                '</div>';
                        }
                    },
                    grid: {
                        borderColor: '#e7e7e7',
                        row: {
                            colors: ['#f3f3f3', 'transparent'],
                            opacity: 0.5
                        }
                    }
                };

                const chart = new ApexCharts(document.querySelector("#demandForecastChart"), options);
                chart.render();
                chartInstances.demandForecastChart = chart;

            } catch (error) {
                console.error("Error in createDemandForecastChart:", error);
                document.getElementById('errorMessage').innerHTML = 'Error creating demand forecast chart: ' + error.message;
            }
        }
        
        function createProfitabilityChart(rawProfitData) {
            try {
                let profitData = rawProfitData;
                
                if (typeof profitData === 'string') {
                    profitData = JSON.parse(profitData);
                }

                if (!profitData || profitData.length === 0) {
                    document.getElementById('profitErrorMessage').innerHTML = 'No profitability data available';
                    return;
                }

                // Transform data for visualization
                const series = [
                    {
                        name: 'Profit',
                        type: 'column',
                        data: profitData.map(item => ({
                            x: 'Product ' + item.ProductID,
                            y: item.Profit
                        }))
                    },
                    {
                        name: 'Profit Margin (%)',
                        type: 'line',
                        data: profitData.map(item => ({
                            x: 'Product ' + item.ProductID,
                            y: item.ProfitMargin
                        }))
                    }
                ];

                const options = {
                    series: series,
                    chart: {
                        height: 500,
                        type: 'line',
                        stacked: false,
                        toolbar: {
                            show: true
                        }
                    },
                    stroke: {
                        width: [0, 3],
                        curve: 'smooth'
                    },
                    plotOptions: {
                        bar: {
                            columnWidth: '50%'
                        }
                    },
                    colors: ['#00E396', '#FEB019'],
                    fill: {
                        opacity: [0.85, 1],
                        gradient: {
                            inverseColors: false,
                            shade: 'light',
                            type: "vertical",
                            opacityFrom: 0.85,
                            opacityTo: 0.55,
                            stops: [0, 100, 100]
                        }
                    },
                    markers: {
                        size: 0
                    },
                    xaxis: {
                        title: {
                            text: 'Products'
                        },
                        labels: {
                            rotate: -45,
                            trim: true
                        }
                    },
                    yaxis: [
                        {
                            title: {
                                text: 'Profit ($)',
                            },
                            labels: {
                                formatter: function(val) {
                                    return '$' + val.toFixed(2);
                                }
                            }
                        },
                        {
                            opposite: true,
                            title: {
                                text: 'Profit Margin (%)'
                            },
                            labels: {
                                formatter: function(val) {
                                    return val.toFixed(1) + '%';
                                }
                            }
                        }
                    ],
                    tooltip: {
                        shared: true,
                        intersect: false,
                        y: {
                            formatter: function(val, { seriesIndex }) {
                                if (seriesIndex === 1) {
                                    return `${val.toFixed(1)}%`; // For Profit Margin
                                }
                                return `$${val.toFixed(2)}`; // For Profit
                            },
                            title: {
                                formatter: function(seriesName) {
                                    return seriesName;
                                }
                            }
                        }
                    },
                    title: {
                        text: 'Product Profitability Analysis',
                        align: 'center'
                    }
                };

                const chart = new ApexCharts(document.querySelector("#profitabilityChart"), options);
                chart.render();
                chartInstances.profitabilityChart = chart;

            } catch (error) {
                console.error("Error in createProfitabilityChart:", error);
                document.getElementById('profitErrorMessage').innerHTML = 'Error creating profitability chart: ' + error.message;
            }
        }
     // Global object to store chart instances
        const chartInstances = {};

        // Download chart data as PDF or Excel
        async function downloadChartData(chartId, filename, format) {
            const chart = chartInstances[chartId];
            if (!chart) {
                console.error(`Chart with ID ${chartId} not found.`);
                return;
            }

            if (format === 'pdf') {
                try {
                    const { imgURI } = await chart.dataURI();
                    const { jsPDF } = window.jspdf;
                    const doc = new jsPDF();
                    const chartWidth = chart.w.globals.svgWidth;
                    const chartHeight = chart.w.globals.svgHeight;
                    
                    // Calculate the aspect ratio
                    const aspectRatio = chartHeight / chartWidth;
                    
                    // Set PDF page dimensions (assuming A4 in points: 595.28 x 841.89)
                    const pageWidth = doc.internal.pageSize.getWidth();
                    const maxWidth = pageWidth - 30; // 15pt margin on each side
                    
                    // Calculate height while maintaining aspect ratio
                    const width = maxWidth;
                    const height = width * aspectRatio;
                    
                    // Add image with calculated dimensions
                    doc.addImage(imgURI, 'PNG', 15, 15, width, height);
                    doc.save(`${filename}.pdf`);
                } catch (error) {
                    console.error("Error generating PDF:", error);
                }
            } else if (format === 'excel') {
                // Generate Excel with chart data
                const series = chart.w.config.series || [];
                const rows = [['Series', 'Category', 'Value']]; // Header row

                series.forEach(s => {
                    (s.data || []).forEach(point => {
                        rows.push([s.name, point.x, point.y]);
                    });
                });

                if (rows.length > 1) { // Ensure there's data to export
                    const wb = XLSX.utils.book_new();
                    const ws = XLSX.utils.aoa_to_sheet(rows);
                    XLSX.utils.book_append_sheet(wb, ws, 'Chart Data');
                    XLSX.writeFile(wb, `${filename}.xlsx`);
                } else {
                    console.warn("No data available for export.");
                }
            }
        }

        async function downloadReport(format) {
            const chartIds = [
                'abcChart',
                'salesChart',
                'demandForecastChart',
                'inventoryChart',
                'profitabilityChart'
            ];

            if (format === 'pdf') {
                const { jsPDF } = window.jspdf;
                const doc = new jsPDF();
                let yOffset = 10;

                try {
                    for (let i = 0; i < chartIds.length; i++) {
                        const chart = chartInstances[chartIds[i]];
                        if (chart) {
                            const { imgURI } = await chart.dataURI();
                            if (i > 0) {
                                doc.addPage();
                                yOffset = 10;
                            }
                            doc.addImage(imgURI, 'PNG', 15, yOffset, 180, 100);
                            yOffset += 110;
                        }
                    }
                    doc.save('complete_analysis_report.pdf');
                } catch (error) {
                    console.error("Error generating PDF report:", error);
                }
            } else if (format === 'excel') {
                const wb = XLSX.utils.book_new();

                chartIds.forEach(chartId => {
                    const chart = chartInstances[chartId];
                    if (!chart) {
                        console.warn(`Chart with ID ${chartId} not found.`);
                        return;
                    }

                    const series = chart.w.config.series || [];
                    const rows = [['Series', 'Category', 'Value']];

                    series.forEach(s => {
                        (s.data || []).forEach(point => {
                            rows.push([s.name, point.x, point.y]);
                        });
                    });

                    if (rows.length > 1) { // Only add sheets with valid data
                        const ws = XLSX.utils.aoa_to_sheet(rows);
                        XLSX.utils.book_append_sheet(wb, ws, chartId);
                    }
                });

                XLSX.writeFile(wb, 'complete_analysis_report.xlsx');
            }
        }

        

        // Initialize charts
        document.addEventListener('DOMContentLoaded', function() {
            try {
                const rawSalesData = <%= request.getAttribute("salesData") %>;
                const rawAbcData = <%= request.getAttribute("abcData") %>;
                const rawInventoryData = <%= request.getAttribute("inventoryData") %>;
                const rawDemandData = <%= request.getAttribute("demandData") %>;
                const rawProfitData = <%= request.getAttribute("profitData") %>;
                
                console.log('Raw sales data from server:', rawSalesData);
                console.log('Raw ABC data from server:', rawAbcData);
                console.log('Raw inventory data from server:', rawInventoryData);
                console.log('Raw demand data from server:', rawDemandData);
                console.log('Raw profit data from server:', rawProfitData);
                
                createChart(rawSalesData);
                createABCChart(rawAbcData);
                createITRChart(rawInventoryData);
                createDemandForecastChart(rawDemandData);
                createProfitabilityChart(rawProfitData);
            } catch (error) {
                console.error("Error initializing charts:", error);
                document.getElementById('errorMessage').innerHTML = 'Error initializing charts: ' + error.message;
            }
        });
    </script>
</body>
</html>
