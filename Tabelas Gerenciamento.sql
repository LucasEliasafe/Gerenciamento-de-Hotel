CREATE TABLE Hotel (
    hotel_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    uf VARCHAR(2) NOT NULL,
    ratting INT NOT NULL,
    UNIQUE(nome, cidade)
);

CREATE TABLE Cliente (
    cliente_id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL
);

CREATE TABLE Quarto (
    quarto_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT NOT NULL,
    numero INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    preco_diaria DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);

CREATE TABLE Hospedagem (
    hospedagem_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    quarto_id INT NOT NULL,
    dt_checkin DATE NOT NULL,
    dt_checkout DATE NOT NULL,
    valor_total_hosp DECIMAL(10, 2) NOT NULL,
    status_hosp VARCHAR(20) NOT NULL,
    checkin_realizado BOOLEAN,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
    FOREIGN KEY (quarto_id) REFERENCES Quarto(quarto_id)
);

INSERT INTO Hotel (nome, cidade, uf, ratting) VALUES
('Hotel A', 'Cidade A', 'UF', 4),
('Hotel B', 'Cidade B', 'UF', 5);


INSERT INTO Quarto (hotel_id, numero, tipo, preco_diaria) VALUES
(1, 101, 'Standard', 150.00),
(1, 102, 'Deluxe', 250.00),
(1, 103, 'Suíte', 400.00),
(1, 104, 'Standard', 150.00),
(1, 105, 'Deluxe', 250.00),
(2, 201, 'Standard', 120.00),
(2, 202, 'Deluxe', 200.00),
(2, 203, 'Suíte', 350.00),
(2, 204, 'Standard', 120.00),
(2, 205, 'Deluxe', 200.00);

INSERT INTO Cliente (nome, email, telefone, cpf) VALUES
('Cliente A', 'clienteA@email.com', '(00) 0000-0000', '111.111.111-11'),
('Cliente B', 'clienteB@email.com', '(11) 1111-1111', '222.222.222-22'),
('Cliente C', 'clienteC@email.com', '(22) 2222-2222', '333.333.333-33');

INSERT INTO Hospedagem (cliente_id, quarto_id, dt_checkin, dt_checkout, valor_total_hosp, status_hosp, checkin_realizado) VALUES
(1, 1, '2023-01-01', '2023-01-05', 600.00, 'finalizada', true),
(1, 2, '2023-02-01', '2023-02-03', 500.00, 'finalizada', true),
(2, 5, '2023-03-10', '2023-03-15', 1250.00, 'finalizada', true),
(3, 7, '2023-04-05', '2023-04-08', 360.00, 'finalizada', true),
(2, 10, '2023-05-20', '2023-05-25', 1200.00, 'finalizada', true),
(1, 4, '2023-06-15', '2023-06-17', 300.00, 'reserva', false),
(3, 6, '2023-07-01', '2023-07-05', 800.00, 'reserva', false),
(1, 3, '2023-08-10', '2023-08-12', 800.00, 'hospedado', true),
(2, 8, '2023-09-15', '2023-09-17', 400.00, 'hospedado', true),
(3, 9, '2023-10-20', '2023-10-22', 250.00, 'cancelada', false),
(1, 2, '2023-11-05', '2023-11-08', 750.00, 'cancelada', false),
(2, 3, '2023-12-01', '2023-12-05', 1000.00, 'reserva', false),
(3, 5, '2024-01-10', '2024-01-15', 900.00, 'reserva', false),
(1, 1, '2024-02-15', '2024-02-20', 750.00, 'reserva', false),
(2, 4, '2024-03-01', '2024-03-05', 600.00, 'hospedado', true),
(3, 8, '2024-04-10', '2024-04-12', 300.00, 'hospedado', true),
(1, 5, '2024-05-20', '2024-05-25', 1100.00, 'reserva', false),
(2, 2, '2024-06-01', '2024-06-05', 800.00, 'reserva', false),
(3, 1, '2024-07-10', '2024-07-15', 950.00, 'finalizada', true),
(1, 10, '2024-08-15', '2024-08-20', 850.00, 'finalizada', true);


SELECT h.nome, h.cidade, q.tipo, q.preco_diaria
FROM Hotel h
JOIN Quarto q ON h.hotel_id = q.hotel_id;

SELECT c.nome, q.numero, h.nome AS hotel
FROM Cliente c
JOIN Hospedagem hos ON c.cliente_id = hos.cliente_id
JOIN Quarto q ON hos.quarto_id = q.quarto_id
JOIN Hotel h ON q.hotel_id = h.hotel_id
WHERE hos.status_hosp = 'finalizada';

SELECT h.dt_checkin, h.dt_checkout, h.status_hosp, q.tipo, ho.nome AS hotel
FROM Hospedagem h
JOIN Quarto q ON h.quarto_id = q.quarto_id
JOIN Hotel ho ON q.hotel_id = ho.hotel_id
WHERE h.cliente_id = 1
ORDER BY h.dt_checkin;

SELECT c.nome, COUNT(*) AS total_hospedagens
FROM Cliente c
JOIN Hospedagem h ON c.cliente_id = h.cliente_id
GROUP BY c.cliente_id
ORDER BY total_hospedagens DESC
LIMIT 1;

SELECT c.nome, q.numero, ho.nome AS hotel
FROM Cliente c
JOIN Hospedagem h ON c.cliente_id = h.cliente_id
JOIN Quarto q ON h.quarto_id = q.quarto_id
JOIN Hotel ho ON q.hotel_id = ho.hotel_id
WHERE h.status_hosp = 'cancelada';

SELECT h.nome, SUM(hos.valor_total_hosp) AS receita_total
FROM Hotel h
JOIN Quarto q ON h.hotel_id = q.hotel_id
JOIN Hospedagem hos ON q.quarto_id = hos.quarto_id
WHERE hos.status_hosp = 'finalizada'
GROUP BY h.hotel_id
ORDER BY receita_total DESC;

SELECT DISTINCT c.nome, c.email, c.telefone
FROM Cliente c
JOIN Hospedagem h ON c.cliente_id = h.cliente_id
JOIN Quarto q ON h.quarto_id = q.quarto_id
WHERE q.hotel_id = 1 AND h.status_hosp = 'reserva';

SELECT c.nome AS cliente_nome, SUM(h.valor_total_hosp) AS total_gasto
FROM Cliente c
JOIN Hospedagem h ON c.cliente_id = h.cliente_id
WHERE h.status_hosp = 'finalizada'
GROUP BY c.cliente_id
ORDER BY total_gasto DESC;

SELECT q.numero, h.nome AS hotel
FROM Quarto q
JOIN Hotel h ON q.hotel_id = h.hotel_id
LEFT JOIN Hospedagem hos ON q.quarto_id = hos.quarto_id
WHERE hos.hospedagem_id IS NULL OR hos.status_hosp != 'hospedado';

SELECT h.nome AS hotel, q.tipo, AVG(q.preco_diaria) AS media_diaria
FROM Quarto q
JOIN Hotel h ON q.hotel_id = h.hotel_id
GROUP BY h.hotel_id, q.tipo;

ALTER TABLE Hospedagem
ADD COLUMN checkin_realizado BOOLEAN;

UPDATE Hospedagem
SET checkin_realizado = TRUE
WHERE status_hosp IN ('finalizada', 'hospedado');

UPDATE Hospedagem
SET checkin_realizado = FALSE
WHERE status_hosp IN ('reserva', 'cancelada');

ALTER TABLE Hotel
CHANGE COLUMN classificacao ratting INT NOT NULL;