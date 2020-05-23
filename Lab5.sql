
/*1.Добавить внешние ключи.*/

ALTER TABLE production
	ADD FOREIGN KEY (id_medicine) REFERENCES medicine(id_medicine) ON DELETE CASCADE;

ALTER TABLE production
	ADD FOREIGN KEY (id_company) REFERENCES company(id_company) ON DELETE CASCADE;

ALTER TABLE dealer
	ADD FOREIGN KEY (id_company) REFERENCES company(id_company) ON DELETE CASCADE;

ALTER TABLE "order"
	ADD FOREIGN KEY (id_dealer) REFERENCES dealer(id_dealer) ON DELETE CASCADE;

ALTER TABLE "order"
	ADD FOREIGN KEY (id_production) REFERENCES production(id_production) ON DELETE CASCADE;

ALTER TABLE "order"
	ADD FOREIGN KEY (id_pharmacy) REFERENCES pharmacy(id_pharmacy) ON DELETE CASCADE;

/*2.Выдать информацию по всем заказам лекарства “Кордерон” компании “Аргус” с указанием названий аптек, дат, объема заказов.*/
SELECT
	pharmacy.name, "order".date, "order".quantity
FROM 
	"order"
	LEFT JOIN pharmacy ON "order".id_pharmacy = pharmacy.id_pharmacy
	LEFT JOIN production ON "order".id_production = production.id_production
	LEFT JOIN medicine ON production.id_medicine = medicine.id_medicine
	LEFT JOIN company ON production.id_company = company.id_company
WHERE
	medicine.name = 'Кордерон' and 
	company.name = 'Аргус'

/*3.Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25января.*/

SELECT
	medicine.name
FROM 
	medicine
	LEFT OUTER JOIN (
		SELECT 
			production.id_medicine
		FROM
			production
			LEFT JOIN "order" ON production.id_production = "order".id_production		
			WHERE
				"order".date >= '2019-01-25') AS A
	ON medicine.id_medicine = A.id_medicine
WHERE
	A.id_medicine IS NULL

/*4.Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов.*/

SELECT
	company.name, min(production.rating) as "min rating", max(production.rating) as "max rating"
FROM 
	"order"
	LEFT JOIN production ON "order".id_production = production.id_production
	LEFT JOIN company ON production.id_company = company.id_company
GROUP BY
	company.name
HAVING
	count("order".id_order) >= 120

/*5.Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”.Если у дилера нет заказов, в названии аптеки проставить NULL.*/

SELECT DISTINCT
	pharmacy.name, dealer.name
FROM 
	dealer
	LEFT JOIN "order" ON "order".id_dealer = dealer.id_dealer
	LEFT JOIN pharmacy ON "order".id_pharmacy = pharmacy.id_pharmacy
	LEFT JOIN company ON dealer.id_company = company.id_company
WHERE
	company.name = 'AstraZeneca'
ORDER BY
	dealer.name

/*6.Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а длительность лечения не более 7 дней.*/

UPDATE
	production
SET
	price = 0.8 * price
WHERE production.id_production IN (
	SELECT 
		production.id_production
	FROM
		medicine
		LEFT JOIN production ON production.id_medicine = medicine.id_medicine		
		WHERE
			production.price > 3000 and
			medicine.cure_duration <= 7
			)

/*7.Добавить необходимые индексы.*/

CREATE INDEX IX_order_id_production
ON "order"(id_production ASC);

CREATE INDEX IX_order_id_pharmacy
ON "order"(id_pharmacy ASC);

CREATE INDEX IX_dealer_id_company
ON dealer(id_company ASC);

CREATE INDEX IX_production_id_company
ON production(id_company ASC);

CREATE INDEX IX_production_id_medicine
ON production(id_medicine ASC);