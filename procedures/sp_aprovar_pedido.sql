*************************** 1. row ***************************
sp_aprovar_pedido

CREATE DEFINER=`cabr_pdv`@`%` PROCEDURE `sp_aprovar_pedido`(
    IN p_aprovar_pedido INT,
    IN p_codigo_empresa INT,
    IN p_codigo_pedido INT,
    IN p_codigo_vendedor INT
)
BEGIN
    DECLARE html LONGTEXT; 
    DECLARE titulo_email VARCHAR(500);
    DECLARE tipo_arquivo VARCHAR(255);
    DECLARE razao_social VARCHAR(550);
    DECLARE cnpj_cpf VARCHAR(20);
    DECLARE condicao_pagamento VARCHAR(50);
    DECLARE valor_final DECIMAL(15,2);
    DECLARE nome_vendedor VARCHAR(60);
    DECLARE contador INT;
    DECLARE unidade_medida VARCHAR(20);

	

    CREATE TEMPORARY TABLE IF NOT EXISTS temp_anexos (
        nome_arquivo VARCHAR(500),
        conteudo_base64 LONGTEXT
    );

    SET tipo_arquivo = (SELECT tipo_arquivo FROM tb_ven_pedido_anexo WHERE numero_pedido = p_codigo_pedido LIMIT 1);

    SET razao_social = COALESCE(
        (
            SELECT GROUP_CONCAT(tb_cad_parceiro_negocio.razao_social SEPARATOR ', ')
            FROM tb_ven_pedido 
            JOIN tb_cad_parceiro_negocio ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
            WHERE tb_ven_pedido.numero_pedido = p_codigo_pedido
        ),
        'Sem razão social informada'
    );

    SET cnpj_cpf = COALESCE(
        (
            SELECT GROUP_CONCAT(tb_cad_parceiro_negocio.cnpj_cpf SEPARATOR ', ')
            FROM tb_ven_pedido 
            JOIN tb_cad_parceiro_negocio ON tb_ven_pedido.codigo_cliente = tb_cad_parceiro_negocio.codigo 
            WHERE tb_ven_pedido.numero_pedido = p_codigo_pedido
        ),
        'Sem CNPJ/CPF informado'
    );

    SET condicao_pagamento = COALESCE(
        (SELECT descricao 
         FROM tb_cad_condicao_pagamento
         JOIN tb_ven_pedido ON tb_cad_condicao_pagamento.codigo_parceiro_negocio = tb_ven_pedido.codigo_condicao_pagamento
         WHERE tb_ven_pedido.codigo = p_codigo_pedido
         LIMIT 1),
        'Sem condição de pagamento informada'
    );

    SET valor_final = (SELECT valor_total FROM tb_ven_pedido WHERE codigo = p_codigo_pedido AND codigo_vendedor = p_codigo_vendedor);
    
    SET nome_vendedor = (SELECT nome FROM tb_cad_vendedor WHERE codigo = p_codigo_vendedor);

    IF razao_social IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Razão social não encontrada para o pedido.';
    END IF;
    
    IF condicao_pagamento IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Condição de pagamento não encontrada para o pedido.';
    END IF;
    
    IF cnpj_cpf IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CNPJ/CPF não encontrado para o pedido.';
    END IF;

    -- Conte o número de itens
   set contador = ( SELECT 
			count(*) 
		FROM 
			tb_ven_pedido_item
		INNER JOIN 
			tb_cad_item ON tb_cad_item.codigo = tb_ven_pedido_item.codigo_item
		WHERE 
			tb_ven_pedido_item.codigo_pedido = p_codigo_pedido);

    SET html = CONCAT('<html>
    <head>
        <title>Aprovação de Orçamento - email enviado para análise</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                background-color: #f9f9f9;
                color: #333;
            }
            h1 {
                color: #2c3e50;
            }
            p {
                font-size: 14px;
                line-height: 1.6;
            }
            footer {
                margin-top: 30px;
                padding: 10px;
                background-color: #34495e;
                color: white;
                text-align: center;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                background-color: #007BFF; /* Azul */
            }
            th {
                background-color: #6c757d; /* Cinza */
                color: white;
                padding: 10px;
                text-align: left;
            }
            td {
                padding: 10px;
                border: 1px solid #ddd; /* Borda das células */
                color: white; /* Texto das células em branco para contraste */
            }
        </style>
    </head>
    <body>
        <h1>Orçamento enviado para análise!</h1>
        <p>O seu orçamento foi enviado para análise! Abaixo estão os detalhes do orçamento:</p>
        <p><strong>Número do Pedido:</strong> ', IFNULL(p_codigo_pedido, 0) , '</p>
        <p><strong>Razão Social:</strong> ', IFNULL(razao_social, '-') , '</p>
        <p><strong>CNPJ/CPF:</strong> ', IFNULL(cnpj_cpf, '-') , '</p>
        <p><strong>Condição de Pagamento:</strong> ', IFNULL(condicao_pagamento, '-') , '</p>
        <p><strong>Abaixo seguem informações sobre o item de venda:</strong></p>');

    IF contador = 0 THEN 
        SET html = CONCAT(html,'<p>Sem itens vendidos</p>');
    ELSE
        SET html = CONCAT(html, '<table>
            <tr>
                <th>Descrição Item</th>
                <th>U.M</th>
                <th>Quantidade</th>
                <th>Valor Unitário</th>
                <th>Valor Total</th>
            </tr>');

        SET html = CONCAT(html,
            (SELECT 
                GROUP_CONCAT(
                    CONCAT(
                        '<tr>',
                        '<td>', IFNULL(tb_cad_item.descricao, '-') , '</td>',
                        '<td>',IFNULL(tb_cad_unidade_medida.sigla,'-'),'</td>',
                        '<td>', IFNULL(tb_ven_pedido_item.quantidade, 0), '</td>',
                        '<td>', IFNULL(tb_ven_pedido_item.valor_unitario, 0), '</td>',
                        '<td>', IFNULL((tb_ven_pedido_item.quantidade * tb_ven_pedido_item.valor_unitario), 0) , '</td>',
                        '</tr>'
                    ) SEPARATOR ''
                )
            FROM tb_ven_pedido 
            JOIN tb_ven_pedido_item 
                ON tb_ven_pedido.codigo = tb_ven_pedido_item.codigo_pedido 
                AND tb_ven_pedido.codigo_empresa = tb_ven_pedido_item.codigo_empresa
            LEFT JOIN tb_cad_item 
                ON tb_cad_item.codigo = tb_ven_pedido_item.codigo_item 
                AND tb_cad_item.codigo_empresa = tb_ven_pedido_item.codigo_empresa 
                
			LEFT join tb_cad_unidade_medida on tb_cad_unidade_medida.codigo = tb_cad_item.codigo_unidade_medida_venda
              
            WHERE tb_ven_pedido.codigo = p_codigo_pedido
            AND tb_ven_pedido.codigo_empresa = p_codigo_empresa 
            AND tb_ven_pedido.codigo_vendedor = p_codigo_vendedor
            ));

        SET html = CONCAT(html, '</table>');
    END IF;

    SET html = CONCAT(html, '<p><a href="https://pdv-cabr.actidesenvolvimento.com.br/">Clique aqui para acessar o sistema.</a></p>
            <p>Se você tiver qualquer dúvida, não hesite em nos contatar.</p>
            <footer>
                <p>&copy; 2024 ACTI. Todos os direitos reservados.</p>
            </footer>
        </body>
    </html>');

    SET titulo_email = CONCAT('PDV CABR - Vendedor ', nome_vendedor ,' teve o orçamento ', p_codigo_pedido, ' enviado para análise!');
    
    
    
    
    
    
    SET unidade_medida = ( select
		tb_cad_unidade_medida.sigla
	
        from tb_ven_pedido_item
        inner join tb_cad_item on tb_cad_item.codigo = tb_ven_pedido_item.codigo_item
        left join tb_cad_unidade_medida on tb_cad_unidade_medida.codigo = tb_cad_item.codigo_unidade_medida_venda
        where tb_ven_pedido_item.codigo_pedido = 900250
        limit 1);
    
    
    
    
    CREATE TEMPORARY TABLE IF NOT EXISTS tb_temp_usuarios (
        id INT AUTO_INCREMENT PRIMARY KEY,
        email VARCHAR(255)
    );
    
    INSERT INTO tb_temp_usuarios (email) 
		SELECT email_responsavel
		FROM tb_ven_pedido_email_analise 
		WHERE codigo_vendedor = p_codigo_vendedor AND codigo_pedido = p_codigo_pedido
		AND email_responsavel IS NOT NULL;  -- Adicione esta linha para evitar valores nulos


    INSERT INTO temp_anexos (nome_arquivo, conteudo_base64)
    SELECT 
        ta.nome_arquivo, 
        ta.conteudo_arquivo
    FROM tb_ven_pedido_anexo ta
    WHERE ta.numero_pedido = p_codigo_pedido;

    -- Atualizar o status do pedido
    UPDATE tb_ven_pedido
    SET status = p_aprovar_pedido
    WHERE codigo_empresa = p_codigo_empresa
      AND numero_pedido = p_codigo_pedido;

    -- Selecionar o conteúdo HTML e o título do email
    SELECT html AS EmailContent, titulo_email AS EmailSubject LIMIT 1;

    -- Selecionar os anexos
    SELECT nome_arquivo, conteudo_base64 FROM temp_anexos;
    
    -- Selecionar os e-mails inseridos
    SELECT email from tb_temp_usuarios;
    
    select contador;
    
    SELECT unidade_medida;

    -- Limpar as tabelas temporárias após uso
    DROP TEMPORARY TABLE IF EXISTS temp_anexos;
    DROP TEMPORARY TABLE IF EXISTS tb_temp_usuarios;
END
utf8mb4
utf8mb4_general_ci
latin1_general_ci
