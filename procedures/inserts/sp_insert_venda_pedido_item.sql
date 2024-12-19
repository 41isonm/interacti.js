*************************** 1. row ***************************
sp_insert_venda_pedido_item

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_insert_venda_pedido_item`(
    IN `p_codigo_pedido` INT, 
    IN `p_codigo_empresa` INT, 
    IN `p_codigo_item` BIGINT, 
    IN `p_codigo_usuario` INT, 
    IN `p_quantidade` INT,
    IN `p_descricao` VARCHAR(23),
    IN `p_codigo_unidade_medida` INT, 
    IN `p_valor_unitario` DOUBLE,
    IN `p_fluxo_atualizacao` INT

)
BEGIN
    DECLARE p_data_previsao_entrega DATE;
    DECLARE p_valor_total_itens DOUBLE;
    DECLARE p_valor_total DOUBLE;
    DECLARE item_exists INT;
    DECLARE desconto INT;
    DECLARE p_codigo INT;
   
   


	IF p_codigo_item IS NULL THEN 
         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Codigo item não informado para o pedido.';
    END IF;
    

	IF p_fluxo_atualizacao = 1 THEN 
		set p_codigo = p_codigo_pedido;
	else 
        SET p_codigo = (SELECT MAX(numero_pedido) FROM tb_ven_pedido) ;

	END IF;
    
    
    if not ((select count(*)
				from tb_ven_pedido_item 
                where tb_ven_pedido_item.codigo_pedido = p_codigo_pedido
               and tb_ven_pedido_item.codigo_empresa = p_codigo_empresa
                and tb_ven_pedido_item.codigo_item = p_codigo_item)>0) then

    INSERT INTO tb_ven_pedido_item (
        codigo_pedido,
        codigo_empresa,
        codigo_item,
        codigo_destinacao,
        quantidade,
        descricao,
        codigo_unidade_medida,
        valor_unitario,
        valor_unitario_desconto,
        valor_total_desconto,
        status,
        codigo_tipo_item
    ) VALUES (
        p_codigo,
        p_codigo_empresa,
        p_codigo_item,
        2, 
        p_quantidade,
        p_descricao,
        p_codigo_unidade_medida,
        p_valor_unitario,
        p_valor_unitario, 
        (p_valor_unitario * p_quantidade),
        1,
        1  
    );


    UPDATE tb_ven_pedido_item 
    SET descricao = (
        SELECT obter_descricao_item(descricao) 
        FROM tb_cad_item 
        WHERE codigo = p_codigo_item
    )
    WHERE codigo_item = p_codigo_item;


    UPDATE tb_ven_pedido
    SET valor_total = (
        SELECT SUM(valor_total_desconto) 
        FROM tb_ven_pedido_item 
        WHERE codigo_pedido = p_codigo
    ),
    valor_final = (
        SELECT SUM(valor_total_desconto) 
        FROM tb_ven_pedido_item 
        WHERE codigo_pedido = p_codigo
    )
    WHERE codigo = p_codigo;


    UPDATE tb_ven_pedido_item AS i
    JOIN tb_ven_pedido AS p ON i.codigo_pedido = p.numero_pedido AND i.codigo_empresa = p.codigo_empresa
    SET i.codigo_regra_imposto = p.codigo_regra_imposto
    WHERE i.codigo_empresa = p_codigo_empresa;

    SET desconto = (
		select codigo_condicao_pagamento from tb_ven_pedido 
        WHERE codigo = p_codigo
    );


    
    IF desconto = 3 THEN
        UPDATE tb_ven_pedido 
        SET valor_final = (
            SELECT SUM(valor_total_desconto) - (SUM(valor_total_desconto) * 0.025) 
            FROM tb_ven_pedido_item 
            WHERE codigo_pedido = p_codigo
        )
        WHERE codigo = p_codigo;
    END IF;


    
    select p_codigo;
    else
		CALL raise_error;
    
    end if;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
