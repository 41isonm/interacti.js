*************************** 1. row ***************************
sp_insert_ven_pedido_email_analise

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_insert_ven_pedido_email_analise`(
    p_codigo_pedido INT,
    p_codigo_vendedor INT,
    p_email_responsavel VARCHAR(100),
    p_codigo_empresa INT
)
BEGIN
    DECLARE nome_vendedor VARCHAR(50);

    SET nome_vendedor = (SELECT nome FROM tb_cad_vendedor WHERE codigo = p_codigo_vendedor);

    INSERT INTO tb_ven_pedido_email_analise (
        codigo_pedido,
        codigo_vendedor,
        nome_vendedor,
        email_responsavel,
        codigo_empresa 
    )
    VALUES (
        p_codigo_pedido,
        p_codigo_vendedor,
        nome_vendedor,
        p_email_responsavel,
        p_codigo_empresa 
    );
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
