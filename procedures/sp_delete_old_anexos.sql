*************************** 1. row ***************************
sp_delete_old_anexos

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_delete_old_anexos`(
    IN p_codigo_vendedor INT,
    IN p_codigo_pedido INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Erro ao excluir o documento' AS mensagem;
    END;

    -- Inicia a transação
    START TRANSACTION;

    -- Apaga os anexos que foram inseridos há mais de 30 dias e ja foram enviados
    DELETE FROM tb_ven_pedido_anexo 
    WHERE data_insercao < NOW() - INTERVAL 30 DAY 
      AND codigo_vendedor = p_codigo_vendedor
      AND codigo_pedido = p_codigo_pedido
      AND enviado = true;

    -- Confirma a transação
    COMMIT;

    SELECT 'Documentos excluídos com sucesso' AS mensagem;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
