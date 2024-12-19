*************************** 1. row ***************************
sp_select_user

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_user`(
IN p_id BIGINT(20)
)
BEGIN
	SELECT
		user.codigo AS id,
		user.nome AS name,
		user.usuario AS username,
        user.email AS email,
		profile.descricao AS profile,
		user.codigo_perfil AS profile_id,
		company.razao_social AS company,
		user.codigo_empresa AS company_id,
		IFNULL(seller.nome, '') AS seller,
		IFNULL(user.codigo_vendedor, 0) AS seller_id,
        user.codigo_language AS language_id,
		DATE_FORMAT(user.createdAt, '%d/%m/%Y %H:%i') AS createdAt,
		IFNULL(DATE_FORMAT(user.updatedAt, '%d/%m/%Y %H:%i'), '') AS updatedAt,
		user.ativo AS active
	FROM tb_cad_usuario AS user
	LEFT JOIN tb_stc_perfil AS profile ON
	profile.codigo = user.codigo_perfil
	LEFT JOIN tb_cad_empresa AS company ON
	company.codigo = user.codigo_empresa
	LEFT JOIN tb_cad_vendedor AS seller ON
	seller.codigo = user.codigo_vendedor
    WHERE user.codigo = p_id;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
