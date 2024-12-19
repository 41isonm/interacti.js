*************************** 1. row ***************************
sp_insert_user

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_insert_user`(
IN p_name VARCHAR(150),
IN p_username VARCHAR(150),
IN p_email VARCHAR(150),

IN p_password VARCHAR(150),
IN p_profile_id BIGINT(20),
IN p_company_id BIGINT(20),
IN p_seller_id BIGINT(20),
IN p_createdAt datetime
)
BEGIN
	INSERT INTO tb_cad_usuario(
		nome,
        usuario,
        senha,
        codigo_perfil,
        codigo_empresa,
        codigo_vendedor,
        createdAt,
        codigo_language,
        ativo,
        email
    )
    VALUES(
		p_name,
        p_username,
        p_password,
        p_profile_id,
        p_company_id,
        p_seller_id,
        p_createdAt,
        'PT',
        1,
        p_email
    );
    
	UPDATE tb_cad_usuario 
	SET codigo = p_seller_id 
	WHERE codigo = (SELECT MAX(codigo) FROM tb_cad_usuario WHERE codigo_vendedor = p_seller_id AND codigo_empresa = 1);

    
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
