<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Demand Forecast Analysis</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.min.js"></script>
    <style>
        .chart-container {
            width: 90%;
            height: 500px;
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
        }
        .header {
            text-align: center;
            padding: 20px;
            background: #f5f5f5;
        }
        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
        }
        th, td {
            padding: 8px;
            border: 1px solid #ddd;
            text-align: left;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Demand Forecast Analysis</h1>
    </div>
    
    <div class="chart-container">
        <canvas id="forecastChart"></canvas>
    </div>
    
    <div id="tableContainer"></div>

    <script>
        var forecastData = ${forecastDataJson != null ? forecastDataJson : '[]'};
        
        if (forecastData && forecastData.length > 0) {
            // Create table
            var tableHtml = '<table><thead><tr>' +
                '<th>Product ID</th>' +
                '<th>Forecast Demand</th>' +
                '<th>Current Stock</th>' +
                '<th>Reorder Level</th>' +
                '<th>Stock Status</th>' +
                '<th>Action</th>' +
                '<th>Suggested Order</th>' +
                '<th>Trend</th>' +
                '<th>Selling Price</th>' +
                '</tr></thead><tbody>';
                
            forecastData.forEach(function(item) {
                tableHtml += '<tr>' +
                    '<td>' + (item.product_id || 'N/A') + '</td>' +
                    '<td>' + (item.forecast_monthly_demand || 0) + '</td>' +
                    '<td>' + (item.current_stock || 0) + '</td>' +
                    '<td>' + (item.reorder_level || 0) + '</td>' +
                    '<td>' + (item.stock_status || 'N/A') + '</td>' +
                    '<td>' + (item.action || 'N/A') + '</td>' +
                    '<td>' + (item.suggested_order || 0) + '</td>' +
                    '<td>' + (item.trend || 'N/A') + '</td>' +
                    '<td>$' + (item.selling_price ? item.selling_price.toFixed(2) : '0.00') + '</td>' +
                    '</tr>';
            });
            
            tableHtml += '</tbody></table>';
            document.getElementById('tableContainer').innerHTML = tableHtml;
            
            // Create chart
            var ctx = document.getElementById('forecastChart').getContext('2d');
            var myChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: forecastData.map(item => 'Product ' + item.product_id),
                    datasets: [{
                        label: 'Forecast Demand',
                        data: forecastData.map(item => item.forecast_monthly_demand),
                        backgroundColor: 'rgba(54, 162, 235, 0.5)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1
                    }, {
                        label: 'Current Stock',
                        data: forecastData.map(item => item.current_stock),
                        backgroundColor: 'rgba(75, 192, 192, 0.5)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 1
                    }, {
                        label: 'Reorder Level',
                        data: forecastData.map(item => item.reorder_level),
                        type: 'line',
                        fill: false,
                        borderColor: 'rgba(255, 99, 132, 1)',
                        borderWidth: 2,
                        pointBackgroundColor: 'rgba(255, 99, 132, 1)'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    title: {
                        display: true,
                        text: 'Product Demand Forecast Analysis',
                        fontSize: 16
                    },
                    legend: {
                        position: 'top'
                    },
                    scales: {
                        yAxes: [{
                            ticks: {
                                beginAtZero: true
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'Quantity'
                            }
                        }],
                        xAxes: [{
                            scaleLabel: {
                                display: true,
                                labelString: 'Products'
                            }
                        }]
                    }
                }
            });
        } else {
            document.getElementById('tableContainer').innerHTML = 
                '<p>No forecast data available.</p>';
        }
    </script>
</body>
</html>