*************************** 1. row ***************************
sp_validate_login

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_validate_login`(
IN p_email VARCHAR(150)
)
BEGIN
	SELECT
		user.codigo AS id,
        user.nome AS name,
        user.usuario AS username,
		user.email AS email,

        user.senha AS password,
        company.razao_social AS company,
        user.codigo_empresa AS company_id,
		IFNULL(seller.nome, '') AS seller,
		IFNULL(user.codigo_vendedor, 0) AS seller_id,
        profile.descricao AS profile,
        user.codigo_perfil AS profile_id,
        user.codigo_language AS language_id,
        user.ativo AS active
    FROM tb_cad_usuario AS user
	LEFT JOIN tb_stc_perfil AS profile ON
	profile.codigo = user.codigo_perfil
	LEFT JOIN tb_cad_empresa AS company ON
	company.codigo = user.codigo_empresa
	LEFT JOIN tb_cad_vendedor AS seller ON
	seller.codigo = user.codigo_vendedor
    WHERE user.email = p_email;
    
    SELECT
		id,
        caption,
        type,
        icon,
        link,
        children,
        `index`
    FROM tb_cad_menu
    WHERE active = 1
    ORDER BY `index` ASC;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
