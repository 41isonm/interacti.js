*************************** 1. row ***************************
sp_update_user

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_update_user`(
IN p_id BIGINT(20),
IN p_name VARCHAR(150),
IN p_username VARCHAR(150),
IN p_email VARCHAR(150),
IN p_password VARCHAR(150),
IN p_profile_id BIGINT(20),
IN p_company_id BIGINT(20),
IN p_seller_id BIGINT(20),
IN p_updatedAt datetime,
IN p_active BIT
)
BEGIN
	UPDATE tb_cad_usuario
		SET 
        email = p_email,
		senha = p_password,
		updatedAt = p_updatedAt,
		ativo = p_active
    WHERE codigo = p_id;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
