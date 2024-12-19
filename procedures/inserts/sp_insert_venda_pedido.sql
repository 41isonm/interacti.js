*************************** 1. row ***************************
sp_insert_venda_pedido

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_insert_venda_pedido`(
    IN `p_codigo_empresa` INT, 
    IN `p_codigo_usuario` INT, 
    IN `p_codigo_vendedor` INT, 
    IN `p_data_pedido` DATE, 
    IN `p_codigo_cliente` INT, 
    IN `p_codigo_condicao_pagamento` INT, 
    IN `p_codigo_grupo_empresa` VARCHAR(50), 
    IN `p_possui_desconto` INT, 
    IN `p_valor_desconto` DOUBLE, 
    IN `p_codigo_forma_pagamento` INT, 
    IN `p_codigo_moeda` INT, 
    IN `p_fator_cambial` DOUBLE, 
    IN `p_valor_frete` DOUBLE, 
    IN `p_hostname` VARCHAR(100), 
    IN `p_codigo_destinacao` INT,
    IN `p_aprovado` INT,
    IN `p_observacao` VARCHAR(4000),
    IN `p_troca` INT,
	IN `p_codigo_lista_preco` INT,
    IN `p_cep` varchar(250),
    IN `p_bairro` varchar(250),
    IN `p_logradouro` varchar(250),
    IN `p_numero` varchar(250),
    IN `p_complemento` varchar(250),
    IN `p_municipio_entrega` varchar(250),
    IN `p_uf_entrega` varchar(250),
	IN `p_dias_corrido` int,
    
	IN `p_valor_total_imposto` varchar(250),
	
    
    
    
    
    
    OUT `p_valor_final` DOUBLE,
    
    
    
    
    OUT `p_valor_total_retorno` DOUBLE,
    OUT `p_percentual_desconto_retorno` DOUBLE,
    OUT `p_valor_desconto_retorno` DOUBLE
)
BEGIN
    DECLARE p_valor_total_itens DOUBLE;
    DECLARE p_valor_total DOUBLE;
    DECLARE p_numero_pedido INT;
    DECLARE p_codigo INT;
    -- SETANDO O DIA QUE O PEDIDO É FEITO
    DECLARE p_data_pedido DATE;
    -- Cálculo do próximo código e número de pedido

    SET p_numero_pedido = IFNULL((SELECT MAX(numero_pedido) FROM tb_ven_pedido), 900000 ) + 1 ;
	SET p_codigo = IFNULL((SELECT MAX(numero_pedido) FROM tb_ven_pedido),0 )+1;
   
    UPDATE tb_cad_parceiro_negocio
    SET codigo_condicao_pagamento = p_codigo_condicao_pagamento
    WHERE codigo = p_codigo_cliente;
    
    
	SET p_data_pedido = CURDATE(); -- Correção feita aqui

    
    INSERT INTO tb_ven_pedido (
        codigo,
        codigo_empresa,
        numero_pedido,
        data_pedido,
        data_previsao_entrega,
        dias_corrido,
        codigo_cliente,
        codigo_condicao_pagamento,
        codigo_grupo_empresa,
        codigo_forma_pagamento,
        codigo_moeda,
        possui_desconto,
        percentual_desconto,
        valor_desconto,
        fator_cambial,
        codigo_usuario,
        data_input,
        status,
        hostname,
        valor_frete,
        codigo_vendedor,
        codigo_destinacao,
        aprovado,
        observacao,
        troca,
        codigo_regra_imposto,
        cep,
        bairro,
        logradouro,
        numero,
        complemento,
        municipio_entrega,
        uf_entrega,
        valor_total_imposto
        
    )
    VALUES (
        p_numero_pedido,
        p_codigo_empresa,
        p_numero_pedido,
		p_data_pedido ,
		p_data_pedido + INTERVAL 1 DAY,
		p_dias_corrido ,

        p_codigo_cliente,
        p_codigo_condicao_pagamento,
        p_codigo_grupo_empresa,
        p_codigo_forma_pagamento,
        p_codigo_moeda,
        p_possui_desconto,
        (CASE p_possui_desconto WHEN 1 THEN 3 ELSE 0 END),
        p_valor_desconto,
        p_fator_cambial,
        p_codigo_usuario,
        NOW(),
        4,
        p_hostname,
        p_valor_frete,
        p_codigo_vendedor,
        p_codigo_destinacao,
        p_aprovado,
        p_observacao,
        p_troca,
        p_codigo_lista_preco,
		p_cep,
        p_bairro,
        p_logradouro,
        p_numero,
        p_complemento,
        p_municipio_entrega,
        p_uf_entrega,
        p_valor_total_imposto
    );
    
		
	
    
        
    -- Definição dos valores de retorno
  
	SET p_valor_final = p_valor_total_itens - IFNULL(p_valor_desconto, 0);
	SET p_valor_total_retorno = IFNULL(p_valor_total_itens, 0);
	SET p_percentual_desconto_retorno = (CASE p_possui_desconto WHEN 1 THEN 3 ELSE 0 END);
	SET p_valor_desconto_retorno = IFNULL(p_valor_desconto, 0);

   
    -- Retorno dos valores calculados
    SELECT p_numero_pedido,p_valor_final, p_valor_total_retorno, p_percentual_desconto_retorno, p_valor_desconto_retorno;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
