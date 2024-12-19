*************************** 1. row ***************************
sp_update_venda_pedido

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_update_venda_pedido`(
IN `p_codigo` INT,
IN `p_codigo_empresa` INT,
IN `p_codigo_usuario` INT,
IN `p_codigo_vendedor` INT,
IN `p_data_pedido` DATE,
IN `p_codigo_cliente` INT,
IN `p_codigo_condicao_pagamento` INT,
IN `p_codigo_grupo_empresa` VARCHAR(50), 
IN `p_possui_desconto` BOOLEAN, 
IN `p_valor_desconto` DOUBLE, 
IN `p_codigo_forma_pagamento` INT,
IN `p_codigo_moeda` INT,
IN `p_fator_cambial` DOUBLE,
IN `p_valor_frete` DOUBLE,
IN `p_hostname` VARCHAR(100),
IN `p_codigo_destinacao` INT, 
IN `p_aprovado` INT, 
IN `p_observacao` VARCHAR(4000), 
IN `p_troca` int,
IN `p_codigo_lista_preco` INT,
IN `p_valor_final` DOUBLE,
IN `p_valor_total` DOUBLE,
IN `p_cep` VARCHAR(250),
IN `p_uf` VARCHAR(250),
IN `p_municipio` VARCHAR(250),
IN `p_bairro` VARCHAR(250),

IN `p_logradouro` VARCHAR(250),


IN `p_complemento` VARCHAR(250),
IN `p_numero` VARCHAR(250),
IN `p_total_imposto` VARCHAR(250),

IN `p_dias_uteis` VARCHAR(250)



)
BEGIN

   
	
		
        UPDATE tb_ven_pedido SET 
				data_pedido = p_data_pedido,
				codigo_cliente = p_codigo_cliente,
				codigo_condicao_pagamento = p_codigo_condicao_pagamento,
				codigo_grupo_empresa = p_codigo_grupo_empresa,
				codigo_forma_pagamento = p_codigo_forma_pagamento,
				codigo_moeda = p_codigo_moeda,
				fator_cambial = p_fator_cambial,
				codigo_usuario = p_codigo_usuario,
				data_alteracao = NOW(),
				hostname = p_hostname,
				valor_frete = p_valor_frete,
				possui_desconto = p_possui_desconto,
				percentual_desconto = (CASE p_possui_desconto WHEN TRUE THEN 3 ELSE 0 END),
				valor_desconto = p_valor_desconto,
			  
				pre_cadastro = 1,
				codigo_destinacao = p_codigo_destinacao,
				aprovado = p_aprovado,
				observacao = p_observacao,
				status = (CASE aprovado WHEN 1 THEN 1 ELSE 4 END),
				troca= p_troca,
				codigo_regra_imposto =  p_codigo_lista_preco,
				valor_total = p_valor_total,
				valor_final = p_valor_final ,
			
				cep = p_cep,
				uf_entrega = p_uf,
				municipio_entrega = p_municipio,
				bairro = p_bairro,
				logradouro = p_logradouro,
				complemento = p_complemento,
				numero = p_numero,
				valor_total_imposto = p_total_imposto,
				dias_corrido = p_dias_uteis
			
			
			
			
			WHERE   codigo = p_codigo;
            
		
			


     
   
    
    
    
  
	
    
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
