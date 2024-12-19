*************************** 1. row ***************************
updateCodigoItemColuna

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `updateCodigoItemColuna`()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_value INT DEFAULT 100;
    
    WHILE i <= max_value DO
        UPDATE tb_cad_item 
        SET codigo_item_coluna = i
        WHERE codigo_empresa = 1 
          AND codigo_tipo_item = 1
          AND codigo_item_coluna IS NULL;
        
        SET i = i + 1;
    END WHILE;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
