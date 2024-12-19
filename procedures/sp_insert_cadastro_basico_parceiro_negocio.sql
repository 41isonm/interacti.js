*************************** 1. row ***************************
sp_insert_cadastro_basico_parceiro_negocio

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_insert_cadastro_basico_parceiro_negocio`(
    IN `p_codigo_empresa` INT, 
    IN `p_codigo_usuario` INT, 
    IN `p_codigo_vendedor` INT, 
    IN `p_razao_social` VARCHAR(150), 
    IN `p_nome_fantasia` VARCHAR(150), 
    IN `p_cnpj_cpf` VARCHAR(20), 
    IN `p_inscricao_estadual` VARCHAR(20), 
    IN `p_codigo_personalidade_juridica` INT, 
    IN `p_cliente` INT, 
    IN `p_fornecedor` INT, 
    IN `p_ativo` INT, 
    IN `p_cep` VARCHAR(20), 
    IN `p_codigo_pais` INT, 
    IN `p_uf` VARCHAR(2), 
    IN `p_municipio` VARCHAR(150),
    IN `p_codigo_municipio` INT, 
    IN `p_logradouro` VARCHAR(150), 
    IN `p_numero` VARCHAR(50), 
    IN `p_bairro` VARCHAR(150), 
    IN `p_complemento` VARCHAR(150), 
    IN `p_telefone1` VARCHAR(50), 
    IN `p_telefone2` VARCHAR(50), 
    IN `p_email` VARCHAR(150), 
    IN `p_nome_contato` VARCHAR(150), 
    IN `p_telefone_contato` VARCHAR(50), 
    IN `p_celular_contato` VARCHAR(50), 
    IN `p_email_contato` VARCHAR(150), 
    IN `p_hostname` VARCHAR(150), 
    IN `p_grupo_empresa` VARCHAR(150), 
    IN `p_local_entrega_diferente` INT, 
    IN `p_cep_entrega` VARCHAR(45), 
    IN `p_uf_entrega` VARCHAR(2),  
    IN `p_codigo_municipio_entrega` INT, 
    IN `p_bairro_entrega` VARCHAR(150), 
    IN `p_logradouro_entrega` VARCHAR(250), 
    IN `p_numero_entrega` VARCHAR(100), 
    IN `p_complemento_entrega` VARCHAR(250),
    IN `p_municipio_entrega` VARCHAR(50),

    OUT `p_codigo` INT 
)
BEGIN
    DECLARE codigo_parceiro INT;
    DECLARE p_codigo_parceiro_negocio INT;

	IF p_uf IS NULL THEN
		SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'UF nao definida';
	END IF;

    IF EXISTS (SELECT 1 FROM tb_cad_parceiro_negocio WHERE cnpj_cpf = p_cnpj_cpf) THEN
		SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT = 'Duplicado CNPJ/CPF detectado:remova inconsistencia';
    ELSE
        SET p_codigo = IFNULL((SELECT MAX(codigo) FROM tb_cad_parceiro_negocio),0) + 1;
        SET p_codigo_parceiro_negocio = p_codigo;


        INSERT INTO tb_cad_parceiro_negocio (
            codigo,
            codigo_empresa,
            cliente,
            fornecedor,
            codigo_personalidade,
            cnpj_cpf,
            razao_social,
            nome_fantasia,
            ativo,
            codigo_local_entrega_diferente,
            inscricao_estadual,
            codigo_pais,
            codigo_municipio,
            logradouro,
            numero,
            bairro,
            complemento,
            cep,
            telefone1,
            telefone2,
            email,
            data_cadastro,
            codigo_usuario,
            nome_contato,
            telefone_contato,
            celular_contato,
            email_contato,
            hostname,
            pre_cadastro,
            codigo_vendedor,
            grupo_empresa,
            uf,
            municipio
        ) VALUES (
            p_codigo,
            p_codigo_empresa,
            p_cliente,
            p_fornecedor,
            p_codigo_personalidade_juridica,
            p_cnpj_cpf,  
            p_razao_social,
            p_nome_fantasia,
            p_ativo,
            p_local_entrega_diferente,
            p_inscricao_estadual,
            p_codigo_pais,
            p_codigo_municipio,
            p_logradouro,
            p_numero,
            p_bairro,
            p_complemento,
            p_cep,
            p_telefone1,
            p_telefone2,
            p_email,
            CURDATE(),
            p_codigo_usuario,
            p_nome_contato,
            p_telefone_contato,
            p_celular_contato,
            p_email_contato,
            p_hostname,
            1,  
            p_codigo_vendedor,
            p_grupo_empresa,
            p_uf,
            p_municipio
        );

    

    END IF;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
