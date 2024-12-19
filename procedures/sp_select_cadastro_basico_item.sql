*************************** 1. row ***************************
sp_select_cadastro_basico_item

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_cadastro_basico_item`(
    IN p_codigo_empresa INT
)
BEGIN
    SELECT 
		codigo,
        descricao

    FROM tb_cad_item
    WHERE codigo_empresa = p_codigo_empresa 
   
    ORDER BY descricao;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
