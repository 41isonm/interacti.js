*************************** 1. row ***************************
sp_select_combo_regra_imposto

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_combo_regra_imposto`(
IN p_codigo_regra INT
)
BEGIN
		
        select 
			ifnull(aliquota_icms_ipi,0) as aliquota_icms_ipi,
            ifnull(aliquota_icms_st,0) as aliquota_icms_st,
            ifnull(sum(aliquota_icms_ipi + aliquota_icms_st),0) as total_imposto
        from tb_imp_regra
        where codigo = p_codigo_regra ;

END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
