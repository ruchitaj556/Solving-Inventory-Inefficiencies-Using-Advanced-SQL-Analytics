# Solving Inventory Inefficiencies Using Advanced SQL Analytics

## 📋 Project Overview

This project presents an advanced SQL-based analytics solution designed to identify and solve inventory inefficiencies across multiple store locations and regions. By leveraging sophisticated SQL queries and data analysis techniques, this system provides insights into inventory management, demand forecasting, and stock optimization.

---

## 🎯 Objectives

1. **Analyze Inventory Performance**: Evaluate inventory levels across different stores, regions, and product categories
2. **Forecast Demand Accurately**: Identify patterns in demand forecasting and compare predictions with actual sales
3. **Optimize Stock Levels**: Determine whether inventory is over-stocked, under-stocked, or balanced
4. **Regional Analysis**: Compare inventory metrics across West, East, and North regions
5. **Data-Driven Insights**: Generate actionable recommendations based on SQL analytics

---

## 📊 Database Schema

### Main Tables

#### **inventory_forecasting**
The primary data table containing comprehensive inventory and sales data:

| Column | Type | Description |
|--------|------|-------------|
| Date | DATE | Transaction date |
| Store_ID | VARCHAR(10) | Store identifier (S001-S005) |
| Product_ID | VARCHAR(10) | Product identifier |
| Category | VARCHAR(50) | Product category |
| Region | VARCHAR(50) | Geographic region (West, East, North) |
| Inventory_Level | INT | Current inventory quantity |
| Units_Sold | INT | Units sold on the given date |
| Units_Ordered | INT | Units ordered |
| Demand_Forecast | FLOAT | Forecasted demand |
| Price | FLOAT | Product price |
| Discount | INT | Discount percentage |
| Weather_Condition | VARCHAR(20) | Weather conditions |
| Holiday_Promotion | BOOLEAN | Whether holiday promotion is active |
| Competitor_Pricing | FLOAT | Competitor pricing |
| Seasonality | VARCHAR(20) | Seasonality indicator |

#### **Product**
Lookup table for product categories:

| Column | Type |
|--------|------|
| Product_ID | VARCHAR(10) PRIMARY KEY |
| Category | VARCHAR(20) |

#### **Regional Store Tables**
Individual tables created for each region-store combination (e.g., `west1`, `west2`, `east1`, etc.):

| Column | Type | Description |
|--------|------|-------------|
| product_id | VARCHAR(10) PRIMARY KEY | Product identifier |
| store_id | VARCHAR(10) | Store identifier |
| region | VARCHAR(20) | Region name |
| weekly_avg_sale | FLOAT | Average weekly sales |
| weekly_avg_inventory | FLOAT | Average weekly inventory |
| inventory_turnover | FLOAT | Inventory turnover ratio |
| weekly_avg_forecast | FLOAT | Average weekly forecast |
| forecast_error | FLOAT | Difference between forecast and actual sales |
| stock_status | VARCHAR(20) | Status: Understocked, Overstocked, or Balanced |

---

## 🔍 Key Metrics & Calculations

### 1. **Weekly Average Sale**
```sql
ROUND(SUM(units_sold) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_sale
```
Calculates the average number of units sold per week.

### 2. **Weekly Average Inventory**
```sql
ROUND(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 2) AS weekly_avg_inventory
```
Determines the average inventory level per week.

### 3. **Inventory Turnover**
```sql
ROUND(
  (SUM(units_sold) * 7.0 / COUNT(DISTINCT date)) / 
  NULLIF(SUM(inventory_level) * 7.0 / COUNT(DISTINCT date), 0), 2
) AS inventory_turnover
```
Measures how quickly inventory is being sold and replaced.

### 4. **Forecast Error**
```sql
ROUND(
  (SUM(demand_forecast) * 7.0 / COUNT(DISTINCT date)) - 
  (SUM(units_sold) * 7.0 / COUNT(DISTINCT date)), 2
) AS forecast_error
```
Calculates the difference between predicted and actual demand.

### 5. **Stock Status Classification**
Based on inventory turnover compared to regional average:
- **Understocked**: `inventory_turnover > avg_turnover + 0.01`
- **Overstocked**: `inventory_turnover < avg_turnover - 0.01`
- **Balanced**: Within the acceptable range

---

## 📁 Files in This Repository

1. **SQLDoc (1).sql** - Complete SQL script containing:
   - Database creation and setup
   - Data import from CSV
   - Table creation for all 15 region-store combinations (3 regions × 5 stores)
   - Comprehensive queries for inventory analysis
   - Stock status classification logic

2. **Summary Report (1).pdf** - Executive summary including:
   - Key findings and insights
   - Regional analysis
   - Recommendations for inventory optimization
   - Visual representations of data

3. **README.md** - This documentation file

---

## 🚀 Usage Instructions

### Prerequisites
- MySQL 8.0 or higher
- Sample inventory data CSV file

### Setup Steps

1. **Create Database**
   ```sql
   CREATE DATABASE sqlAnalysis;
   USE sqlAnalysis;
   ```

2. **Run SQL Script**
   - Execute the `SQLDoc (1).sql` file to create all tables and populate data
   - Ensure the CSV file path is correctly configured in the LOAD DATA INFILE statement

3. **Access Results**
   - Query individual store tables (e.g., `SELECT * FROM west1;`)
   - Generate cross-region comparisons
   - Analyze stock status across all locations

---

## 📈 Key Insights & Findings

### Regional Coverage
- **Stores Analyzed**: 5 stores (S001 - S005)
- **Regions Covered**: West, East, North
- **Total Tables**: 15 (3 regions × 5 stores per region)

### Stock Status Categories
The analysis identifies three inventory states for each product-store combination, enabling targeted optimization strategies:
- Products with high turnover (understocked) → Increase orders
- Products with low turnover (overstocked) → Reduce inventory
- Balanced products → Maintain current levels

### Forecast Accuracy
The forecast error metric helps identify:
- Demand prediction accuracy
- Seasonal patterns
- Impact of external factors (weather, promotions, competition)

---

## 💡 Recommendations

1. **Rebalance Inventory**: Use stock status classifications to optimize inventory levels by region and store
2. **Improve Forecasting**: Address forecast errors by analyzing external factors and seasonality
3. **Regional Strategies**: Develop region-specific strategies based on comparative analysis
4. **Continuous Monitoring**: Regularly update analysis with new data for ongoing optimization
5. **Product Strategy**: Focus on high-turnover products for expansion and low-turnover products for clearance

---

## 🔧 Future Enhancements

- Integration with real-time data feeds
- Machine learning models for improved forecasting
- Automated alerts for inventory anomalies
- Dashboard visualization using BI tools
- Predictive analytics for demand planning

---

## 📞 Contact & Support

For questions or issues related to this project, please refer to the project documentation.

---

## 📄 License

This project is provided for educational and analytical purposes.

---

**Last Updated**: June 2026
