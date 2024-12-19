*************************** 1. row ***************************
sp_update_venda_pedido_item_quantidade_e_valor_unitario

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_update_venda_pedido_item_quantidade_e_valor_unitario`(
    IN `p_numero_pedido` INT, 
    IN `p_codigo_empresa` INT,
    IN `p_codigo_item` INT,
    IN `p_quantidade` INT,
    IN `p_valor_unitario` DOUBLE,
    IN `p_codigo_lista_preco` INT
)
BEGIN
    DECLARE codigo_condicao_pagamento INT;

    -- Recuperando o código da condição de pagamento
    SET codigo_condicao_pagamento = ( 
        SELECT codigo_condicao_pagamento 
        FROM tb_ven_pedido
        WHERE numero_pedido = p_numero_pedido 
          AND codigo_empresa = p_codigo_empresa 
          AND codigo_regra_imposto = p_codigo_lista_preco
    );

    -- Verificando a condição e saindo se for verdadeira
  

    -- Início da atualização dos dados
    UPDATE tb_ven_pedido_item 
    JOIN tb_ven_pedido ON tb_ven_pedido.codigo = tb_ven_pedido_item.codigo_pedido
    SET 
        tb_ven_pedido_item.quantidade = p_quantidade,
        tb_ven_pedido_item.valor_unitario = p_valor_unitario,
        tb_ven_pedido_item.valor_total_desconto = p_quantidade * p_valor_unitario
    WHERE 
        tb_ven_pedido_item.codigo_empresa = p_codigo_empresa AND 
        tb_ven_pedido_item.codigo_pedido = p_numero_pedido AND 
        tb_ven_pedido_item.codigo_item = p_codigo_item AND
        tb_ven_pedido_item.codigo_regra_imposto = p_codigo_lista_preco;

  
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
