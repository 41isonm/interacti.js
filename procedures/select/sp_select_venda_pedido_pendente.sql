*************************** 1. row ***************************
sp_select_venda_pedido_pendente

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_venda_pedido_pendente`(
    IN `p_codigo_vendedor` INT
)
BEGIN
    SELECT DISTINCT 
		tb_ven_pedido.codigo,
        tb_ven_pedido.numero_pedido,
		(tb_cad_parceiro_negocio.nome_fantasia)  as cliente,
        DATE_FORMAT(
            CASE
                WHEN IFNULL(tb_ven_pedido.data_pedido, '') = '' THEN ''
                ELSE tb_ven_pedido.data_pedido
            END, "%d/%m/%Y"
        ) AS data_pedido,
        CONVERT(IFNULL(tb_ven_pedido.valor_frete, 0.00), DECIMAL(15,2)) AS valor_frete,
        CONVERT(tb_ven_pedido.valor_final, DECIMAL(15,2)) AS valor_final,
        CONVERT(tb_ven_pedido.valor_total, DECIMAL(15,2)) AS valor_total,
        CONVERT(IFNULL(tb_ven_pedido.percentual_desconto, 0.0), DECIMAL(15,2)) AS percentual_desconto,
        CONVERT(IFNULL(tb_ven_pedido.valor_desconto, 0.0), DECIMAL(15,2)) AS valor_desconto,
        tb_ven_pedido.pre_cadastro AS modelo,
        CASE        
            WHEN IFNULL(tb_ven_pedido.pre_cadastro, 0) = 0 THEN 'NÃO'
            ELSE 'SIM'
        END as pre_cadastro,
        CASE        
            WHEN tb_ven_pedido.pre_cadastro = 0 THEN "REPROVADO"
            WHEN tb_ven_pedido.pre_cadastro = 1 THEN "APROVADO"
            ELSE "EM ANÁLISE"
        END as status,
       
        tb_stc_status_pedido_venda.descricao as aprovado,
        IFNULL(tb_ven_pedido.justificativa,'') as justificativa,
        CASE        
            WHEN (tb_stc_status_pedido_venda.codigo) = 4 THEN "REPRESENTANTE"
            WHEN (tb_stc_status_pedido_venda.codigo) = 1 THEN "HM/SF"
            WHEN (tb_stc_status_pedido_venda.descricao IS NULL )  THEN "PENDENTE"
            ELSE ""
        END as pendencia
       
    FROM 
        tb_ven_pedido
    LEFT JOIN
        tb_stc_status_pedido_venda ON tb_ven_pedido.codigo_vendedor = tb_stc_status_pedido_venda.codigo
     LEFT JOIN
		tb_cad_parceiro_negocio ON tb_cad_parceiro_negocio.codigo_vendedor = p_codigo_vendedor
    WHERE
        tb_ven_pedido.codigo_vendedor = p_codigo_vendedor
    ORDER BY tb_ven_pedido.data_pedido DESC, tb_ven_pedido.numero_pedido DESC;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
