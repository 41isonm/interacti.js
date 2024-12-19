*************************** 1. row ***************************
sp_report_ven000000002_mysql

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_report_ven000000002_mysql`(
    IN p_codigo_empresa SMALLINT,
    IN p_codigo_pedido BIGINT,
    IN p_codigo_vendedor INT
)
BEGIN

    SELECT
		 DISTINCT
        tb_ven_pedido.codigo AS codigo_pedido,
        numero_pedido AS numero_pedido_formatado,
        
        
        IFNULL(tb_imp_regra.aliquota_icms,0) AS aliquota_icms,
		IFNULL(tb_imp_regra.aliquota_icms_st,0) AS aliquota_icms_st,
		IFNULL(tb_imp_regra.aliquota_icms_ipi,0) AS aliquota_icms_ipi,
		ifnull((aliquota_icms + aliquota_icms_st + aliquota_icms_ipi),0) as total_imposto,
        DATE_FORMAT(tb_ven_pedido.data_pedido, '%d/%m/%Y') AS data_pedido,  
        IFNULL(tb_cad_parceiro_negocio.codigo,0) AS codigo_cliente, 
        IFNULL((tb_cad_parceiro_negocio.razao_social),"-") AS cliente, 
		IFNULL(tb_cad_parceiro_negocio.logradouro,"-") AS bairro_cliente,
        IFNULL(tb_cad_parceiro_negocio.uf,"-") AS uf_cliente,
        IFNULL(tb_cad_parceiro_negocio.municipio,"-") AS municipio_cliente,

        IFNULL(tb_cad_parceiro_negocio.logradouro,"-") AS logradouro_cliente,
        IFNULL(tb_cad_parceiro_negocio.numero,"-") AS numero_cliente,
        IFNULL(tb_cad_parceiro_negocio.complemento,"-") AS complemento_cliente,
        IFNULL(tb_cad_parceiro_negocio.cep,"-") AS cep_cliente,
        IFNULL(tb_cad_parceiro_negocio.cnpj_cpf,"-") AS cnpj_cliente,
        IFNULL(tb_cad_parceiro_negocio.inscricao_estadual,"-") AS inscricao_estadual_cliente,
        IFNULL(tb_cad_parceiro_negocio.email,"-") as email_cliente,
        IFNULL(tb_cad_parceiro_negocio.telefone1,"-") as telefone_cliente,
        IFNULL(tb_ven_pedido.numero_pedido,0) AS numero_pedido,
        IFNULL(tb_ven_pedido.valor_frete, 0) AS valor_frete,
        IFNULL(tb_cad_condicao_pagamento.descricao,'-') AS condicao_pagamento,
        IFNULL(tb_ven_pedido.valor_desconto,0) AS desconto_geral,
        IFNULL(tb_ven_pedido.valor_total, tb_ven_pedido.valor_final) AS valor_total,
        IFNULL(tb_ven_pedido.valor_final, tb_ven_pedido.valor_total) AS valor_final,
        IFNULL(tb_cad_item.descricao,'-') AS codigo_item,
        IFNULL(tb_ven_pedido_item.quantidade,0) AS quantidade,
        IFNULL(tb_ven_pedido_item.valor_unitario,0) AS valor_unitario,
        IFNULL(tb_ven_pedido_item.valor_unitario,0) AS valor_unitario_desconto,
        IFNULL(tb_ven_pedido_item.valor_unitario * quantidade,0) AS valor_total,
        IFNULL(tb_cad_vendedor.nome,'-') AS nome,
        IFNULL(tb_ven_pedido_item.quantidade * valor_unitario,0) AS valor_total_produto,
        IFNULL(tb_ven_pedido.observacao,"-") as observacao,
        
        'Rua Willian Beny Bloch Telles Alves' as logradouro_empresa,
        '430 ' as numero_empresa,
        'Distrito Industrial do Una' as bairro_empresa,
        'Taubaté ' as municipio_empresa,
        'SP' as uf_empresa,
        '12072-335' as cep_empresa,
        '47.191.763/0002-01' as cnpj_empresa,
       '0045883730078' as inscricao_estadual_empresa,
        '(12) 3602-2565' as telefone_empresa,
       '' as email_empresa
    FROM tb_ven_pedido 
    LEFT JOIN tb_imp_regra
    ON tb_imp_regra.codigo = tb_ven_pedido.codigo_regra_imposto
    LEFT JOIN tb_cad_vendedor 
    ON tb_cad_vendedor.codigo = tb_ven_pedido.codigo_vendedor 
    
    INNER JOIN tb_ven_pedido_item 
    ON tb_ven_pedido.codigo = tb_ven_pedido_item.codigo_pedido 
    AND tb_ven_pedido.codigo_empresa = tb_ven_pedido_item.codigo_empresa
    
    INNER JOIN tb_cad_item 
    ON tb_cad_item.codigo = tb_ven_pedido_item.codigo_item 
    AND tb_cad_item.codigo_empresa = tb_ven_pedido_item.codigo_empresa 
    
    INNER JOIN tb_cad_usuario 
    ON tb_ven_pedido.codigo_vendedor = tb_cad_usuario.codigo_vendedor 
    AND tb_ven_pedido.codigo_empresa = tb_cad_usuario.codigo_empresa 
    
    LEFT JOIN tb_cad_parceiro_negocio 
    ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
    AND tb_ven_pedido.codigo_empresa = tb_cad_parceiro_negocio.codigo_empresa 
    
    LEFT JOIN tb_stc_municipio 
    ON tb_cad_parceiro_negocio.codigo_municipio = tb_stc_municipio.codigo 

    LEFT JOIN tb_cad_condicao_pagamento 
    ON tb_ven_pedido.codigo_condicao_pagamento = tb_cad_condicao_pagamento.codigo_parceiro_negocio 

   
   
 

    WHERE tb_ven_pedido.codigo = p_codigo_pedido
    AND tb_ven_pedido.codigo_empresa = p_codigo_empresa AND 
    tb_ven_pedido.codigo_vendedor = p_codigo_vendedor
    ORDER BY tb_ven_pedido.codigo;
    
    
    
    
    

END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
