*************************** 1. row ***************************
sp_delete_cad_parceiro_negocio

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_delete_cad_parceiro_negocio`(
    IN `p_codigo` INT
)
BEGIN
    DELETE FROM tb_cad_parceiro_negocio_local_entrega WHERE  codigo_parceiro_negocio = p_codigo;

    DELETE FROM tb_cad_parceiro_negocio WHERE p_codigo = codigo;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
