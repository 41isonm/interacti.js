*************************** 1. row ***************************
sp_orcamento_analise

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_orcamento_analise`(in p_codigo_empresa smallint)
BEGIN

	select 
    now() as data_sincronizacao,
    -- Dados pedido
    tb_ven_pedido.codigo as codigo_pedido,
    tb_ven_pedido_item.codigo as codigo_pedido_item,
    numero_pedido,
    data_pedido,
	tb_ven_pedido.observacao,
    tb_ven_pedido.valor_total,
    tb_ven_pedido.valor_desconto,
    tb_ven_pedido.valor_final,
    tb_ven_pedido.data_input,
    tb_ven_pedido.status,
   
   -- Dados Parceiro de negocio
   tb_cad_parceiro_negocio.codigo as codigo_cliente,
   tb_cad_parceiro_negocio.cnpj_cpf,
   tb_stc_personalidade.descricao as personalidade,
   tb_cad_parceiro_negocio.razao_social,
   tb_cad_parceiro_negocio.nome_fantasia,
   inscricao_estadual,
   tb_stc_municipio.codigo as codigo_municipio,
   tb_stc_municipio.uf as uf,
   tb_cad_parceiro_negocio.logradouro,
   tb_cad_parceiro_negocio.numero,
   tb_cad_parceiro_negocio.bairro,
   tb_cad_parceiro_negocio.cep,
   tb_cad_parceiro_negocio.complemento,
   tb_cad_parceiro_negocio.telefone1,
   tb_cad_parceiro_negocio.telefone2,
   tb_cad_parceiro_negocio.email,
   tb_cad_parceiro_negocio.data_cadastro,
   
   -- Dados de entrega diferente
  tb_ven_pedido.municipio_entrega as municipio_entrega,
  tb_ven_pedido.uf_entrega as uf_entrega,
   tb_ven_pedido.logradouro as logradouro_entrega,
   tb_ven_pedido.numero as numero_entrega,
   tb_ven_pedido.bairro as bairro_entrega,
   tb_ven_pedido.cep as cep_entrega,
   tb_ven_pedido.complemento as complemento_entrega,

   -- Dados do vendedor   
    tb_cad_vendedor.codigo as codigo_vendedor,
	tb_cad_vendedor.nome as vendedor,
    
 
	-- Dados da regra
    tb_imp_regra.codigo as codigo_regra_imposto,
    tb_imp_regra.descricao as regra_imposto,
    
    
    -- Dados da condição de pagamento
    tb_cad_condicao_pagamento.codigo_parceiro_negocio as codigo_condicao_pagamento,
    tb_cad_condicao_pagamento.descricao as condicao_pagamento,
    
    -- Dados dos itens
    tb_cad_item.codigo as codigo_item,
    tb_cad_item.codigo_item as codigo_produto_servico,
    tb_cad_item.descricao as descricao_produto,
    tb_ven_pedido_item.quantidade,
    tb_ven_pedido_item.valor_unitario
    
    
    
    from tb_ven_pedido 
    inner join tb_ven_pedido_item 
    on tb_ven_pedido_item.codigo_pedido = tb_ven_pedido.codigo 
    and tb_ven_pedido_item.codigo_empresa = tb_ven_pedido.codigo_empresa 
    inner join tb_cad_item 
    on tb_cad_item.codigo = tb_ven_pedido_item.codigo_item 
    and tb_cad_item.codigo_empresa = tb_ven_pedido_item.codigo_empresa 
    left join tb_imp_regra 
    on tb_imp_regra.codigo = case when tb_ven_pedido_item.codigo_lista_preco = 0 
								then tb_ven_pedido.codigo_lista_preco 
                                else tb_ven_pedido_item.codigo_lista_preco 
                                end
	inner join tb_cad_parceiro_negocio 
    on tb_cad_parceiro_negocio.codigo = tb_ven_pedido.codigo_cliente 
    and tb_cad_parceiro_negocio.codigo_empresa = tb_ven_pedido.codigo_empresa 
    inner join tb_stc_personalidade 
    on tb_stc_personalidade.codigo = tb_cad_parceiro_negocio.codigo_personalidade
    left join tb_stc_municipio 
    on tb_stc_municipio.descricao = tb_cad_parceiro_negocio.municipio
    and tb_stc_municipio.uf = tb_cad_parceiro_negocio.uf
    inner join tb_cad_vendedor 
    on tb_cad_vendedor.codigo = tb_ven_pedido.codigo_vendedor 
    and tb_cad_vendedor.codigo_empresa = tb_ven_pedido.codigo_empresa 
    inner join tb_cad_condicao_pagamento 
    on tb_cad_condicao_pagamento.codigo_parceiro_negocio = tb_ven_pedido.codigo_condicao_pagamento 
    and tb_cad_condicao_pagamento.codigo_empresa = tb_ven_pedido.codigo_empresa
	where tb_ven_pedido.status = 2 -- EM ANÁLISE
    ;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
