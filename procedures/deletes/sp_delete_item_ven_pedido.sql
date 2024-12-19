*************************** 1. row ***************************
sp_delete_item_ven_pedido

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_delete_item_ven_pedido`(
    IN p_id INT
)
BEGIN
    -- Deletar o registro da tabela tb_ven_pedido_item_resultado com base no ID fornecido
	-- DELETE FROM tb_ven_pedido WHERE tb_ven_pedido.numero_pedido = numero_pedido; --
    DELETE FROM tb_ven_pedido_item WHERE codigo_pedido = p_id;

END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
