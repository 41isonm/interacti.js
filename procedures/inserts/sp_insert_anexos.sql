*************************** 1. row ***************************
sp_insert_anexos

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_insert_anexos`(
    IN p_codigo_vendedor INT,
    IN p_codigo_pedido INT,
    IN p_nome_arquivo VARCHAR(255),
    IN p_tipo_arquivo VARCHAR(255),
    IN p_conteudo_arquivo LONGTEXT
)
BEGIN
    -- START TRANSACTION;

    INSERT INTO tb_ven_pedido_anexo
        (codigo_vendedor, 
        numero_pedido, 
        nome_arquivo, 
        tipo_arquivo, 
        conteudo_arquivo, 
        enviado)
    VALUES (p_codigo_vendedor, 
            p_codigo_pedido, 
            p_nome_arquivo, 
            p_tipo_arquivo, 
            p_conteudo_arquivo, 
            FALSE);

    UPDATE tb_ven_pedido_anexo 
    SET enviado = 1 
    WHERE codigo_vendedor = p_codigo_vendedor 
    AND numero_pedido = p_codigo_pedido;

    -- COMMIT;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
