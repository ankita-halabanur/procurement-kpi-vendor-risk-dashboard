-- ============================================================
-- Procurement KPI Analysis - SQL Queries
-- Source Table: procurement_db.`procurement kpi analysis dataset`
-- ============================================================


-- ============================================================
-- Query 1: Total Spend Per Supplier
-- Calculates total procurement spend per supplier using
-- quantity x negotiated price
-- ============================================================
SELECT 
    Supplier,
    COUNT(PO_ID)                                              AS Total_Orders,
    ROUND(SUM(Quantity * Negotiated_Price), 2)                AS Total_Spend,
    ROUND(
        SUM(Quantity * Negotiated_Price) * 100.0 
        / SUM(SUM(Quantity * Negotiated_Price)) OVER (), 2
    )                                                         AS Spend_Percent
FROM procurement_db.`procurement kpi analysis dataset`
GROUP BY Supplier
ORDER BY Total_Spend DESC;


-- ============================================================
-- Query 2: Supplier Delivery Rate %
-- Calculates % of orders delivered on time per supplier
-- ============================================================
SELECT 
    Supplier,
    COUNT(PO_ID)                                                        AS Total_Orders,
    SUM(CASE WHEN Order_Status = 'Delivered' THEN 1 ELSE 0 END)         AS OnTime_Delivered,
    ROUND(
        SUM(CASE WHEN Order_Status = 'Delivered' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(PO_ID), 2
    )                                                                    AS Delivery_Rate_Percent
FROM procurement_db.`procurement kpi analysis dataset`
GROUP BY Supplier
ORDER BY Delivery_Rate_Percent DESC;


-- ============================================================
-- Query 3: Cost Savings Per Supplier
-- Compares original vs negotiated cost to measure savings achieved
-- ============================================================
SELECT 
    Supplier,
    ROUND(SUM(Quantity * Unit_Price), 2)                                         AS Original_Cost,
    ROUND(SUM(Quantity * Negotiated_Price), 2)                                   AS Negotiated_Cost,
    ROUND(SUM(Quantity * Unit_Price) - SUM(Quantity * Negotiated_Price), 2)      AS Total_Savings,
    ROUND(
        (SUM(Quantity * Unit_Price) - SUM(Quantity * Negotiated_Price)) 
        / SUM(Quantity * Unit_Price) * 100, 2
    )                                                                             AS Savings_Percent
FROM procurement_db.`procurement kpi analysis dataset`
GROUP BY Supplier
ORDER BY Total_Savings DESC;


-- ============================================================
-- Query 4: Supplier Defect Rate %
-- Calculates defective units as % of total units received per supplier
-- ============================================================
SELECT 
    Supplier,
    SUM(Quantity)                                          AS Total_Units,
    SUM(Defective_Units)                                   AS Total_Defective,
    ROUND(SUM(Defective_Units) / SUM(Quantity) * 100, 2)   AS Defect_Rate_Percent
FROM procurement_db.`procurement kpi analysis dataset`
GROUP BY Supplier
ORDER BY Defect_Rate_Percent DESC;


-- ============================================================
-- Query 5: Monthly Procurement Trend
-- Tracks total orders and spend month-over-month
-- ============================================================
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m')           AS Order_Month,
    COUNT(PO_ID)                               AS Total_Orders,
    ROUND(SUM(Quantity * Negotiated_Price), 2) AS Monthly_Spend
FROM procurement_db.`procurement kpi analysis dataset`
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY DATE_FORMAT(Order_Date, '%Y-%m') ASC;


-- ============================================================
-- Query 6: Supplier Compliance Rate %
-- Measures % of orders meeting compliance requirements per supplier
-- ============================================================
SELECT 
    Supplier,
    COUNT(PO_ID)                                                          AS Total_Orders,
    SUM(CASE WHEN Compliance = 'Yes' THEN 1 ELSE 0 END)                   AS Compliant_Orders,
    ROUND(
        SUM(CASE WHEN Compliance = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(PO_ID), 2
    )                                                                      AS Compliance_Rate_Percent
FROM procurement_db.`procurement kpi analysis dataset`
GROUP BY Supplier
ORDER BY Compliance_Rate_Percent DESC;
