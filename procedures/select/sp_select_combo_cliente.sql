*************************** 1. row ***************************
sp_select_combo_cliente

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_combo_cliente`(in p_codigo_empresa int, in p_codigo_usuario int)
BEGIN
    SELECT 
        tb_cad_parceiro_negocio.codigo AS codigo,  -- Qualifique a coluna 'codigo'
        CONCAT(razao_social, ' (', nome_fantasia, ') - ', cnpj_cpf) AS razao_social,
        ifnull(uf,'-') as uf
    FROM tb_cad_parceiro_negocio
    INNER JOIN tb_cad_usuario AS usuario ON usuario.codigo = p_codigo_usuario
    WHERE tb_cad_parceiro_negocio.codigo_usuario = p_codigo_usuario  -- Qualifique aqui também
    AND tb_cad_parceiro_negocio.codigo_empresa = p_codigo_empresa 
    AND usuario.codigo_vendedor = tb_cad_parceiro_negocio.codigo_vendedor
    AND tb_cad_parceiro_negocio.ativo = 1;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
