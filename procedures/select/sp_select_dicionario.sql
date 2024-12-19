*************************** 1. row ***************************
sp_select_dicionario

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_dicionario`()
BEGIN
	select
		*
	from 
		tb_tmp_dicionario;

END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
