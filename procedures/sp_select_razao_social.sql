*************************** 1. row ***************************
sp_select_razao_social

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_razao_social`()
BEGIN
	SELECT codigo,codigo_empresa,codigo_vendedor,razao_social FROM tb_cad_parceiro_negocio;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
