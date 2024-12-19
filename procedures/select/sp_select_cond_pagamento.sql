*************************** 1. row ***************************
sp_select_cond_pagamento

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_cond_pagamento`(IN p_codigo_empresa INT)
BEGIN
    SELECT codigo_parceiro_negocio,descricao
    FROM tb_cad_condicao_pagamento
    WHERE codigo_empresa = p_codigo_empresa
    order by descricao;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
