*************************** 1. row ***************************
sp_select_cadastro_basico_parceiro_negocio

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_cadastro_basico_parceiro_negocio`(
    IN p_codigo_empresa INT, 
    IN p_codigo_vendedor INT,
    IN p_razao_social VARCHAR(150), 
    IN p_cnpj_cpf VARCHAR(50))
BEGIN
    SELECT DISTINCT 
        tb_cad_parceiro_negocio.codigo as codigo,
        IFNULL(tb_cad_parceiro_negocio.codigo_empresa, 0) as codigo_empresa,
        IFNULL(emp.razao_social, '-') as descricao_empresa, 
        IFNULL(tb_cad_parceiro_negocio.cnpj_cpf, '-') as cnpj_cpf,
        IFNULL(tb_cad_parceiro_negocio.razao_social, '-') as razao_social,
        IFNULL(tb_cad_parceiro_negocio.nome_fantasia, '-') as nome_fantasia,
        IFNULL(tb_cad_parceiro_negocio.inscricao_estadual, '-') as inscricao_estadual,
        IFNULL(tb_cad_parceiro_negocio.codigo_personalidade, 0) as codigo_personalidade,
        IFNULL(tb_stc_personalidade.descricao, '') as descricao_personalidade,
        IFNULL(tb_cad_parceiro_negocio.cep, '-') as cep,
        IFNULL(tb_cad_parceiro_negocio.numero, '-') as numero,
        IFNULL(tb_cad_parceiro_negocio.bairro, '-') as bairro,
        IFNULL(tb_cad_parceiro_negocio.complemento, '-') as complemento,
        IFNULL(tb_cad_parceiro_negocio.logradouro, '-') as logradouro,
        IFNULL(tb_cad_parceiro_negocio.telefone1, '-') as telefone1,
        IFNULL(tb_cad_parceiro_negocio.telefone2, '-') as telefone2,
        IFNULL(tb_cad_parceiro_negocio.email, '-') as email,
        IFNULL(tb_cad_parceiro_negocio.codigo_municipio, 0) as codigo_municipio,
        IFNULL(tb_cad_parceiro_negocio.codigo_estado, 0) as codigo_estado,
        IFNULL(tb_stc_municipio.uf, '-') as descricao_uf,
        IFNULL(tb_stc_municipio.descricao, '-') as municipio,
        
        IFNULL(tb_cad_parceiro_negocio.ativo, 0) as ativo,
        tb_cad_parceiro_negocio.codigo_local_entrega_diferente as codigo_local_entrega_diferente,
        CASE
            WHEN IFNULL(tb_cad_parceiro_negocio.ativo, 0) = 0 THEN 0
            ELSE 1
        END as ativo_status,
        CASE
            WHEN IFNULL(tb_cad_parceiro_negocio.pre_cadastro, 0) = 0 THEN 0
            ELSE 1
        END as pre_cadastro,
        CASE
            WHEN IFNULL(tb_cad_parceiro_negocio.pre_cadastro, 0) = 1 THEN 'NÃO'
            ELSE 'SIM'
        END as aprovado,
        '2' as status,
        IFNULL(tb_cad_parceiro_negocio.justificativa, '') as justificativa,
        IFNULL(tb_cad_parceiro_negocio.codigo_local_entrega_diferente, 0) as codigo_parceiro_negocio_local_entrega,
        IFNULL(tb_cad_parceiro_negocio_local_entrega.cep, '-') as cep_entrega,
        IFNULL(tb_cad_parceiro_negocio_local_entrega.logradouro, '-') as logradouro_entrega,
        IFNULL(tb_cad_parceiro_negocio_local_entrega.numero, '-') as numero_entrega,
        IFNULL(tb_cad_parceiro_negocio_local_entrega.bairro, '-') as bairro_entrega,
        IFNULL(tb_cad_parceiro_negocio_local_entrega.municipio_entrega, '-') as municipio_entrega,
		IFNULL(tb_cad_parceiro_negocio_local_entrega.uf_entrega, '-') as uf_entrega,

        IFNULL(tb_cad_parceiro_negocio_local_entrega.codigo_municipio, '-') as codigo_municipio_entrega,
		IFNULL(tb_cad_parceiro_negocio_local_entrega.codigo_estado, '-') as codigo_estado_entrega,

        IFNULL(tb_cad_parceiro_negocio_local_entrega.complemento, '-') as complemento_entrega
    FROM 
        tb_cad_parceiro_negocio
        LEFT JOIN tb_cad_empresa emp ON emp.codigo = tb_cad_parceiro_negocio.codigo_empresa
        LEFT JOIN tb_stc_personalidade ON tb_stc_personalidade.codigo = tb_cad_parceiro_negocio.codigo_personalidade
        LEFT JOIN tb_stc_municipio ON tb_stc_municipio.codigo = tb_cad_parceiro_negocio.codigo_municipio
        LEFT JOIN tb_cad_parceiro_negocio_local_entrega ON tb_cad_parceiro_negocio.codigo = tb_cad_parceiro_negocio_local_entrega.codigo_parceiro_negocio
    WHERE
        tb_cad_parceiro_negocio.codigo_vendedor = p_codigo_vendedor 
    
    ORDER BY 
        tb_cad_parceiro_negocio.razao_social ASC;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
