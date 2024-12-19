*************************** 1. row ***************************
sp_select_combo_lista_preco

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_combo_lista_preco`(
IN p_seller_code INT
)
BEGIN
	SELECT DISTINCT
		lista_preco.codigo AS id,
		FN_RETIRA_ACENTO(lista_preco.descricao) AS description
	FROM tb_cad_lista_preco AS lista_preco
	LEFT JOIN tb_cad_lista_preco_vendedor AS vendedor
	ON vendedor.codigo_lista = lista_preco.codigo
	WHERE lista_preco.ativo = 1
    AND (vendedor.codigo_vendedor = p_seller_code OR p_seller_code = 2);

END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
