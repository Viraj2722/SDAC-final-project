<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Algorithm Monitoring Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/apexcharts/3.42.0/apexcharts.min.js"></script>
    <style>
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
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 280px;
            background-color: #f0f2f5;
        }

        /* Header */
        .main-header {
            background-color: white;
            padding: 1.5rem 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            font-size: 1.5rem;
            color: #1a1a1a;
            font-weight: 600;
        }

        .admin-badge {
            background: #4834d4;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Algorithm Cards */
        .algorithm-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            padding: 2rem;
        }

        .algorithm-container {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .algorithm-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        .algo-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .algo-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
        }

        .run-btn {
            background: #4834d4;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .run-btn:hover {
            background: #3721b5;
        }

        .loading {
            display: none;
            color: #666;
            margin: 10px 0;
        }

        .spinner {
            animation: spin 1s linear infinite;
            margin-right: 8px;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .result-container {
            display: none;
            margin-top: 20px;
            background: #f8f9fa;
            border-radius: 5px;
            padding: 15px;
            overflow-x: auto;
        }

        .json-view {
            display: none;
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 5px;
            padding: 15px;
            margin-top: 15px;
            white-space: pre-wrap;
            word-wrap: break-word;
            font-family: monospace;
            font-size: 14px;
            max-height: 300px;
            overflow-y: auto;
        }

        .toggle-btn {
            background: #4834d4;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
            transition: background-color 0.3s ease;
        }

        .toggle-btn:hover {
            background: #3721b5;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .algorithm-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 0;
                transform: translateX(-100%);
            }

            .main-content {
                margin-left: 0;
            }
        }
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
            <button class="sidebar-btn" onclick="location.href='adminPanel.jsp'">
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
            <button class="sidebar-btn active" onclick="location.href='algomonitoring.jsp'">
                <i class="fas fa-chart-line"></i>
                Algorithm Monitoring
            </button>
            <button class="sidebar-btn" onclick="location.href='ReportServlet'">
                <i class="fas fa-file-download"></i>
                Report Generation
            </button>
            
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Main Header -->
            <div class="main-header">
                <h1 class="page-title">Algorithm Monitoring Dashboard</h1>
                <div class="admin-badge">
                    <i class="fas fa-user-shield"></i>
                    Admin Portal
                </div>
            </div>

            <!-- Algorithm Grid -->
            <div class="algorithm-grid">
                <!-- ABC Analysis -->
                <div class="algorithm-container">
                    <div class="algo-header">
                        <h2 class="algo-title">ABC Analysis</h2>
                        <button class="run-btn" onclick="runAlgorithm('ABC Classification', 'abc')">
                            <i class="fas fa-play"></i>
                            Run Algorithm
                        </button>
                    </div>
                    <div id="abc-loading" class="loading">
                        <i class="fas fa-circle-notch spinner"></i>
                        Processing algorithm...
                    </div>
                    <div id="abc-result" class="result-container"></div>
                    <div id="abc-json" class="json-view"></div>
                    <button class="toggle-btn" onclick="toggleView('abc')">Toggle JSON View</button>
                </div>

                <!-- Sales Trend -->
                <div class="algorithm-container">
                    <div class="algo-header">
                        <h2 class="algo-title">Sales Trend Analysis</h2>
                        <button class="run-btn" onclick="runAlgorithm('Sales Trend Analysis', 'sales')">
                            <i class="fas fa-play"></i>
                            Run Algorithm
                        </button>
                    </div>
                    <div id="sales-loading" class="loading">
                        <i class="fas fa-circle-notch spinner"></i>
                        Processing algorithm...
                    </div>
                    <div id="sales-result" class="result-container"></div>
                    <div id="sales-json" class="json-view"></div>
                    <button class="toggle-btn" onclick="toggleView('sales')">Toggle JSON View</button>
                </div>

                <!-- Inventory Turnover -->
                <div class="algorithm-container">
                    <div class="algo-header">
                        <h2 class="algo-title">Inventory Turnover Analysis</h2>
                        <button class="run-btn" onclick="runAlgorithm('Inventory Turnover Analysis', 'inventory')">
                            <i class="fas fa-play"></i>
                            Run Algorithm
                        </button>
                    </div>
                    <div id="inventory-loading" class="loading">
                        <i class="fas fa-circle-notch spinner"></i>
                        Processing algorithm...
                    </div>
                    <div id="inventory-result" class="result-container"></div>
                    <div id="inventory-json" class="json-view"></div>
                    <button class="toggle-btn" onclick="toggleView('inventory')">Toggle JSON View</button>
                </div>

                <!-- Demand Forecast -->
                <div class="algorithm-container">
                    <div class="algo-header">
                        <h2 class="algo-title">Demand Forecast Analysis</h2>
                        <button class="run-btn" onclick="runAlgorithm('Demand Forecast Analysis', 'demand')">
                            <i class="fas fa-play"></i>
                            Run Algorithm
                        </button>
                    </div>
                    <div id="demand-loading" class="loading">
                        <i class="fas fa-circle-notch spinner"></i>
                        Processing algorithm...
                    </div>
                    <div id="demand-result" class="result-container"></div>
                    <div id="demand-json" class="json-view"></div>
                    <button class="toggle-btn" onclick="toggleView('demand')">Toggle JSON View</button>
                </div>

                <!-- Product Profitability -->
                <div class="algorithm-container">
                    <div class="algo-header">
                        <h2 class="algo-title">Product Profitability Analysis</h2>
                        <button class="run-btn" onclick="runAlgorithm('Product Profitability Analysis', 'profit')">
                            <i class="fas fa-play"></i>
                            Run Algorithm
                        </button>
                    </div>
                    <div id="profit-loading" class="loading">
                        <i class="fas fa-circle-notch spinner"></i>
                        Processing algorithm...
                    </div>
                    <div id="profit-result" class="result-container"></div>
                    <div id="profit-json" class="json-view"></div>
                    <button class="toggle-btn" onclick="toggleView('profit')">Toggle JSON View</button>
                </div>
            </div>
        </div>
    </div>

    <script>
    function runAlgorithm(algoName, containerId) {
        var loadingEl = document.getElementById(containerId + '-loading');
        var resultEl = document.getElementById(containerId + '-result');
        var jsonEl = document.getElementById(containerId + '-json');
        
        loadingEl.style.display = 'block';
        resultEl.style.display = 'none';
        jsonEl.style.display = 'none';

        fetch('AlgoMonitorServlet?algo=' + encodeURIComponent(algoName))
            .then(function(response) { return response.json(); })
            .then(function(data) {
                loadingEl.style.display = 'none';
                resultEl.style.display = 'block';
                displayResults(data, resultEl, containerId);
                jsonEl.textContent = JSON.stringify(data, null, 2);
            })
            .catch(function(error) {
                loadingEl.style.display = 'none';
                resultEl.style.display = 'block';
                resultEl.innerHTML = '<div style="color: red;">Error: ' + error.message + '</div>';
            });
    }

    function displayResults(data, container, containerId) {
        var options;
        switch(containerId) {
            case 'abc':
                options = createABCChartOptions(data);
                break;
            case 'sales':
                options = createSalesChartOptions(data);
                break;
            case 'inventory':
                options = createInventoryChartOptions(data);
                break;
            case 'demand':
                options = createDemandChartOptions(data);
                break;
            case 'profit':
                options = createProfitChartOptions(data);
                break;
            default:
                container.innerHTML = '<p>Unsupported chart type</p>';
                return;
        }
        
        if (options) {
            var chart = new ApexCharts(container, options);
            chart.render();
        } else {
            container.innerHTML = '<p>Unable to create chart options</p>';
        }
    }


        function createABCChartOptions(data) {
            var categories = ['A', 'B', 'C'];
            var seriesData = categories.map(function(category) {
                return data.filter(function(item) { return item.classification === category; })
                    .reduce(function(sum, item) { return sum + item.revenue_contribution; }, 0);
            });

            return {
                series: seriesData,
                chart: {
                    type: 'pie',
                    height: 350
                },
                labels: categories,
                title: {
                    text: 'ABC Classification',
                    align: 'center'
                },
                legend: {
                    position: 'bottom'
                }
            };
        }

        function createSalesChartOptions(data) {
            if (!Array.isArray(data) || data.length === 0) {
                console.error('Invalid or empty sales data');
                return null;
            }

            var series = [
                {
                    name: 'Current Month Sales',
                    data: data.map(function(item) { return item.CurrentMonthSales; })
                },
                {
                    name: 'Previous Month Sales',
                    data: data.map(function(item) { return item.PreviousMonthSales; })
                },
                {
                    name: 'Growth Rate (%)',
                    data: data.map(function(item) { return item.GrowthRate; })
                }
            ];

            return {
                series: series,
                chart: {
                    height: 350,
                    type: 'line',
                    zoom: { enabled: false }
                },
                stroke: {
                    width: [3, 3, 2],
                    curve: 'straight',
                    dashArray: [0, 0, 5]
                },
                colors: ['#008FFB', '#00E396', '#FEB019'],
                xaxis: {
                    categories: data.map(function(item) { return 'Product ' + item.ProductID; })
                },
                yaxis: [
                    { title: { text: 'Sales Amount' } },
                    { opposite: true, title: { text: 'Growth Rate (%)' } }
                ],
                tooltip: { shared: true, intersect: false },
                legend: { position: 'top' }
            };
        }

        function createInventoryChartOptions(data) {
            if (!Array.isArray(data) || data.length === 0) {
                console.error('Invalid or empty inventory data');
                return null;
            }

            return {
                series: [{
                    name: 'Inventory Turnover',
                    data: data.map(function(item) { return item.InventoryTurnoverRatio; })
                }],
                chart: {
                    type: 'bar',
                    height: 350
                },
                xaxis: {
                    categories: data.map(function(item) { return item.Name; })
                },
                title: {
                    text: 'Inventory Turnover Analysis',
                    align: 'center'
                }
            };
        }

        function createDemandChartOptions(data) {
            if (!Array.isArray(data) || data.length === 0) {
                console.error('Invalid or empty demand data');
                return null;
            }

            return {
                series: [{
                    name: 'Forecasted Demand',
                    data: data.map(function(item) { return item.forecast_monthly_demand; })
                }],
                chart: {
                    type: 'line',
                    height: 350
                },
                xaxis: {
                    categories: data.map(function(item) { return 'Product ' + item.product_id; })
                },
                title: {
                    text: 'Demand Forecast Analysis',
                    align: 'center'
                }
            };
        }

        function createProfitChartOptions(data) {
            if (!Array.isArray(data) || data.length === 0) {
                console.error('Invalid or empty profit data');
                return null;
            }

            return {
                series: [{
                    name: 'Profit',
                    data: data.map(function(item) { return item.Profit; })
                }],
                chart: {
                    type: 'bar',
                    height: 350
                },
                xaxis: {
                    categories: data.map(function(item) { return 'Product ' + item.ProductID; })
                },
                title: {
                    text: 'Product Profitability Analysis',
                    align: 'center'
                }
            };
        }
        function toggleView(containerId) {
            var chartElement = document.getElementById(containerId + '-result');
            var jsonElement = document.getElementById(containerId + '-json');
            
            if (chartElement.style.display === 'none') {
                chartElement.style.display = 'block';
                jsonElement.style.display = 'none';
            } else {
                chartElement.style.display = 'none';
                jsonElement.style.display = 'block';
            }
        }
    </script>
</body>
</html>
