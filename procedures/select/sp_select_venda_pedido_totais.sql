*************************** 1. row ***************************
sp_select_venda_pedido_totais

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_venda_pedido_totais`(IN p_codigo_empresa INT, 
																				   in p_codigo_pedido bigint, 
                                                                                   in p_codigo_regra int, 
                                                                                   in p_desconto bit)
BEGIN
   
   SELECT 
   sum(valor_unitario * quantidade) as valor_total,
   sum(valor_unitario * quantidade)  *  case when p_desconto = 1 then 0.975 else 1 end  as valor_final,
   0 as valor_imposto,
   sum(valor_unitario * quantidade)  * case when p_desconto = 1 then 2.5 else 1 end as valor_desconto
   FROM tb_ven_pedido
   left join tb_ven_pedido_item 
   on tb_ven_pedido.codigo = tb_ven_pedido_item.codigo_pedido 
   and tb_ven_pedido.codigo_empresa = tb_ven_pedido_item.codigo_empresa 
   where tb_ven_pedido.codigo = p_codigo_pedido 
   and tb_ven_pedido.codigo_empresa = p_codigo_empresa;
   
   
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
