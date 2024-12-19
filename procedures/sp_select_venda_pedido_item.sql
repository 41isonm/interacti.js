*************************** 1. row ***************************
sp_select_venda_pedido_item

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_venda_pedido_item`(IN `p_codigo` BIGINT)
BEGIN
    SELECT 
    distinct
        tb_ven_pedido_item.codigo,
        tb_ven_pedido.numero_pedido,
        tb_ven_pedido.codigo as codigo_pedido,
        tb_ven_pedido_item.codigo,
        IFNULL(tb_cad_condicao_pagamento.descricao, "CONDICAO DE PAGAMENTO NÃO INFORMADA") as codigo_condicao_pagamento,
        IFNULL(tb_imp_regra.descricao, '-') as descricao_imp,
        IFNULL(tb_imp_regra.codigo, 0) as codigo_imp,
        tb_cad_item.codigo as codigo_item,
        tb_cad_item.codigo_item as codigo_produto_servico,
        tb_cad_item.descricao,
        tb_ven_pedido_item.descricao as descricao_produto,
        IFNULL(um_venda.sigla, '-') AS sigla,
        IFNULL(um_item.sigla, '-') AS sigla_item,
        tb_ven_pedido_item.quantidade,
        tb_ven_pedido_item.valor_unitario as valor_unitario,
        (valor_unitario * tb_ven_pedido_item.quantidade) as valor_total,
        IFNULL(tb_ven_pedido.pre_cadastro, 1) as pre_cadastro
    FROM tb_ven_pedido 
    INNER JOIN tb_ven_pedido_item 
        ON tb_ven_pedido_item.codigo_empresa = tb_ven_pedido.codigo_empresa
        AND tb_ven_pedido_item.codigo_pedido = tb_ven_pedido.numero_pedido
    INNER JOIN tb_cad_item 
        ON tb_cad_item.codigo = tb_ven_pedido_item.codigo_item  
    LEFT JOIN tb_cad_unidade_medida AS um_venda 
        ON um_venda.codigo = tb_cad_item.codigo_unidade_medida_venda
    INNER JOIN tb_imp_regra 
        ON tb_imp_regra.codigo = tb_ven_pedido_item.codigo_regra_imposto
    LEFT JOIN tb_cad_condicao_pagamento  
        ON tb_cad_condicao_pagamento.codigo_parceiro_negocio = tb_ven_pedido.codigo_condicao_pagamento
    LEFT JOIN tb_cad_unidade_medida AS um_item 
        ON um_item.codigo = tb_ven_pedido_item.codigo_unidade_medida 
    WHERE (tb_ven_pedido.codigo_vendedor = p_codigo)
    ORDER BY 
        tb_cad_item.codigo_item DESC, 
        tb_ven_pedido_item.codigo_pedido DESC,
        tb_cad_item.codigo DESC;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
