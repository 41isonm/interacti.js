*************************** 1. row ***************************
sp_update_cadastro_basico_parceiro_negocio

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_update_cadastro_basico_parceiro_negocio`(
    IN `p_codigo` BIGINT,
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
    IN `p_ativo` int, 
    IN `p_cep` VARCHAR(20), 
    IN `p_codigo_pais` INT, 
    IN `p_uf` VARCHAR(2), 
    IN `p_codigo_municipio` BIGINT(20), 
    IN `p_codigo_estado` INT, 
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
    IN `p_cep_entrega` VARCHAR(20),
    IN `p_codigo_municipio_entrega` BIGINT(20),
    IN `p_bairro_entrega` VARCHAR(150), 
    IN `p_logradouro_entrega` VARCHAR(150), 
    IN `p_numero_entrega` VARCHAR(45),
    IN `p_complemento_entrega` VARCHAR(45),
    IN `p_municipio_entrega` VARCHAR(50), 
    IN `p_uf_entrega` VARCHAR(2)
)
BEGIN
    DECLARE codigo_estado_var INT;
    DECLARE p_codigo_estado_var INT;
	DECLARE p_uf_aux INT;
    -- Obter o código do estado baseado no código do município
    SET codigo_estado_var = (SELECT codigo_estado FROM tb_stc_municipio WHERE codigo = p_codigo_municipio);
    SET p_uf_aux = ( SELECT uf FROM tb_stc_municipio WHERE codigo = p_codigo_municipio);
    
 
    -- Atualizar a tabela principal
    UPDATE tb_cad_parceiro_negocio 
		SET
			codigo_empresa = p_codigo_empresa,
			codigo_usuario = p_codigo_usuario,
			codigo_vendedor = p_codigo_vendedor,
			razao_social = p_razao_social,
			nome_fantasia = p_nome_fantasia,
			cnpj_cpf = p_cnpj_cpf,
			inscricao_estadual = p_inscricao_estadual,
			codigo_personalidade = p_codigo_personalidade_juridica,
			cliente = p_cliente,
			fornecedor = p_fornecedor,
			ativo = p_ativo,
			cep = p_cep,
			codigo_pais = p_codigo_pais,
		     uf = p_uf_aux,
		     codigo_municipio = p_codigo_municipio,
		 --   codigo_estado = codigo_estado_var,
			logradouro = p_logradouro,
			numero = p_numero,
			bairro = p_bairro,
			complemento = p_complemento,
			telefone1 = p_telefone1,
			telefone2 = p_telefone2,
			email = p_email,
			nome_contato = p_nome_contato,
			telefone_contato = p_telefone_contato,
			celular_contato = p_celular_contato,
			email_contato = p_email_contato,
			hostname = p_hostname,
			grupo_empresa = p_grupo_empresa,
			codigo_local_entrega_diferente = p_local_entrega_diferente
		WHERE codigo = p_codigo;
        

        
	UPDATE tb_cad_parceiro_negocio
		SET uf = p_uf_aux
        WHERE codigo = p_codigo;
    
    -- Lógica para dados de entrega
    IF p_local_entrega_diferente = 0 THEN
        -- Se não há entrega diferente, delete os dados da tabela de entrega
        DELETE FROM tb_cad_parceiro_negocio_local_entrega 
        WHERE codigo_parceiro_negocio = p_codigo;
    ELSE
        -- Verificar se já existe uma entrada na tabela de entrega
        SET @verifica_se_ha_linha = (SELECT COUNT(*) FROM tb_cad_parceiro_negocio_local_entrega WHERE codigo_parceiro_negocio = p_codigo);
        
        IF @verifica_se_ha_linha = 0 THEN
            -- Se não existe, inserir nova linha
            
            INSERT INTO tb_cad_parceiro_negocio_local_entrega (
                codigo_parceiro_negocio,
                codigo_empresa,
                cep,
                codigo_estado,
                codigo_municipio,
                bairro,
                logradouro,
                numero,
                complemento,
                municipio_entrega,
                uf_entrega
            ) VALUES (
                p_codigo,
                p_codigo_empresa,
                p_cep_entrega,
                codigo_estado_var,
                p_codigo_municipio_entrega,
                p_bairro_entrega,
                p_logradouro_entrega,
                p_numero_entrega,
                p_complemento_entrega,
                p_municipio_entrega,
                p_uf_entrega
            );
        ELSE
            -- Caso contrário, atualizar os dados de entrega
                SET codigo_estado_var = (SELECT codigo_estado FROM tb_stc_municipio WHERE codigo = p_codigo_municipio);

            UPDATE tb_cad_parceiro_negocio_local_entrega 
            SET
                cep = p_cep_entrega,
                codigo_estado = codigo_estado_var,
                codigo_municipio = p_codigo_municipio_entrega,
                bairro = p_bairro_entrega,
                logradouro = p_logradouro_entrega,
                numero = p_numero_entrega,
                complemento = p_complemento_entrega,
                municipio_entrega = p_municipio_entrega,
                uf_entrega = p_uf_entrega
            WHERE codigo_parceiro_negocio = p_codigo ;
        END IF;
    END IF;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
