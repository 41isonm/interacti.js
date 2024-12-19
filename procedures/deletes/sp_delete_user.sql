*************************** 1. row ***************************
sp_delete_user

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_delete_user`(
IN p_id BIGINT(20)
)
BEGIN
	DELETE FROM tb_cad_usuario
    WHERE codigo = p_id;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
