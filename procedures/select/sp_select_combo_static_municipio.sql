*************************** 1. row ***************************
sp_select_combo_static_municipio

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_combo_static_municipio`(in p_uf varchar(120))
BEGIN

SELECT 
	tb_stc_municipio .codigo AS id,
    e.codigo as state_code ,
	tb_stc_municipio.descricao AS description,
    e.uf as state
FROM 
    tb_stc_municipio 
JOIN 
    tb_stc_estado e ON tb_stc_municipio.codigo_estado = e.codigo
    where    tb_stc_municipio.codigo_estado  =   tb_stc_municipio.codigo_estado
    and e.uf = p_uf;
	
    
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
