<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dashboard</title>
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
	rel="stylesheet">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/apexcharts/3.42.0/apexcharts.min.js"></script>
<style>
:root {
	--yellow: #FFC300;
	--purple: #8E44AD;
	--pink: #E74C3C;
	--blue: #3498DB;
	--white: #FFFFFF;
	--background: #F4F6F9;
	--text-primary: #2C3E50;
	--text-secondary: #7F8C8D;
}

* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
}

body {
	background: var(--background);
}

.layout-container {
	display: flex;
	min-height: 100vh;
}

.sidebar {
	width: 280px;
	height: 100vh;
	background: var(--purple);
	color: var(--white);
	padding: 1.5rem;
	display: flex;
	flex-direction: column;
	position: fixed;
}

.sidebar-logo {
	font-size: 1.5rem;
	font-weight: bold;
	margin-bottom: 2rem;
	color: var(--yellow);
}

.sidebar-btn {
	display: flex;
	align-items: center;
	gap: 0.5rem;
	margin: 0.5rem 0;
	padding: 1rem;
	border-radius: 12px;
	color: var(--white);
	background: transparent;
	border: none;
	cursor: pointer;
	transition: all 0.3s ease;
}

.sidebar-btn:hover, .sidebar-btn.active {
	background: var(--pink);
}

.main-content {
	flex: 1;
	/* padding: 2rem; */
	overflow-y: auto;
	margin-left: 280px; /* Space for the sidebar */
    padding: 20px;
}

.main-header {
	background: var(--blue);
	padding: 1.5rem;
	border-radius: 12px;
	color: var(--white);
	margin-bottom: 2rem;
	text-align: center;
}

.abc-section {
	display: grid;
	grid-template-columns: 2fr 1fr;
	gap: 2rem;
	margin-bottom: 2rem;
}

.chart-container {
	background: var(--white);
	border-radius: 12px;
	padding: 1.5rem;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.abc-details {
	display: flex;
	flex-direction: column;
	gap: 1rem;
}

.abc-box {
	background: var(--white);
	padding: 1.5rem;
	border-radius: 12px;
	text-align: center;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.abc-box h3 {
	color: var(--text-primary);
	margin-bottom: 0.5rem;
}

.abc-table-btn {
	background: var(--blue);
	color: var(--white);
	padding: 0.75rem 1.5rem;
	border-radius: 12px;
	border: none;
	cursor: pointer;
	font-size: 1rem;
	transition: all 0.3s ease;
}

.abc-table-btn:hover {
	background: var(--purple);
}

.analysis-card {
	background: var(--white);
	border-radius: 12px;
	padding: 1.5rem;
	margin-bottom: 2rem;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.analysis-title {
	color: var(--text-primary);
	font-size: 1.25rem;
	margin-bottom: 1rem;
}

.modal {
	display: none;
	position: fixed;
	z-index: 999; /* Higher z-index for better stacking */
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	overflow: auto;
	background-color: rgba(0, 0, 0, 0.6);
	/* Darker overlay for better contrast */
	backdrop-filter: blur(4px); /* Subtle blur effect */
}

.modal-content {
	background: var(--white);
	margin: 80px auto; /* More top spacing */
	padding: 32px; /* More generous padding */
	border: none; /* Remove border */
	width: 90%;
	max-width: 800px; /* Prevent too wide on large screens */
	border-radius: 12px; /* Rounded corners */
	box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12); /* Subtle shadow */
}

.modal-content h2 {
	color: var(--purple);
	margin-bottom: 24px;
	font-size: 1.75rem;
	font-weight: 600;
}

.modal-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 24px;
}

.modal-header h2 {
	margin-bottom: 0;
	/* Override previous margin since it's now handled by modal-header */
}

.close-btn {
	background: none;
	border: none;
	font-size: 28px;
	cursor: pointer;
	padding: 0 8px;
	color: #666;
	transition: color 0.2s ease;
}

.close-btn:hover {
	color: #000;
}

#abcTable {
	width: 100%;
	border-collapse: separate;
	border-spacing: 0;
	border-radius: 8px;
	overflow: hidden; /* Keeps rounded corners intact */
	box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

#abcTable th, #abcTable td {
	border: 1px solid #edf2f7; /* Lighter border color */
	padding: 12px 16px; /* More generous padding */
	text-align: left;
}

#abcTable th {
	font-weight: 600;
}

#abcTable thead {
	background: var(--blue);
	color: var(--white);
}

#abcTable tbody tr:nth-child(even) {
	background-color: #f8fafc; /* Subtle zebra striping */
}

#abcTable tbody tr:hover {
	background-color: #f1f5f9; /* Hover effect */
	transition: background-color 0.2s ease;
}

.abc-box p {
	font-size: 24px;
	font-weight: bold;
	color: var(--purple);
	margin: 10px 0;
	line-height: 1.2;
}

.abc-box span {
	display: block;
	font-size: 14px;
	color: var(--text-secondary);
}

@media ( max-width : 1024px) {
	.abc-section {
		grid-template-columns: 1fr;
	}
}

@media ( max-width : 768px) {
	.sidebar {
		width: 0;
		position: fixed;
		left: -280px;
	}
	.main-content {
		margin-left: 0;
	}
}
</style>
</head>
<body>
	<div class="layout-container">
		<div class="sidebar">
		
			<div class="sidebar-logo">
				<i class="fas fa-shield-alt"></i> Admin Panel
			</div>
			<button class="sidebar-btn active">
				<i class="fas fa-chart-pie"></i> Dashboard
			</button>
			<button class="sidebar-btn"
				onclick="location.href='usermanagement.jsp'">
				<i class="fas fa-users"></i> User Management
			</button>
			<button class="sidebar-btn"
				onclick="location.href='feedbackmanagement.jsp'">
				<i class="fas fa-comments"></i> Feedback Management
			</button>
			<button class="sidebar-btn"
				onclick="location.href='productmanagement.jsp'">
				<i class="fas fa-box-open"></i> Product Management
			</button>
			<button class="sidebar-btn"
				onclick="location.href='algomonitoring.jsp'">
				<i class="fas fa-chart-line"></i> Algorithm Monitoring
			</button>
			<button class="sidebar-btn" onclick="location.href='ReportServlet'">
				<i class="fas fa-file-download"></i> Report Generation
			</button>
		</div>

		<div class="main-content">
			<div class="main-header">
				<h1>Analytics Dashboard</h1>
			</div>

			<!-- ABC Analysis Section -->
			<div class="abc-section">

				<div class="chart-container">
					<div id="abcChart"></div>
				</div>
				<div class="abc-details">
					<div class="abc-box">
						<h3>Category A</h3>
						<p id="categoryA">
							<br>
							<span>Products</span>
						</p>
					</div>
					<div class="abc-box">
						<h3>Category B</h3>
						<p id="categoryB">
							<br>
							<span>Products</span>
						</p>
					</div>
					<div class="abc-box">
						<h3>Category C</h3>
						<p id="categoryC">
							<br>
							<span>Products</span>
						</p>
					</div>
					<button class="abc-table-btn">View Detailed Table</button>
				</div>
			</div>
			<div id="myModal" class="modal">
				<div class="modal-content">
					<div class="modal-header">
						<h2>ABC Analysis Detailed Table</h2>
						<button id="closeModal" class="close-btn">&times;</button>
					</div>
					<table id="abcTable">
						<thead>
							<tr>
								<th>Product</th>
								<th>Value</th>
								<th>Classification</th>
							</tr>
						</thead>
						<tbody></tbody>
					</table>
				</div>
			</div>
			<!-- Other Analysis Cards -->
			<div class="analysis-card">
				<h3 class="analysis-title">Sales Trend Analysis</h3>
				<div id="salesChart"></div>
			</div>

			<div class="analysis-card">
				<h3 class="analysis-title">Demand Forecast Analysis</h3>
				<div id="demandForecastChart"></div>
			</div>

			<div class="analysis-card">
				<h3 class="analysis-title">Inventory Turnover Analysis</h3>
				<div id="inventoryChart"></div>
			</div>

			<div class="analysis-card">
				<h3 class="analysis-title">Product Profitability Analysis</h3>
				<div id="profitabilityChart"></div>
			</div>
		</div>
	</div>
	<script>
    
 
    
    let abcData = <%=request.getAttribute("abcData")%>;
    if (typeof abcData === 'string') {
        try {
            abcData = JSON.parse(abcData);
        } catch (e) {
            console.error("Error parsing abcData:", e);
            abcData = [];
        }
    }

    const openModalBtn = document.querySelector('.abc-table-btn');
    const modal = document.getElementById("myModal");
    const closeModalBtn = document.getElementById("closeModal");
    const abcTable = document.getElementById("abcTable").getElementsByTagName('tbody')[0];

    openModalBtn.onclick = function() {
        modal.style.display = "block";
        abcTable.innerHTML = ''; // Clear previous data
        abcData.forEach(row => {
            const newRow = abcTable.insertRow();
            const productCell = newRow.insertCell();
            const valueCell = newRow.insertCell();
            const classificationCell = newRow.insertCell();

            productCell.textContent = row.product_name;
            valueCell.textContent = row.annual_revenue;
            classificationCell.textContent = row.classification;
            const categoryColor = 
                row.classification === 'A' ? '#E74C3C' : 
                row.classification === 'B' ? '#F1C40F' : '#27AE60';
            classificationCell.style.backgroundColor = categoryColor;
        });
    }

    closeModalBtn.onclick = function() {
        modal.style.display = "none";
    }

    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
        
        
    }
    
    function updateCategoryCounts(data) {
        console.log('Updating counts for data length:', data.length);

        try {
            // Initialize counters
            let counts = {
                A: 0,
                B: 0,
                C: 0
            };
            
            // Count items
            data.forEach(item => {
                if (item && item.classification) {
                    counts[item.classification]++;
                    console.log(`Found item with classification: ${item.classification}`);
                }
            });

            console.log('Final counts:', {
                'Category A': counts.A,
                'Category B': counts.B,
                'Category C': counts.C
            });

            // Update DOM elements directly
            ['A', 'B', 'C'].forEach(category => {
                const element = document.getElementById(`category${category}`);
                if (element) {
                    element.innerHTML = `
                        <p>
                            ${counts[category]}<br>
                            <span>Products</span>
                        </p>
                    `;
                    console.log(`Updated category ${category} with count: ${counts[category]}`);
                } else {
                    console.error(`Element categoryA${category} not found`);
                }
            });

        } catch (error) {
            console.error('Error in updateCategoryCounts:', error);
            console.error('Stack trace:', error.stack);
        }
    }

    // Call updateCategoryCounts when DOM is loaded
    
    
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
                colors: ['#2C3E50', '#FF6F61', '#1ABC9C'],
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

            // Parse raw data if it is in string format
            if (typeof abcData === 'string') {
                try {
                    abcData = JSON.parse(abcData);
                    console.log('Parsed ABC data:', abcData);
                } catch (e) {
                    console.error("Error parsing ABC data:", e);
                    document.getElementById('abcErrorMessage').innerHTML =
                        'Error parsing ABC data: ' + e.message;
                    return;
                }
            }

            // Check for empty or invalid data
            if (!abcData || abcData.length === 0) {
                document.getElementById('abcErrorMessage').innerHTML =
                    'No ABC classification data available';
                return;
            }

            // Aggregate revenue contributions by classification
            const classifications = abcData.reduce((acc, item) => {
                if (!acc[item.classification]) {
                    acc[item.classification] = 0;
                }
                acc[item.classification] += item.revenue_contribution;
                return acc;
            }, {});

            // Prepare data for the chart
            const series = Object.values(classifications);
            const labels = Object.keys(classifications);

            // Chart options
            const options = {
                series: series,
                chart: {
                    height: 400,
                    type: 'pie'
                },
                labels: labels,
                title: {
                    text: 'Revenue Contribution by ABC Classification',
                    align: 'center',
                    style: {
                        fontSize: '18px',
                        fontWeight: 'bold'
                    }
                },
                legend: {
                    position: 'bottom'
                },
                tooltip: {
                    y: {
                        formatter: function (value) {
                            return value.toFixed(2) + '%';
                        }
                    }
                },
                colors: ['#E74C3C', '#F1C40F', '#27AE60']
            };

            // Render the chart
            const chart = new ApexCharts(document.querySelector('#abcChart'), options);
            chart.render();
        } catch (error) {
            console.error("Error creating the ABC chart:", error);
            document.getElementById('abcErrorMessage').innerHTML =
                'Error creating the ABC chart: ' + error.message;
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
                            x: item.product_name,
                            y: item.forecast_monthly_demand
                        }))
                    },
                    {
                        name: 'Current Stock',
                        data: demandData.map(item => ({
                            x: item.product_name,
                            y: item.current_stock
                        }))
                    },
                    {
                        name: 'Suggested Order',
                        data: demandData.map(item => ({
                            x: item.product_name,
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
                    colors: ['#2F4F4F','#FF6F00','#FFD700'],
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
                            x: item.ProductName,
                            y: item.Profit
                        }))
                    },
                    {
                        name: 'Profit Margin (%)',
                        type: 'line',
                        data: profitData.map(item => ({
                            x: item.ProductName,
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
                    colors: ['#F62E8E', '#FEB019'],
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
                            	formatter: function(value) {
                                    if (value === null || value === undefined) return 'N/A';
                                    return parseFloat(value).toFixed(2);
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
                        enabled: true,
                        shared: true,
                        intersect: false,
                        y: [{
                            formatter: function(value) {
                                if (value === null || value === undefined) return 'N/A';
                                return parseFloat(value).toFixed(2);
                            }
                        }, {
                            formatter: function(value) {
                                if (value === null || value === undefined) return 'N/A';
                                return parseFloat(value).toFixed(1);
                            }
                        }]
                    
                    }, // Added closing brace here for tooltip object
                    title: {
                        text: 'Product Profitability Analysis',
                        align: 'center'
                    }
                };
                
                /* console.log("Series data:", series.map(s => ({
                    name: s.name,
                    values: s.data.map(d => d.y)
                }))); */

                const chart = new ApexCharts(document.querySelector("#profitabilityChart"), options);
                chart.render();
                chartInstances.profitabilityChart = chart;

            } catch (error) {
                console.error("Error in createProfitabilityChart:", error);
                document.getElementById('profitErrorMessage').innerHTML = 'Error creating profitability chart: ' + error.message;
            }
        }
            

        // Initialize both charts
        try {
            const rawSalesData = <%=request.getAttribute("salesData")%>;
            const rawAbcData = <%=request.getAttribute("abcData")%>;
            const rawInventoryData = <%=request.getAttribute("inventoryData")%>;
            const rawDemandData = <%=request.getAttribute("demandData")%>;
            const rawProfitData = <%=request.getAttribute("profitData")%>;
            
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
        
        const sidebarBtns = document.querySelectorAll('.sidebar-btn');
        sidebarBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                sidebarBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
            });
        });
    </script>
</body>
</html>