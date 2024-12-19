*************************** 1. row ***************************
sp_select_ven_pedido_email_analise

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_select_ven_pedido_email_analise`(
	p_codigo_vendedor int,
    p_codigo_pedido int
)
BEGIN

	SELECT
		id as codigo,
        codigo_pedido as codigo_pedido,
        codigo_vendedor as codigo_vendedor,
        nome_vendedor as nome_vendedor,
        email_responsavel as email_responsavel
    FROM
		tb_ven_pedido_email_analise
        where codigo_vendedor = p_codigo_vendedor and codigo_pedido = p_codigo_pedido;

END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
