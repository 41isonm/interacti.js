*************************** 1. row ***************************
sp_select_filtro_venda_pedido

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_filtro_venda_pedido`(
    IN p_numero_pedido INT, 
    IN p_data_inicio DATE, 
    IN p_data_termino DATE, 
    IN p_cliente VARCHAR(250) CHARSET utf8, 
    IN p_codigo_vendedor INT,
    IN p_codigo_empresa INT)
BEGIN
    SELECT DISTINCT 
        tb_ven_pedido.codigo,
        tb_ven_pedido.numero_pedido,
        tb_ven_pedido.observacao,
        IFNULL(tb_imp_regra.codigo, 0) AS codigo_imp,
        IFNULL(tb_imp_regra.descricao, '-') AS descricao_imp,
        tb_cad_condicao_pagamento.descricao AS descricao_cond_pagamento,
        tb_ven_pedido.codigo_forma_pagamento,
        
        
        
        
                
		tb_ven_pedido.cep as cep,

        tb_ven_pedido.bairro as bairro,
		tb_ven_pedido.logradouro as logradouro,
		tb_ven_pedido.numero as numero,

		tb_ven_pedido.complemento as complemento,
		tb_ven_pedido.municipio_entrega as municipio,
        tb_ven_pedido.uf_entrega as uf_entrega,
        
        DATE_FORMAT(tb_ven_pedido.data_pedido, "%d/%m/%Y") AS data_pedido,
        DATE_FORMAT(DATE_ADD(tb_ven_pedido.data_pedido, INTERVAL 1 DAY), "%d/%m/%Y") AS dia_corrido,
        CONVERT(IFNULL(tb_ven_pedido.valor_frete, 0.00), DECIMAL(15, 2)) AS valor_frete,
        CONVERT(tb_ven_pedido.valor_final, DECIMAL(15, 2)) AS valor_final,
        CONVERT(tb_ven_pedido.valor_total, DECIMAL(15, 2)) AS valor_total,
        CONVERT(IFNULL(tb_ven_pedido.percentual_desconto, 0.0), DECIMAL(15, 2)) AS percentual_desconto,
        CONVERT(IFNULL(tb_ven_pedido.valor_desconto, 0.0), DECIMAL(15, 2)) AS valor_desconto,
        tb_ven_pedido.pre_cadastro AS modelo,
        tb_cad_parceiro_negocio.cnpj_cpf,
        tb_cad_parceiro_negocio.nome_fantasia AS cliente,
        tb_cad_parceiro_negocio.uf AS uf,
        tb_ven_pedido.possui_desconto AS possui_desconto,
        LEFT(tb_cad_parceiro_negocio.razao_social, 20) AS razao_social,
        CASE
            WHEN IFNULL(tb_ven_pedido.pre_cadastro, 0) = 0 THEN 'NÃO'
            ELSE 'SIM'
        END AS pre_cadastro,
        CASE        
            WHEN tb_ven_pedido.pre_cadastro = 0 THEN 'REPROVADO'
            WHEN tb_ven_pedido.pre_cadastro = 1 THEN 'APROVADO'
            ELSE 'EM ANÁLISE'
        END AS aprovado,
        tb_stc_status_pedido_venda.descricao AS status,
        IFNULL(tb_ven_pedido.justificativa, '') AS justificativa,
        '-' AS prazo_entrega,
        '-' AS codigo_rastreio,
        'https://portalunico.solistica.com.br/Solistica.Portal.UI/carga/consulta/' AS link_codigo_rastreio,
        '-' AS nota_fiscal,
        'teste' AS transportadora
    FROM 
        tb_ven_pedido 
    LEFT JOIN 
        tb_ven_pedido_item ON tb_ven_pedido.codigo = tb_ven_pedido_item.codigo
    LEFT JOIN 
        tb_imp_regra ON tb_ven_pedido.codigo_regra_imposto = tb_imp_regra.codigo
    LEFT JOIN
        tb_cad_parceiro_negocio ON tb_cad_parceiro_negocio.codigo = tb_ven_pedido.codigo_cliente
    LEFT JOIN
        tb_stc_status_pedido_venda ON tb_stc_status_pedido_venda.codigo = tb_ven_pedido.status
    LEFT JOIN
        tb_cad_condicao_pagamento ON tb_cad_condicao_pagamento.codigo_parceiro_negocio = tb_ven_pedido.codigo_condicao_pagamento
    WHERE 
		(p_numero_pedido = 0 OR p_numero_pedido IS NULL OR tb_ven_pedido.numero_pedido = p_numero_pedido)
        AND (p_data_inicio IS NULL OR tb_ven_pedido.data_pedido >= p_data_inicio)
        AND (p_data_termino IS NULL OR tb_ven_pedido.data_pedido <= p_data_termino)
        AND (p_data_inicio IS NULL OR p_data_termino IS NULL OR tb_ven_pedido.data_pedido BETWEEN p_data_inicio AND p_data_termino)
		AND (((tb_cad_parceiro_negocio.razao_social) LIKE CONCAT('%',(p_cliente)   , '%')) OR (p_cliente  = ''))

   ORDER BY 
        tb_ven_pedido.numero_pedido DESC,
        tb_ven_pedido.data_pedido DESC;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
