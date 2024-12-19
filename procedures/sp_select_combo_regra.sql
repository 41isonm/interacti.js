*************************** 1. row ***************************
sp_select_combo_regra

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_combo_regra`(
IN p_codigo_empresa INT,
in p_codigo_cliente int,
in p_uf varchar(2)
)
BEGIN
		
        select codigo,descricao,uf_destino
        from tb_imp_regra
        where codigo_empresa = p_codigo_empresa
        and uf_destino = p_uf ;

END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
