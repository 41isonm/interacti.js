*************************** 1. row ***************************
sp_select_parceiro_negocio

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_parceiro_negocio`()
BEGIN
 SELECT 
    pn.razao_social  as razao_social,
    pn.cnpj_cpf,
    pn.inscricao_estadual,
    pn.codigo_personalidade,
    pn.ativo,
    p.descricao
		FROM tb_cad_parceiro_negocio pn
		JOIN tb_stc_personalidade p ON pn.codigo_personalidade = p.codigo;


  
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
