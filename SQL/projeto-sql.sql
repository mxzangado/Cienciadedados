-- Criando banco
create database if not exists vendas_dimensional;
use vendas_dimensional;

----------------------------------------------------
-- TABELAS DIMENSIONAIS
----------------------------------------------------

create table dim_fornecedor (
	id bigint primary key comment 'Identificador do fornecedor',
	fornecedor varchar(200) not null comment 'Nome da empresa',
	contato varchar(200) not null comment 'Telefone/Contato do fornecedor'
);

create table dim_transportadora (
	id bigint primary key comment 'Identificador da transportadora',
	transportadora varchar(200) not null comment 'Nome da transportadora',
	contato varchar(200) not null comment 'Contato da transportadora'
);

create table dim_vendedor (
	id bigint primary key comment 'Identificador único do vendedor',
	nome varchar(200) not null comment 'Nome do vendedor',
	sexo_codigo char(1) comment 'M/F/N',
	sexo_descricao varchar(400) comment 'Descrição do sexo',
	nascimento date not null comment 'Data de nascimento',
	contrato date not null comment 'Data da contratação',
	supervisor varchar(200) comment 'Nome do supervisor'
);

create table dim_produto (
	id bigint primary key comment 'Identificador único do produto',
	produto varchar(200) comment 'Nome do produto',
	preco_unitario float,
	descontinuado tinyint
);

create table dim_categoria (
	id bigint primary key comment 'Identificador da categoria',
	categoria varchar(200) comment 'Nome da categoria'
);

create table dim_pais (
	id bigint primary key comment 'Identificador único do país',
	sigla char(2) not null,
	pais varchar(100) not null
);

create table dim_cliente (
	id bigint primary key comment 'Identificador do cliente',
	nome_cliente varchar(200) not null,
	sexo_codigo char(1),
	sexo_descricao varchar(45),
	profissao varchar(200) not null,
	email varchar(400) not null,
	proverdor_do_cliente varchar(45) not null,
	nascimento date not null,
	cadastro date,
	endereco_completo varchar(450),
	cod_nacionalidade varchar(45),
	nacionalidade varchar(45)
);

create table dim_tempo (
	id bigint primary key comment 'Identificador único da linha do tempo',
	data date,
	dia int not null,
	ano int not null,
	data_juliana varchar(45) not null,
	semestre int not null,
	quadrimestre int not null,
	trimestre int not null,
	bimestre int not null,
	nome_mes varchar(45) not null,
	dia_da_semana int not null,
	nome_dia_da_semana varchar(45) not null,
	semana_do_ano varchar(45) not null,
	data_string char(10) not null,
	dia_no_ano int not null,
	ultimo_dia_mes int not null,
	fim_de_semana tinyint not null
);

----------------------------------------------------
-- TABELA FATO
----------------------------------------------------

create table fat_item (
	id bigint primary key comment 'Identificador da venda',
	qtd_vendida int not null comment 'Quantidade vendida',
	preco_unitario_na_venda float not null comment 'Preço unitário na venda',
	valor_frete float default 0 comment 'Valor do frete',
	valor_desconto float default 0 comment 'Valor do desconto',
	valor_comissao float default 0 comment 'Valor de comissão',

	tempo_pedido bigint not null,
	tempo_de_pagamento bigint,
	tempo_previsao bigint,
	tempo_de_envio bigint,
	tempo_de_entrega bigint,

	idcliente bigint not null,
	pais_moradia_cliente bigint,
	pais_nacionalidade_cliente bigint,
	pais_destino bigint not null,

	idtransportadora bigint not null,
	idvendedor bigint not null,
	idfornecedor bigint not null,
	idcategoria bigint not null,
	idproduto bigint not null
);

----------------------------------------------------
-- CRIANDO OS RELACIONAMENTOS (FOREIGN KEYS)
----------------------------------------------------

alter table fat_item
	add constraint fk_item_cliente
	foreign key (idcliente)
	references dim_cliente(id);

alter table fat_item
	add constraint fk_item_fornecedor
	foreign key (idfornecedor)
	references dim_fornecedor(id);

alter table fat_item
	add constraint fk_item_transportadora
	foreign key (idtransportadora)
	references dim_transportadora(id);

alter table fat_item
	add constraint fk_item_vendedor
	foreign key (idvendedor)
	references dim_vendedor(id);

alter table fat_item
	add constraint fk_item_produto
	foreign key (idproduto)
	references dim_produto(id);

alter table fat_item
	add constraint fk_item_categoria
	foreign key (idcategoria)
	references dim_categoria(id);

alter table fat_item
	add constraint fk_item_pais_destino
	foreign key (pais_destino)
	references dim_pais(id);

alter table fat_item
	add constraint fk_item_pais_moradia
	foreign key (pais_moradia_cliente)
	references dim_pais(id);

alter table fat_item
	add constraint fk_item_pais_nacionalidade
	foreign key (pais_nacionalidade_cliente)
	references dim_pais(id);

alter table fat_item
	add constraint fk_item_tempo_pedido
	foreign key (tempo_pedido)
	references dim_tempo(id);

alter table fat_item
	add constraint fk_item_tempo_pag
	foreign key (tempo_de_pagamento)
	references dim_tempo(id);

alter table fat_item
	add constraint fk_item_tempo_prev
	foreign key (tempo_previsao)
	references dim_tempo(id);

alter table fat_item
	add constraint fk_item_tempo_envio
	foreign key (tempo_de_envio)
	references dim_tempo(id);

alter table fat_item
	add constraint fk_item_tempo_entrega
	foreign key (tempo_de_entrega)
	references dim_tempo(id);
