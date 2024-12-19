*************************** 1. row ***************************
sp_insert_tb_cad_parceiro_negocio_local_entrega

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_insert_tb_cad_parceiro_negocio_local_entrega`(
    IN `p_codigo_empresa` INT, 
    IN `p_cep_entrega` VARCHAR(50), 
    IN `p_bairro` VARCHAR(50),
    IN `p_logradouro` VARCHAR(150),
    IN `p_numero` INT,
    IN `p_complemento` VARCHAR(150),
    
    IN `p_municipio_entrega` VARCHAR(150),
    
    IN `p_uf_entrega` VARCHAR(150)
)
BEGIN
    DECLARE codigo_parceiro INT;

    
    
   SET @p_codigo = IFNULL((SELECT MAX(codigo) FROM tb_cad_parceiro_negocio), 1) ;
    INSERT INTO tb_cad_parceiro_negocio_local_entrega(
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
		@p_codigo,
        p_codigo_empresa,
        p_cep_entrega,
        1,  
        1,  
        p_bairro,
        p_logradouro,
        p_numero,
        p_complemento,
        p_municipio_entrega,
        p_uf_entrega
        
    );
    
   

    

END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
