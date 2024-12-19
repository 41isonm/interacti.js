*************************** 1. row ***************************
sp_report_ven000000001_mysql_teste

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_report_ven000000001_mysql_teste`(
    IN p_codigo_empresa SMALLINT,
    IN p_codigo_pedido BIGINT,
    IN p_codigo_vendedor INT
)
BEGIN
    DECLARE html VARCHAR(5000);
    DECLARE codigo_pedido bigint;
    DECLARE cnpj_cpf VARCHAR(200);
    
	DECLARE dia_atual VARCHAR(10);
    DECLARE inscricao_estadual varchar(20);
    DECLARE valor_total DECIMAL(15,2);
    DECLARE valor_final DECIMAL(15,2);
    DECLARE cliente VARCHAR(550);
    
    DECLARE nome VARCHAR(60);
    DECLARE cep VARCHAR(10);
    DECLARE observacao VARCHAR(500);
    DECLARE condicao_pagamento VARCHAR(50);
    DECLARE telefone1 VARCHAR(20);
    DECLARE email VARCHAR(150);
    DECLARE municipio VARCHAR(250);
        DECLARE razao_social VARCHAR(550);

	SET municipio = (  select  tb_cad_parceiro_negocio.municipio from tb_ven_pedido LEFT JOIN tb_cad_parceiro_negocio 
    ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
    AND tb_ven_pedido.codigo_empresa = tb_cad_parceiro_negocio.codigo_empresa
    where tb_ven_pedido.codigo = p_codigo_pedido );
    
    set razao_social = (  select  tb_cad_parceiro_negocio.razao_social from tb_ven_pedido LEFT JOIN tb_cad_parceiro_negocio 
    ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
    AND tb_ven_pedido.codigo_empresa = tb_cad_parceiro_negocio.codigo_empresa
    where tb_ven_pedido.codigo = p_codigo_pedido );
    
    
    SET email = (  select  tb_cad_parceiro_negocio.email from tb_ven_pedido LEFT JOIN tb_cad_parceiro_negocio 
    ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
    AND tb_ven_pedido.codigo_empresa = tb_cad_parceiro_negocio.codigo_empresa
    where tb_ven_pedido.codigo = p_codigo_pedido );
    
    set telefone1 = (   select  tb_cad_parceiro_negocio.telefone1 from tb_ven_pedido LEFT JOIN tb_cad_parceiro_negocio 
    ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
    AND tb_ven_pedido.codigo_empresa = tb_cad_parceiro_negocio.codigo_empresa
    where tb_ven_pedido.codigo = p_codigo_pedido);
    
    set cliente = (   select  tb_cad_parceiro_negocio.razao_social from tb_ven_pedido LEFT JOIN tb_cad_parceiro_negocio 
    ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
    AND tb_ven_pedido.codigo_empresa = tb_cad_parceiro_negocio.codigo_empresa
    where tb_ven_pedido.codigo = p_codigo_pedido);
    
    SET condicao_pagamento = (select tb_cad_condicao_pagamento.descricao from tb_ven_pedido
    LEFT JOIN tb_cad_condicao_pagamento 
    ON tb_ven_pedido.codigo_condicao_pagamento = tb_cad_condicao_pagamento.codigo_parceiro_negocio
    where tb_ven_pedido.codigo = p_codigo_pedido);
    
    
    SET observacao = (select  tb_ven_pedido.observacao from tb_ven_pedido LEFT JOIN tb_cad_parceiro_negocio 
    ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
    AND tb_ven_pedido.codigo_empresa = tb_cad_parceiro_negocio.codigo_empresa
    where tb_ven_pedido.codigo = p_codigo_pedido);
    
    SET cep = (select  tb_cad_parceiro_negocio.cep from tb_ven_pedido LEFT JOIN tb_cad_parceiro_negocio 
    ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
    AND tb_ven_pedido.codigo_empresa = tb_cad_parceiro_negocio.codigo_empresa
    where tb_ven_pedido.codigo = p_codigo_pedido);
    
    -- colocado valor total como valor final pois com valor total esta como null 
    SET valor_total = ( select  valor_final from tb_ven_pedido LEFT JOIN tb_cad_parceiro_negocio 
    ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
    AND tb_ven_pedido.codigo_empresa = tb_cad_parceiro_negocio.codigo_empresa
    where tb_ven_pedido.codigo = p_codigo_pedido );
    
    
    set valor_final =  ( select  valor_final from tb_ven_pedido LEFT JOIN tb_cad_parceiro_negocio 
    ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
    AND tb_ven_pedido.codigo_empresa = tb_cad_parceiro_negocio.codigo_empresa
    where tb_ven_pedido.codigo = p_codigo_pedido );
    
    SET cnpj_cpf = (  select  DATE_FORMAT(data_pedido, '%d/%m/%Y') from tb_ven_pedido LEFT JOIN tb_cad_parceiro_negocio 
    ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
    AND tb_ven_pedido.codigo_empresa = tb_cad_parceiro_negocio.codigo_empresa
    where tb_ven_pedido.codigo = p_codigo_pedido);
    
    
    SET inscricao_estadual = ( select  inscricao_estadual from tb_ven_pedido LEFT JOIN tb_cad_parceiro_negocio 
    ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
    AND tb_ven_pedido.codigo_empresa = tb_cad_parceiro_negocio.codigo_empresa
    where tb_ven_pedido.codigo = p_codigo_pedido);

    -- Obtém a data atual no formato 'dd/mm/yyyy'
    SET dia_atual =  (select  DATE_FORMAT(data_pedido, '%d/%m/%Y') from tb_ven_pedido LEFT JOIN tb_cad_parceiro_negocio 
    ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
    AND tb_ven_pedido.codigo_empresa = tb_cad_parceiro_negocio.codigo_empresa
    where tb_ven_pedido.codigo = p_codigo_pedido);
    
    
 -- Obtenção do nome do vendedor
    SET nome = (
        SELECT nome 
        FROM tb_cad_vendedor 
        WHERE codigo = p_codigo_vendedor
    );    
    
    
    set codigo_pedido = (select codigo from tb_ven_pedido where codigo = p_codigo_pedido);

    -- Inicia o HTML estático
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
        '.address-label, .client-label, .order-info-title { font-size: 14px; margin: 5px 0; }',
        '.order-info-column { text-align: right; }',
        '.client-details-row { margin-top: 20px; }',
        '.client-info { font-size: 14px; }',
        '.product-table-container { margin-top: 20px; }',
        'table { width: 100%; border-collapse: collapse; margin-top: 10px; }',
        'th, td { padding: 8px; text-align: left; border: 1px solid #ddd; }',
        'th { background-color: #f4f4f4; }',
        '.totals-row, .payment-conditions-row { margin-top: 20px; }',
        '.totals-column { font-size: 14px; }',
        '.final-value, .total-geral { margin-top: 10px; font-weight: bold; }',
        '.footer { text-align: center; margin-top: 30px; font-size: 12px; color: #888; }',
        '.divider { margin-top: 30px; border: 0; border-top: 1px solid #ddd; }',
        '</style>',
        '</head>',
        '<body>',
        '<div class="content-container">',
        '<div class="report-card" id="report-content">',
        
        -- Cabeçalho
        '<div class="header-row">',
        '  <div class="logo-column">',
        '    <img src="./../../../assets/images/logoCabr.png" alt="Logo" class="logo-img">',
        '    <label class="address-label">Rua Willian Beny Bloch Telles Alves, 430</label>',
        '    <label class="address-label">Distrito Industrial do Una, SALA 04</label>',
        '    <label class="client-label">CLIENTE: ',cliente,'</label>',
        '  </div>',
        '  <div class="order-info-column">',
        '    <label class="order-info-title">Pedido de Venda</label>',
        '    <label><strong>Nº PEDIDO:</strong> ',codigo_pedido, '</label>',
        '    <label><strong>DATA EMISSÃO:</strong> ',dia_atual, '</label>',
              '    <label><strong>VENDEDOR:</strong> ',ifnull(nome,'0'),'</label>',

      
        '  </div>',
        '</div>',
        
        -- Informações do Cliente
        '<div class="client-details-row">',
        '  <div class="client-info">',
        '    <label><strong>CLIENTE:</strong> ',razao_social,' | <strong>CNPJ/CPF:</strong> ',cnpj_cpf,'</label>',
        '    <label><strong>ENDEREÇO:</strong> Rua Willian Beny Bloch Telles Alve | <strong>CEP:</strong>',cep,' </label>',
        '    <label><strong>CIDADE:</strong> ',municipio,' </label>',
        '    <label><strong>CONTATO:</strong> EMAIL:',email,' <strong>TELEFONE:</strong> ',telefone1,'</label>',
        '  </div>',
        '</div>',
        
        -- Tabela de Produtos
        '<div class="product-table-container">',
        '  <table>',
        '    <thead>',
        '      <tr>',
        '        <th>Produto</th>',
        '        <th>U.M</th>',
        '        <th>Valor IPI</th>',
        '        <th>Valor ICMS_ST</th>',
        '        <th>Qtde.</th>',
        '        <th>Valor Unitário</th>',
        '        <th>Valor Total</th>',
        '      </tr>',
        '    </thead>',
        '    <tbody>',
        '      <tr>',
        '        <td>Produto Exemplo 1</td>',
        '        <td>UN</td>',
        '        <td>10%</td>',
        '        <td>15%</td>',
        '        <td>10</td>',
        '        <td>R$ 100,00</td>',
        '        <td>R$ ',ifnull(valor_total,0),'</td>',
        '      </tr>',
        '    </tbody>',
        '  </table>',
        '</div>',
        
        -- Totais
        '<div class="totals-row">',
        '  <div class="totals-column">',
        '    <label><strong>Total de produtos:</strong> R$ 1.000,00</label>',
        '    <label><strong>Valor de desconto:</strong> R$ 50,00</label>',
        '    <label><strong>Total de imposto:</strong> R$ 100,00</label>',
        '    <div class="final-value">',
        '      <label><strong>Valor Final:</strong> R$ ',ifnull(valor_final,0),'</label>',
        '    </div>',
        '  </div>',
        '</div>',
        
        -- Condições de Pagamento
        '<div class="payment-conditions-row">',
        '  <div class="rule-payment">',
        '    <label class="payment-title">CONDIÇÕES GERAIS DE FORNECIMENTO</label>',
        '    <label><strong>Cond. Pagamento:</strong> ',condicao_pagamento,'</label>',
        '    <label><strong>Observação:',observacao,'</strong> </label>',
        '    <div class="total-geral">',
        '      <label><strong>Total Geral:</strong> R$ ',ifnull(valor_total,0),'</label>',
        '    </div>',
        '  </div>',
        '</div>',
        
        '<hr class="divider" />',
        
        -- Rodapé
        '<div class="footer">',
        '  <label class="footer-date"></label>',
        '</div>',
        
        '</div>',
        '</div>',
        '</body>',
        '</html>'
    );

    -- Retorna o HTML gerado
    SELECT html;

END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
