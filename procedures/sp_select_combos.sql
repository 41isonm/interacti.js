*************************** 1. row ***************************
sp_select_combos

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_combos`(
    IN p_codigo_empresa INT,
    IN p_codigo_usuario INT,
    IN p_codigo_cliente INT,
    IN p_uf VARCHAR(2),
    IN p_seller_code INT
)
BEGIN
    
    SELECT 
        tb_cad_parceiro_negocio.codigo AS codigo, 
        CONCAT(tb_cad_parceiro_negocio.razao_social, ' (', tb_cad_parceiro_negocio.nome_fantasia, ') - ', tb_cad_parceiro_negocio.cnpj_cpf) AS razao_social,
        tb_cad_parceiro_negocio.uf AS uf,
        tb_cad_condicao_pagamento.codigo_parceiro_negocio AS codigo_parceiro_negocio,
        tb_cad_condicao_pagamento.descricao AS condicao_pagamento_descricao
    FROM tb_cad_parceiro_negocio
    LEFT JOIN tb_cad_condicao_pagamento 
        ON tb_cad_condicao_pagamento.codigo_empresa = p_codigo_empresa
        AND tb_cad_condicao_pagamento.codigo_parceiro_negocio = tb_cad_parceiro_negocio.codigo
    WHERE tb_cad_parceiro_negocio.codigo_usuario = p_codigo_usuario
      AND tb_cad_parceiro_negocio.codigo_empresa = p_codigo_empresa 
      AND tb_cad_parceiro_negocio.ativo = 1
    ORDER BY tb_cad_condicao_pagamento.descricao;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
