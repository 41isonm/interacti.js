*************************** 1. row ***************************
sp_delete_venda_pedido

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_delete_venda_pedido`(
 IN `p_codigo_pedido` BIGINT,
 IN `p_codigo_empresa` INT)
BEGIN

	
--    DELETE FROM tb_ven_pedido WHERE codigo = p_codigo_pedido AND codigo_empresa = p_codigo_empresa;
	  update 
		tb_ven_pedido set status = 9
        WHERE codigo = p_codigo_pedido AND codigo_empresa = p_codigo_empresa; 
  
   


END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
