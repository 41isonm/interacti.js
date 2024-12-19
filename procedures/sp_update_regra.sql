*************************** 1. row ***************************
sp_update_regra

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_update_regra`(
	IN `p_numero_pedido` INT, 
    IN `p_codigo_empresa` INT,
    IN `p_codigo_item` INT,
	IN `p_quantidade` INT,
    IN `p_valor_unitario` DOUBLE,
    IN `p_codigo_lista_preco` INT)
BEGIN
	update tb_ven_pedido_item set codigo_regra_imposto = p_codigo_lista_preco
    where codigo_pedido = p_numero_pedido and 
    codigo_empresa = p_codigo_empresa and 
    codigo_item = p_codigo_item and 
   
   
    quantidade = p_quantidade and 
     valor_unitario = p_valor_unitario;

END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
