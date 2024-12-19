*************************** 1. row ***************************
sp_select_filtro_cadastro_parceiro_negocio

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_filtro_cadastro_parceiro_negocio`(
    IN p_codigo_empresa INT, 
    IN p_codigo_vendedor INT,
    IN p_razao_social VARCHAR(150), 
    IN p_cnpj_cpf VARCHAR(50))
BEGIN
    SELECT DISTINCT 
        tb_cad_parceiro_negocio.codigo AS codigo,
        IFNULL(tb_cad_parceiro_negocio.codigo_empresa, 0) AS codigo_empresa,
        IFNULL(emp.razao_social, '-') AS descricao_empresa, 
        IFNULL(tb_cad_parceiro_negocio.cnpj_cpf, '-') AS cnpj_cpf,
        IFNULL(tb_cad_parceiro_negocio.razao_social, '-') AS razao_social,
        IFNULL(tb_cad_parceiro_negocio.nome_fantasia, '-') AS nome_fantasia,
        IFNULL(tb_cad_parceiro_negocio.inscricao_estadual, '-') AS inscricao_estadual,
        IFNULL(tb_cad_parceiro_negocio.codigo_personalidade, 0) AS codigo_personalidade,
        IFNULL(tb_stc_personalidade.descricao, '') AS descricao_personalidade,
        IFNULL(tb_cad_parceiro_negocio.cep, '-') AS cep,
        IFNULL(tb_cad_parceiro_negocio.numero, '-') AS numero,
        IFNULL(tb_cad_parceiro_negocio.bairro, '-') AS bairro,
        IFNULL(tb_cad_parceiro_negocio.complemento, '-') AS complemento,
        IFNULL(tb_cad_parceiro_negocio.logradouro, '-') AS logradouro,
        IFNULL(tb_cad_parceiro_negocio.telefone1, '-') AS telefone1,
        IFNULL(tb_cad_parceiro_negocio.telefone2, '-') AS telefone2,
        IFNULL(tb_cad_parceiro_negocio.email, '-') AS email,
        IFNULL(tb_cad_parceiro_negocio.codigo_municipio, 0) AS codigo_municipio,
        IFNULL(tb_cad_parceiro_negocio.codigo_estado, 0) AS codigo_estado,
        IFNULL(tb_stc_municipio.uf, '-') AS descricao_uf,
        IFNULL(tb_stc_municipio.descricao, '-') AS municipio,
        IFNULL(tb_cad_parceiro_negocio.ativo, 0) AS ativo,
        tb_cad_parceiro_negocio.codigo_local_entrega_diferente AS codigo_local_entrega_diferente,
        CASE
            WHEN IFNULL(tb_cad_parceiro_negocio.ativo, 0) = 0 THEN 0
            ELSE 1
        END AS ativo_status,
        CASE
            WHEN IFNULL(tb_cad_parceiro_negocio.pre_cadastro, 0) = 0 THEN 0
            ELSE 1
        END AS pre_cadastro,
        CASE
            WHEN IFNULL(tb_cad_parceiro_negocio.pre_cadastro, 0) = 1 THEN 'NÃO'
            ELSE 'SIM'
        END AS aprovado,
        '2' AS status,
        IFNULL(tb_cad_parceiro_negocio.justificativa, '') AS justificativa,
        IFNULL(tb_cad_parceiro_negocio.codigo_local_entrega_diferente, 0) AS codigo_parceiro_negocio_local_entrega,
        IFNULL(tb_cad_parceiro_negocio_local_entrega.cep, '-') AS cep_entrega,
        IFNULL(tb_cad_parceiro_negocio_local_entrega.logradouro, '-') AS logradouro_entrega,
        IFNULL(tb_cad_parceiro_negocio_local_entrega.numero, '-') AS numero_entrega,
        IFNULL(tb_cad_parceiro_negocio_local_entrega.bairro, '-') AS bairro_entrega,
        IFNULL(tb_cad_parceiro_negocio_local_entrega.municipio_entrega, '-') AS municipio_entrega,
        IFNULL(tb_cad_parceiro_negocio_local_entrega.uf_entrega, '-') AS uf_entrega,
        IFNULL(tb_cad_parceiro_negocio_local_entrega.codigo_municipio, '-') AS codigo_municipio_entrega,
        IFNULL(tb_cad_parceiro_negocio_local_entrega.codigo_estado, '-') AS codigo_estado_entrega,
        IFNULL(tb_cad_parceiro_negocio_local_entrega.complemento, '-') AS complemento_entrega
    FROM 
        tb_cad_parceiro_negocio
        LEFT JOIN tb_cad_empresa emp ON emp.codigo = tb_cad_parceiro_negocio.codigo_empresa
        LEFT JOIN tb_stc_personalidade ON tb_stc_personalidade.codigo = tb_cad_parceiro_negocio.codigo_personalidade
        LEFT JOIN tb_stc_municipio ON tb_stc_municipio.codigo = tb_cad_parceiro_negocio.codigo_municipio
        LEFT JOIN tb_cad_parceiro_negocio_local_entrega ON tb_cad_parceiro_negocio.codigo = tb_cad_parceiro_negocio_local_entrega.codigo_parceiro_negocio
    WHERE
        (p_codigo_empresa IS NULL OR tb_cad_parceiro_negocio.codigo_empresa = p_codigo_empresa)
        AND (p_codigo_vendedor IS NULL OR tb_cad_parceiro_negocio.codigo_vendedor = p_codigo_vendedor)
        AND (p_razao_social IS NULL OR tb_cad_parceiro_negocio.razao_social LIKE CONCAT('%', p_razao_social, '%'))
        AND (p_cnpj_cpf IS NULL OR tb_cad_parceiro_negocio.cnpj_cpf = p_cnpj_cpf)
    ORDER BY 
        tb_cad_parceiro_negocio.razao_social ASC;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
