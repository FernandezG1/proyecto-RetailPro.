
-- ========================================================
-- PRE-ENTREGA 4: Consultas SQL de negocio
-- Archivo: m4_consultas_negocio.sql
-- ========================================================

-- Consulta 1 — Resumen ejecutivo mensual
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- Consulta 2 — Ranking de productos
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;


-- Consulta 3 — Clientes recurrentes
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;


-- Consulta 4 — Meses por encima/por debajo del promedio
WITH ventas_mensuales AS (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_mes
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT 
    mes,
    total_mes,
    (SELECT AVG(total_mes) FROM ventas_mensuales) AS promedio_general,
    CASE 
        WHEN total_mes > (SELECT AVG(total_mes) FROM ventas_mensuales) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS rendimiento_mes
FROM ventas_mensuales;


-- ========================================================
-- BLOQUE DE CIERRE: Hallazgos comerciales
-- ========================================================
-- 1. El producto con id_producto = 1 (Laptop Pro 15) concentra la mayor parte de la facturación debido a su alto valor unitario a pesar de tener menor volumen de unidades que los accesorios.
-- 2. Los clientes recurrentes (como el cliente 1 y 5) generan múltiples transacciones y representan una parte clave de los ingresos estables del negocio.
-- 3. La facturación mensual se concentra fuertemente en el mes de marzo (mes 3 según los registros actuales de prueba), marcando el pico principal de ventas frente al promedio general.