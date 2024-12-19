*************************** 1. row ***************************
sp_select_combo_static_personalidade

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_combo_static_personalidade`()
BEGIN
	
    SELECT 
		codigo,
		descricao
    FROM tb_stc_personalidade
    
    
    ORDER BY descricao ASC;
    
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
