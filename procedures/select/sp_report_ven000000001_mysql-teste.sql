*************************** 1. row ***************************
sp_report_ven000000001_mysql-teste

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_report_ven000000001_mysql-teste`(
    IN p_codigo_empresa SMALLINT,
    IN p_codigo_pedido BIGINT,
    IN p_codigo_vendedor INT
)
BEGIN
    DECLARE html VARCHAR(5000);
    DECLARE cliente_nome VARCHAR(255);
    DECLARE vendedor_nome VARCHAR(255);
    DECLARE data_emissao DATE;
    
    -- Fetch order details
    SELECT c.nome, v.nome, p.data_emissao
    INTO cliente_nome, vendedor_nome, data_emissao
    FROM pedidos p
    JOIN clientes c ON p.codigo_cliente = c.codigo
    JOIN vendedores v ON p.codigo_vendedor = v.codigo
    WHERE p.codigo_empresa = p_codigo_empresa
      AND p.codigo_pedido = p_codigo_pedido
      AND p.codigo_vendedor = p_codigo_vendedor;

    -- Start HTML structure
    SET html = CONCAT(
        '<!DOCTYPE html>',
        '<html lang="pt-br">',
        '<head>',
        '<meta charset="UTF-8">',
        '<meta name="viewport" content="width=device-width, initial-scale=1.0">',
        '<title>Relatório Pedido de Venda</title>',
        '<style>',
        'body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f4f4; }',
        '.content-container { padding: 20px; }',
        '.report-card { background-color: #ffffff; border-radius: 8px; padding: 20px; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); }',
        '.header-row { margin-bottom: 20px; }',
        '.logo-column { display: flex; flex-direction: column; justify-content: center; align-items: flex-start; }',
        '.logo-img { width: 150px; margin-bottom: 10px; }',
        '.client-label, .order-info-title { font-size: 14px; margin: 5px 0; }',
        '.order-info-column { text-align: right; }',
        '.footer { text-align: center; margin-top: 30px; font-size: 12px; color: #888; }',
        '</style>',
        '</head>',
        '<body>',
        '<div class="content-container">',
        '<div class="report-card">',
        
        -- Header with dynamic data --
        '<div class="header-row">',
        '  <div class="logo-column">',
        '    <img src="./../../../assets/images/logoCabr.png" alt="Logo" class="logo-img">',
        '    <label class="client-label">CLIENTE: ', cliente_nome, '</label>',
        '  </div>',
        '  <div class="order-info-column">',
        '    <label class="order-info-title">Pedido de Venda</label>',
        '    <label><strong>Nº PEDIDO:</strong> ', p_codigo_pedido, '</label>',
        '    <label><strong>DATA EMISSÃO:</strong> ', DATE_FORMAT(data_emissao, '%d/%m/%Y'), '</label>',
        '    <label><strong>VENDEDOR:</strong> ', vendedor_nome, '</label>',
        '  </div>',
        '</div>',
        
        -- Footer --
        '<div class="footer">',
        '  <label class="footer-date">', DATE_FORMAT(CURDATE(), '%d/%m/%Y'), '</label>',
        '</div>',
        
        '</div>',
        '</div>',
        '</body>',
        '</html>'
    );

    -- Return the generated HTML
    SELECT html;

END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
