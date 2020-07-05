#1. Naloga (DDL)

#pleme
CREATE TABLE pleme (
tid INTEGER PRIMARY KEY AUTO_INCREMENT,
tribe VARCHAR(100) 
)DEFAULT CHARSET=utf8 COLLATE=utf8_slovenian_ci;
ALTER TABLE pleme AUTO_INCREMENT=1;


INSERT INTO pleme (tribe) VALUES ("Rimljani");
INSERT INTO pleme (tribe) VALUES ("Tevtoni");
INSERT INTO pleme (tribe) VALUES ("Galci");
INSERT INTO pleme (tribe) VALUES ("Narava");
INSERT INTO pleme (tribe) VALUES ("Natarji");
INSERT INTO pleme (tribe) VALUES ("Huni");
INSERT INTO pleme (tribe) VALUES ("Egipcani");


#aliansa
CREATE TABLE aliansa AS
SELECT DISTINCT aid, alliance
FROM x_world;

ALTER TABLE aliansa MODIFY COLUMN aid INTEGER PRIMARY KEY;
DELETE FROM aliansa WHERE aid=0;


#igralec
CREATE TABLE igralec AS
SELECT distinct pid, player, tid, aid
FROM x_world;

ALTER TABLE igralec MODIFY COLUMN aid INTEGER NULL;
update igralec set aid=null where aid=0;
ALTER TABLE igralec MODIFY COLUMN pid INTEGER PRIMARY KEY;

ALTER TABLE igralec
ADD CONSTRAINT FK_IgralecPleme
FOREIGN KEY (tid) REFERENCES pleme(tid);

ALTER TABLE igralec
ADD CONSTRAINT FK_IgralecAliansa
FOREIGN KEY (aid) REFERENCES aliansa(aid);


#naselje
CREATE TABLE naselje AS
SELECT DISTINCT vid, village, x, y, population, pid
FROM x_world;

ALTER TABLE naselje MODIFY COLUMN vid INTEGER PRIMARY KEY;

ALTER TABLE naselje
ADD CONSTRAINT FK_NaseljeIgralec
FOREIGN KEY (pid) REFERENCES igralec(pid);


COMMIT;



#2. Naloga (DML) 

#a) Izpišite šifro in ime igralca z največjim naseljem?
SELECT i.pid AS šifra, i.player AS "ime igralca"
FROM igralec i
INNER JOIN naselje n USING(pid)
WHERE n.population = (
		SELECT MAX(population)naselje
		FROM naselje);

#b) Kateri igralci imajo največ naselij? Izpišite njihove šifre, imena in število naselji. 
#Pri tem izločite Natarje (pid = 1).
SELECT i.pid AS šifra, i.player AS "ime igralca", count(n.vid) AS "število naselij"
FROM igralec i
INNER JOIN naselje n USING(pid)
WHERE i.pid != 1
GROUP BY i.pid
HAVING COUNT(n.vid) = 
	(SELECT COUNT(vid) FROM naselje 
	WHERE pid != 1
    GROUP BY pid
    ORDER BY COUNT(vid) DESC
    LIMIT 1);


#c) Koliko naselij ima v povprečju vsak igralec? (Brez upoštevanja Natarjev)
SELECT AVG(stevilo) AS "povprečje naselij" from (
	SELECT COUNT(vid) AS stevilo FROM naselje 
	WHERE pid != 1
	GROUP BY pid
    )AS T;
    
#d) Koliko igralcev ima nadpovprečno veliko naselje? (Ponovno brez upoštevanja Natarjev)    
SELECT COUNT(DISTINCT i.pid)  AS "število igralcev"
FROM igralec i 
INNER JOIN naselje n USING(pid)
WHERE i.pid != 1 AND n.population > (
	SELECT AVG(population) 
    FROM naselje
    WHERE pid != 1);
    
#e) Izpišite podatke o vseh naseljih igralcev brez alianse, urejeno padajoče po populaciji,
#nato po x in y koordinati.
SELECT n.* 
FROM igralec i
INNER JOIN naselje n USING(pid)
WHERE i.aid IS NULL
ORDER BY n.population DESC, n.x DESC, n.y DESC;

#f) Izpišite šifre in imena vseh alians, ki se končajo na cifro in vsebujejo vsaj eno črko.
#Rezultate uredite po abecednem vrstnem redu.
SELECT aid, alliance 
FROM aliansa 
WHERE alliance REGEXP '[[:digit:]]$' AND alliance REGEXP '[[:alpha:]]'
ORDER BY alliance;

#g) Napišite funkcijo, ki za območje definirano s parametri x, y in razdalja vrne vsoto
#populacije območja. Območje je definirano s kvadratom (x-razdalja, y-razdalja),
#(x+razdalja, y+razdalja). S pomočjo ustvarjene funkcije izpišite vsoto za vrednosti
#parametrov (x = 0, y = 0, razdalja = 10), (x = 20, y = 20, razdalja = 5) in (x = 0, y = 0,
#razdalja = 500).

DROP FUNCTION IF EXISTS vsota_populacije_obmocja;
DELIMITER $$
CREATE FUNCTION vsota_populacije_obmocja (x INTEGER, y INTEGER, razdalja INTEGER) 
RETURNS INTEGER
DETERMINISTIC
BEGIN 
	DECLARE vsota INTEGER;
	SELECT SUM(n.population) INTO vsota
	FROM naselje n
	WHERE (n.x BETWEEN (x-razdalja) AND (x+razdalja)) AND (n.y BETWEEN (y-razdalja) AND (y+razdalja));
	RETURN vsota;
END$$
DELIMITER ;

select vsota_populacije_obmocja( 0, 0, 10);
select vsota_populacije_obmocja( 20, 20, 5);
select vsota_populacije_obmocja( 0, 0, 500);



#h) Izpišite šifre in imena igralcev, ki imajo vsa svoja naselja na območju, kjer je x med
#100 in 200 in y med 0 in 100.

SELECT DISTINCT i.pid AS šifra, i.player as ime
FROM igralec i
INNER JOIN naselje n USING(pid)
WHERE i.pid IN 
	(SELECT DISTINCT i.pid
	FROM igralec i
	INNER JOIN naselje n USING(pid)
	WHERE (n.x  BETWEEN 100 AND 200) and (n.y  BETWEEN 0 AND 100))
and i.pid NOT IN
	(SELECT DISTINCT i.pid
	FROM igralec i
	INNER JOIN naselje n USING(pid)
	WHERE (n.x NOT BETWEEN 100 AND 200) or (n.y NOT BETWEEN 0 AND 100));



#i) Poiščite šifre in imena igralcev, ki imajo umirajoče naselje. Za umirajoče naselje
#vzemite tista naselja, ki imajo manj kot 3% povprečne populacije igralca (povprečna
#populacija igralca je skupna populacija igralca ulomljeno s številom njegovih naselji) .

SELECT i.pid as šifra, i.player as ime
FROM igralec i
INNER JOIN naselje n USING(pid)
WHERE n.population < 
	((SELECT  SUM(n2.population) / COUNT(n2.vid)  
	FROM igralec i2
	INNER JOIN naselje n2 USING(pid)
	WHERE n2.pid = i.pid
	GROUP BY i2.pid) 
	/ 100 * 3)
GROUP BY i.pid;

#j) *Igralec »pitt« želi preimenovati vsa svoja naselja na naslednji način. Uredil jih bo po
#populaciji, najmočnejše bo »Terrier 00«, naslednje »Terrier 01« in tako dalje. Nalogo
#lahko rešite v več korakih (zaporedju poizvedb).

SET @ime:=-01;
UPDATE naselje
SET village=concat( "Terrier ", LPAD(@ime:=@ime+1, 2, 0))
WHERE pid IN (
SELECT pid FROM igralec WHERE player="pitt")
ORDER BY population DESC;
COMMIT;
 
SELECT n.* 
FROM naselje n
INNER JOIN igralec i USING(pid)
WHERE i.player="pitt" 
ORDER BY n.population DESC;


#3. Naloga (DDL)
#a)
#Napišite shranjeno proceduro UstvariAlianso(imeAlianse, pid), ki ustvari novo alianso
#imeAlianse in vanjo včlani igralca s šifro pid. Procedura mora preveriti tudi, da igralec
#s šifro pid ni že v drugi aliansi.

DELIMITER //
DROP PROCEDURE IF EXISTS UstvariAlianso;
CREATE PROCEDURE UstvariAlianso( IN imeAlianse varchar(100), IN pid_igralca INTEGER)
BEGIN
    DECLARE aliansa_igralca INTEGER;
    DECLARE next_aid INTEGER;
	SET next_aid := (SELECT MAX(aid) +1 FROM aliansa);
    
    SET aliansa_igralca := (SELECT aid FROM igralec  WHERE pid=pid_igralca);

    IF(aliansa_igralca IS NULL) THEN
        INSERT INTO aliansa VALUES(next_aid, imeAlianse);
        UPDATE igralec  SET aid=next_aid WHERE pid=pid_igralca;
        COMMIT;
	else
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Igralec je že v drugi aliansi.";
    END IF;
END //
DELIMITER ;


call UstvariAlianso("test", 1);


#b)
#Napišite transakcijo, ki bo združila člane alians GM-H4N1TM in RS-H3N3TM v novo
#alianso imenovano VirusTM.


SELECT i.player AS "ime igralca"
FROM igralec i
INNER JOIN aliansa a USING(aid)
WHERE a.alliance LIKE "GM-H4N1™" OR a.alliance LIKE "RS-H3N3™";

SELECT i.player AS "ime igralca"
FROM igralec i
INNER JOIN aliansa a USING(aid)
WHERE a.alliance="Virus™";

START TRANSACTION;
INSERT INTO aliansa VALUES((SELECT MAX(a.aid) +1 FROM aliansa a), "Virus™");
UPDATE igralec i INNER JOIN aliansa a USING(aid) SET i.aid=
	(SELECT MAX(a2.aid) 
    FROM aliansa a2) 
WHERE a.alliance="GM-H4N1™" OR a.alliance="RS-H3N3™";
DELETE FROM aliansa WHERE alliance="GM-H4N1™" OR alliance="RS-H3N3™";
COMMIT;



