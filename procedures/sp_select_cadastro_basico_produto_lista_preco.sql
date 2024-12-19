*************************** 1. row ***************************
sp_select_cadastro_basico_produto_lista_preco

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_cadastro_basico_produto_lista_preco`(
IN `p_codigo_empresa` INT, 
IN `p_codigo_regra` INT)
BEGIN
   SELECT
	 0 as codigo_lista,
	 tb_cad_item.codigo,
	tb_cad_item.descricao as descricao, 
     tb_cad_item.descricao as produto,

     0 as valor_unitario,
     0 as quantidade,
     
     tb_cad_unidade_medida.sigla as unidade_medida,
	tb_cad_unidade_medida.codigo as codigo_unidade_medida,
    tb_cad_item.codigo_item as codigo_item,
    
    tb_stc_grupo.codigo as codigo_grupo_item,
     tb_cad_unidade_medida.sigla as grupo_item,
    IFNULL(tb_stc_grupo.ordem,999) as ordem_grupo,
    tb_cad_item.ordem_item
FROM tb_cad_item
     LEFT JOIN
     tb_cad_unidade_medida ON
     tb_cad_unidade_medida.codigo = tb_cad_item.codigo_unidade_medida_venda
     LEFT JOIN
     tb_stc_grupo ON
     tb_stc_grupo.codigo = tb_cad_item.codigo_grupo
     

WHERE    tb_cad_item.ativo = 1
	ORDER BY 
		ifnull(tb_stc_grupo.ordem, tb_cad_item.ordem_item) asc,
	    tb_cad_item.codigo ASC, 
        tb_cad_item.codigo_item_coluna;
 
    
   


END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
