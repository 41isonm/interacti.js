*************************** 1. row ***************************
sp_report_ven000000001

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_report_ven000000001`(
    IN p_codigo_empresa SMALLINT,
    IN p_codigo_pedido BIGINT,
    IN p_codigo_vendedor INT
)
BEGIN
    SELECT 
        DISTINCT
        tb_ven_pedido.codigo AS codigo_pedido,
        numero_pedido AS numero_pedido_formatado,
        DATE_FORMAT(tb_ven_pedido.data_pedido, '%d/%m/%Y') AS data_pedido,
        IFNULL(tb_cad_parceiro_negocio.codigo,0) AS codigo_cliente,
        IFNULL((tb_cad_parceiro_negocio.razao_social),"-") AS cliente,
        IFNULL(tb_cad_parceiro_negocio.logradouro,"-") AS bairro_cliente,
        IFNULL(tb_cad_parceiro_negocio.uf,"-") AS uf_cliente,
        IFNULL(tb_cad_parceiro_negocio.municipio,"-") AS municipio_cliente,
        tb_cad_unidade_medida.descricao AS nome_item,
        IFNULL(tb_cad_parceiro_negocio.logradouro,"-") AS logradouro_cliente,
        IFNULL(tb_cad_parceiro_negocio.numero,"-") AS numero_cliente,
        IFNULL(tb_cad_parceiro_negocio.complemento,"-") AS complemento_cliente,
        IFNULL(tb_cad_parceiro_negocio.cep,"-") AS cep_cliente,
        IFNULL(tb_cad_parceiro_negocio.cnpj_cpf,"-") AS cnpj_cliente,
        IFNULL(tb_cad_parceiro_negocio.inscricao_estadual,"-") AS inscricao_estadual_cliente,
        IFNULL(tb_cad_parceiro_negocio.email,"-") AS email_cliente,
        IFNULL(tb_cad_parceiro_negocio.telefone1,"-") AS telefone_cliente,
        IFNULL(tb_ven_pedido.numero_pedido,0) AS numero_pedido,
        IFNULL(tb_ven_pedido.valor_frete, 0) AS valor_frete,
        IFNULL(tb_cad_condicao_pagamento.descricao,'-') AS condicao_pagamento,
        IFNULL(tb_ven_pedido.valor_desconto,0) AS desconto_geral,
        IFNULL(tb_ven_pedido.valor_final, tb_ven_pedido.valor_total) AS valor_final,
        IFNULL(tb_cad_item.descricao,'-') AS codigo_item,
        IFNULL(tb_ven_pedido_item.quantidade,0) AS quantidade,
        IFNULL(tb_ven_pedido_item.valor_unitario,0) AS valor_unitario,
        IFNULL(tb_ven_pedido_item.valor_unitario,0) AS valor_unitario_desconto,
        IFNULL(tb_ven_pedido_item.valor_unitario * quantidade,0) AS valor_total,
        IFNULL(tb_cad_vendedor.nome,'-') AS nome,
     --   IFNULL(tb_ven_pedido_item.quantidade * valor_unitario,0) AS valor_total_produto,
        IFNULL(tb_ven_pedido.observacao,"-") AS observacao,
        tb_ven_pedido.valor_final + tb_imp_regra.aliquota_icms_st + tb_imp_regra.aliquota_icms_ipi AS valor_final,
        IFNULL(tb_imp_regra.aliquota_icms_st, 0) AS valor_aliquota_icms_st,
        IFNULL(tb_imp_regra.aliquota_icms_ipi, 0) AS valor_ipi,
        'Rua Willian Beny Bloch Telles Alves' AS logradouro_empresa,
        '430 ' AS numero_empresa,
        'Distrito Industrial do Una' AS bairro_empresa,
        'Taubaté ' AS municipio_empresa,
        'SP' AS uf_empresa,
        '12072-335' AS cep_empresa,
        '47.191.763/0002-01' AS cnpj_empresa,
        '0045883730078' AS inscricao_estadual_empresa,
        '(12) 3602-2565' AS telefone_empresa,
        '' AS email_empresa,
        (
            SELECT SUM(tb_ven_pedido_item.valor_unitario * tb_ven_pedido_item.quantidade)
            FROM tb_ven_pedido_item
            WHERE tb_ven_pedido_item.codigo_pedido = tb_ven_pedido.codigo
            AND tb_ven_pedido_item.codigo_empresa = tb_ven_pedido.codigo_empresa
        ) AS valor_total_produto,
        
        0 AS valor_total_imposto
    FROM tb_ven_pedido 
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
        LEFT JOIN tb_imp_regra
            ON tb_imp_regra.codigo = tb_ven_pedido.codigo_regra_imposto
        LEFT JOIN tb_cad_unidade_medida
            ON tb_cad_unidade_medida.codigo = tb_cad_item.codigo_unidade_medida_venda
    WHERE tb_ven_pedido.codigo = p_codigo_pedido
        AND tb_ven_pedido.codigo_empresa = p_codigo_empresa 
        AND tb_ven_pedido.codigo_vendedor = p_codigo_vendedor
    GROUP BY tb_ven_pedido.codigo, tb_ven_pedido_item.codigo 
    ORDER BY tb_ven_pedido.codigo;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
