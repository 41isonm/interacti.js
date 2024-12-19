*************************** 1. row ***************************
sp_select_venda_pedido

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_venda_pedido`(
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
         tb_ven_pedido.dias_corrido as dias_corrido,
        tb_ven_pedido.observacao,
		IFNULL(tb_imp_regra.codigo,0) as codigo_imp,
        IFNULL(tb_imp_regra.descricao,'-') AS descricao_imp,
        IFNULL(tb_cad_condicao_pagamento.descricao,'-') as descricao_cond_pagamento,
        
        
        tb_ven_pedido.codigo_forma_pagamento,
                
                
		tb_ven_pedido.cep as cep,

        tb_ven_pedido.bairro as bairro,
		tb_ven_pedido.logradouro as logradouro,
		tb_ven_pedido.numero as numero,

		tb_ven_pedido.complemento as complemento,
		tb_ven_pedido.municipio_entrega as municipio,
        tb_ven_pedido.uf_entrega as uf_entrega,
		GROUP_CONCAT(IFNULL(tb_ven_pedido_anexo.nome_arquivo, "Nenhum arquivo anexado") SEPARATOR ', ') AS nome_arquivo,

        
        DATE_FORMAT(CASE
                        WHEN IFNULL(tb_ven_pedido.data_pedido, '') = '' THEN ''
                        ELSE tb_ven_pedido.data_pedido
                    END, "%d/%m/%Y") AS data_pedido,
		DATE_FORMAT(
			CASE
				WHEN tb_ven_pedido.data_pedido IS NULL OR tb_ven_pedido.data_pedido = '' THEN NULL
				ELSE DATE_ADD(tb_ven_pedido.data_pedido, INTERVAL 1 DAY)
			END, 
			"%d/%m/%Y"
		) AS dia_corrido,

        CONVERT(IFNULL(tb_ven_pedido.valor_frete, 0.00), DECIMAL(15, 2)) as valor_frete,
        (CONVERT(tb_ven_pedido.valor_final, DECIMAL(15, 2)) * 1) as valor_final,
        CONVERT(tb_ven_pedido.valor_total, DECIMAL(15, 2)) as valor_total,
        CONVERT(IFNULL(tb_ven_pedido.percentual_desconto, 0.0), DECIMAL(15, 2)) as percentual_desconto,
        CONVERT(IFNULL(tb_ven_pedido.valor_desconto, 0.0), DECIMAL(15, 2)) as valor_desconto,
        tb_ven_pedido.pre_cadastro as modelo,
        tb_cad_parceiro_negocio.cnpj_cpf,
        tb_cad_parceiro_negocio.nome_fantasia as cliente,
        tb_cad_parceiro_negocio.uf as uf,
        tb_ven_pedido.possui_desconto as possui_desconto,
        ifnull(status_cancelar,0) as status_cancelar,
        LEFT(tb_cad_parceiro_negocio.razao_social, 20) AS razao_social,
        CASE
            WHEN IFNULL(tb_ven_pedido.pre_cadastro, 0) = 0 THEN 'NÃO'
            ELSE 'SIM'
        END as pre_cadastro,
        CASE        
            WHEN tb_ven_pedido.pre_cadastro = 0 THEN 'REPROVADO'
            WHEN tb_ven_pedido.pre_cadastro = 1 THEN 'APROVADO'
            ELSE 'EM ANÁLISE'
        END as aprovado,
        tb_stc_status_pedido_venda.descricao as status,
        IFNULL(tb_ven_pedido.justificativa, '') as justificativa,
        '-' as prazo_entrega,
        '-' as codigo_rastreio,
        'https://portalunico.solistica.com.br/Solistica.Portal.UI/carga/consulta/' as link_codigo_rastreio,
        '-' AS nota_fiscal,
        'teste' as transportadora,
        ifnull(valor_total_imposto,0) as valor_total_imposto
   FROM 
        tb_ven_pedido 
   LEFT JOIN 
        tb_ven_pedido_item  ON tb_ven_pedido.codigo =  tb_ven_pedido_item.codigo
  LEFT JOIN 
    tb_imp_regra  ON tb_ven_pedido.codigo_regra_imposto = tb_imp_regra.codigo

    LEFT JOIN
        tb_cad_parceiro_negocio ON
        tb_cad_parceiro_negocio.codigo = tb_ven_pedido.codigo_cliente 
    LEFT JOIN
        tb_stc_status_pedido_venda ON
        tb_stc_status_pedido_venda.codigo = tb_ven_pedido.status
 
    LEFT JOIN
        tb_cad_condicao_pagamento ON
        tb_cad_condicao_pagamento.codigo_parceiro_negocio = tb_ven_pedido.codigo_condicao_pagamento
	 LEFT JOIN 
		tb_ven_pedido_anexo ON
        tb_ven_pedido_anexo.numero_pedido = tb_ven_pedido.numero_pedido
     
     where tb_ven_pedido.codigo_vendedor = p_codigo_vendedor
    GROUP BY 
		tb_ven_pedido.codigo
    ORDER BY 
        tb_ven_pedido.numero_pedido DESC,
        tb_ven_pedido.data_pedido DESC;
        

        
    
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
