*************************** 1. row ***************************
sp_delete_venda_pedido_item

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_delete_venda_pedido_item`(
    IN `p_codigo_empresa` INT,
    IN `p_codigo_item` INT,
    IN `p_numero_pedido` INT
)
BEGIN

    DELETE FROM tb_ven_pedido_item
    WHERE codigo_empresa = p_codigo_empresa 
      AND codigo_item = p_codigo_item;
    
 

END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
