*************************** 1. row ***************************
sp_select_combo_empresa

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_combo_empresa`()
BEGIN
	select 
    codigo,
    ifnull(razao_social,'-') as descricao
    
    from tb_cad_empresa where codigo = 1;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
