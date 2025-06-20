DROP DATABASE IF EXISTS casino25;
create database casino25;
use casino25;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL UNIQUE,
    user_password VARCHAR(39) NOT NULL,
    email VARCHAR(50) NOT NULL,
    last_access DATETIME DEFAULT NOW(),
    verified_email BOOLEAN NOT NULL DEFAULT TRUE,
    remember_login BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(30) NOT NULL,
    age INT NOT NULL,
    gender ENUM('M','F','O') NOT NULL,
    active_status BOOLEAN NOT NULL DEFAULT TRUE,
    balance DECIMAL(8,2) NOT NULL,
    user_profile INT NOT NULL,
    FOREIGN KEY (user_profile) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE games (
    id INT PRIMARY KEY AUTO_INCREMENT,
    game_type ENUM('Blackjack', 'SlotMachine') NOT NULL,
    active_status BOOLEAN NOT NULL DEFAULT TRUE,
    money_pool DECIMAL(8,2) NOT NULL,
	user_profile INT NOT NULL,
	FOREIGN KEY (user_profile) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE game_sessions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    game_id INT,
    game_type ENUM('Blackjack', 'SlotMachine') NOT NULL,
    bet_result DECIMAL(8,2) NOT NULL,
    session_date DATETIME DEFAULT NOW(),
	user_profile INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
    FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE SET NULL,
	FOREIGN KEY (user_profile) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE dominios (
    domain_type VARCHAR(50),
    tld VARCHAR(20),
    manager VARCHAR(255)
);

DROP TRIGGER IF EXISTS verify_email_insert;
DELIMITER $$
CREATE TRIGGER verify_email_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    DECLARE at_pos INT;
    DECLARE dot_after INT;
	DECLARE last_dot_pos INT;
    DECLARE domain VARCHAR(50);
    DECLARE valid_domain INT;

	-- Buscar el arroba
	SET at_pos = LOCATE('@', NEW.email);
	IF at_pos <= 0 THEN
		SET NEW.verified_email = FALSE;

    ELSE
        -- Buscar el punto después del arroba
        SET dot_after = LOCATE('.', NEW.email, at_pos);
        IF dot_after <= at_pos THEN
            SET NEW.verified_email = FALSE;

        ELSE
            -- Extraer el dominio (a partir del último punto)
            SET last_dot_pos = CHAR_LENGTH(NEW.email) - LOCATE('.', REVERSE(NEW.email)) + 1;
            SET domain = CONCAT('.', SUBSTRING_INDEX(NEW.email, '.', -1));

            -- Verificar que el dominio exista en la tabla dominios
            SELECT COUNT(*) INTO valid_domain FROM dominios WHERE tld = domain;

			-- Comprobar el resultado
			IF valid_domain = 0 THEN
				SIGNAL SQLSTATE '45000';
			END IF;
        END IF;
    END IF;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS verify_email_update;
DELIMITER $$
CREATE TRIGGER verify_email_update
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    DECLARE at_pos INT;
    DECLARE dot_after INT;
	DECLARE last_dot_pos INT;
    DECLARE domain VARCHAR(50);
    DECLARE valid_domain INT;

	-- Buscar el arroba
	SET at_pos = LOCATE('@', NEW.email);
	IF at_pos <= 0 THEN
		SET NEW.verified_email = FALSE;

    ELSE
        -- Buscar el punto después del arroba
        SET dot_after = LOCATE('.', NEW.email, at_pos);
        IF dot_after <= at_pos THEN
            SET NEW.verified_email = FALSE;

        ELSE
            -- Extraer el dominio (a partir del último punto)
            SET last_dot_pos = CHAR_LENGTH(NEW.email) - LOCATE('.', REVERSE(NEW.email)) + 1;
            SET domain = CONCAT('.', SUBSTRING_INDEX(NEW.email, '.', -1));

            -- Verificar que el dominio exista en la tabla dominios
            SELECT COUNT(*) INTO valid_domain FROM dominios WHERE tld = domain;

			-- Comprobar el resultado
            IF valid_domain > 0 THEN
                SET NEW.verified_email = TRUE;
            ELSE
                SET NEW.verified_email = FALSE;
            END IF;
        END IF;
    END IF;
END $$
DELIMITER ;

-- Valid domains
INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.aaa', 'American Automobile Association, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.aarp', NULL);

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.abarth', NULL);

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.abb', 'ABB Ltd');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.abbott', 'Abbott Laboratories, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.abbvie', 'AbbVie Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.abc', 'Disney Enterprises, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.able', NULL);

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.abogado', 'Registry Services, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.abudhabi', 'Abu Dhabi Systems and Information Centre');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('country-code', '.ac', 'Internet Computer Bureau Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.academy', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.accenture', 'Accenture plc');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.accountant', 'dot Accountant Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.accountants', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.aco', 'ACO Severin Ahlmann GmbH & Co. KG');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.active', NULL);

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.actor', 'Dog Beach, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('country-code', '.ad', 'Andorra Telecom');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.adac', NULL);

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.ads', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.adult', 'ICM Registry AD LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('country-code', '.ae', 'Telecommunications and Digital Government Regulatory Authority');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('country-code', '.am', 'ISOC AM');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('country-code', '.americanexpress', 'American Express Travel Related Services Company, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.americanfamily', 'AmFam, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.amex', 'American Express Travel Related Services Company, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.amfam', 'AmFam, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.amica', 'Amica Mutual Insurance Company');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.amsterdam', 'Gemeente Amsterdam');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('country-code', '.an', 'Netherlands Antilles (Retired TLD)');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.analytics', 'Campus IP LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.android', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.anquan', 'QIHOO 360 TECHNOLOGY CO. LTD.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('country-code', '.ao', 'Faculdade de Engenharia da Universidade Agostinho Neto');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.aol', 'Oath Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.apartments', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.app', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.apple', 'Apple Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.aquarelle', 'Aquarelle.com');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.arab', 'League of Arab States');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.aramco', 'Aramco Services Company');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.archi', 'STARTING DOT LIMITED');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.army', 'United TLD Holdco Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.arpa', 'Internet Assigned Numbers Authority');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.art', 'UK Creative Ideas Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.arte', 'Association Relative à la Télévision Européenne G.E.I.E.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.asda', 'Wal-Mart Stores, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('country-code', '.asia', 'DotAsia Organisation Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.associates', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.athleta', 'The Gap, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('country-code', '.attorney', 'Dog Beach, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.au', 'au Domain Administration (auDA)');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.auction', 'United TLD Holdco Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.audi', 'AUDI Aktiengesellschaft');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.audible', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.audio', 'Uniregistry, Corp.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.auspost', 'Australian Postal Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.author', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.auto', 'Cars Registry Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.autos', 'DERAutos, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.avianca', 'Aerovias del Continente Americano S.A. Avianca');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.aw', 'SETAR');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.aws', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.ax', 'Ålands landskapsregering');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.axa', 'AXA Group Operations SAS');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.az', 'IntraNS');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.azure', 'Microsoft Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.baby', 'Johnson & Johnson Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.baidu', 'Baidu, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.banamex', 'Citigroup Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES ('generic', '.bananarepublic', 'The Gap, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('country-code', '.band', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bank', 'fTLD Registry Services, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bar', 'Punto 2012 Sociedad Anonima Promotora de Inversion de Capital Variable');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.barcelona', 'Municipi de Barcelona');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.barclaycard', 'Barclays Bank PLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.barclays', 'Barclays Bank PLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.barefoot', 'Gallo Vineyards, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bargains', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.baseball', 'MLB Advanced Media DH, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.basketball', 'Fédération Internationale de Basketball (FIBA)');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bauhaus', 'Werkhaus GmbH');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bayern', 'Bayern Connect GmbH');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bbc', 'British Broadcasting Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bbt', 'BB&T Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bbva', 'BANCO BILBAO VIZCAYA ARGENTARIA, S.A.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bcg', 'The Boston Consulting Group, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bcn', 'Municipi de Barcelona');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.beats', 'Beats Electronics, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.beauty', 'LOréal');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.beer', 'Minds + Machines Group Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bentley', 'Bentley Motors Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.berlin', 'dotBERLIN GmbH & Co. KG');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.best', 'BestTLD Pty Ltd');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bestbuy', 'BBY Solutions, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bet', 'Afilias plc');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bharti', 'Bharti Enterprises (Holding) Private Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bible', 'American Bible Society');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bid', 'dot Bid Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bike', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bing', 'Microsoft Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bingo', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bio', 'STARTING DOT LIMITED');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.black', 'Afilias plc');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.blackfriday', 'UNR Corp.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.blanco', 'Blanco GmbH + Co KG');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.blockbuster', 'Dish DBS Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.blog', 'Automattic, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bloomberg', 'Bloomberg IP Holdings LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.blue', 'Afilias plc');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bms', 'Bristol-Myers Squibb Company');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bmw', 'Bayerische Motoren Werke Aktiengesellschaft');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bnl', 'Banca Nazionale del Lavoro');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bnpparibas', 'BNP Paribas');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.boats', 'DERBoats, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.boehringer', 'Boehringer Ingelheim International GmbH');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bofa', 'NMS Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bom', 'Núcleo de Informação e Coordenação do Ponto BR - NIC.br');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bond', 'Bond University Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.boo', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.book', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.booking', 'Booking.com B.V.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bosch', 'Robert Bosch GMBH');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bostik', 'Bostik SA');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.boston', 'Boston TLD Management, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bot', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.boutique', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.box', 'Intercap Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.br', 'Comite Gestor da Internet no Brasil');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bradesco', 'Banco Bradesco S.A.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bridgestone', 'Bridgestone Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.broadway', 'Celebrate Broadway, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.broker', 'Dog Beach, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.brother', 'Brother Industries, Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.brussels', 'DNS.be vzw');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.budapest', 'Minds + Machines Group Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bugatti', 'Bugatti International SA');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.build', 'Plan Bee LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.builders', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.business', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.buy', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.buzz', 'DOTSTRATEGY CO.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.bzh', 'Association www.bzh');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.ca', 'Canadian Internet Registration Authority (CIRA) Autorité canadienne pour les enregistrements Internet (ACEI)');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cab', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cafe', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cal', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.call', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.calvinklein', 'PVH gTLD Holdings LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cam', 'AC Webconnecting Holding B.V.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.camera', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.camp', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cancerresearch', 'Australian Cancer Research Foundation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.canon', 'Canon Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.capetown', 'ZA Central Registry NPC trading as ZA Central Registry');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.capital', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.capitalone', 'Capital One Financial Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.car', 'Cars Registry Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.caravan', 'Caravan Club Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cards', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.care', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.career', 'dotCareer LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.careers', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cars', 'Cars Registry Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.casa', 'Dog Beach, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.case', 'CASE Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.caseih', 'CNH Industrial N.V.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cash', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.casino', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cat', 'Fundacio puntCAT');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.catering', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.catholic', 'Pontificium Consilium de Comunicationibus Socialibus (PCCS) / Pontifical Council for Social Communication');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cba', 'COMMONWEALTH BANK OF AUSTRALIA');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cbn', 'The Christian Broadcasting Network, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cbre', 'CBRE, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cbs', 'CBS Domains Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.center', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.ceo', 'CEOTLD Pty Ltd');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cern', 'European Organization for Nuclear Research ("CERN")');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cfa', 'CFA Institute');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cfd', 'DOTCFD REGISTRY LTD');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.ch', 'SWITCH The Swiss Education & Research Network');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.chanel', 'Chanel International B.V.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.channel', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.charity', 'Corn Lake, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.chase', 'JPMorgan Chase & Co.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.chat', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cheap', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.chintai', 'CHINTAI Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.christmas', 'Uniregistry, Corp.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.chrome', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.church', 'United TLD Holdco Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cipriani', 'Hotel Cipriani Srl');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.circle', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cisco', 'Cisco Technology, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.citadel', 'Citadel Domain LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.citi', 'Citigroup Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.citic', 'CITIC Group Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.city', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cityeats', 'Lifestyle Domain Holdings, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.ck', 'Telecom Cook Islands Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.claims', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cleaning', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.click', 'Uniregistry, Corp.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.clinic', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.clinique', 'The Estée Lauder Companies Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.clothing', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cloud', 'ARUBA PEC S.p.A.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.club', '.CLUB DOMAINS, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.clubmed', 'Club Méditerranée S.A.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cm', 'Cameroon Telecommunications (CAMTEL)');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cn', 'China Internet Network Information Center (CNNIC)');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.co', '.CO Internet S.A.S.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.coach', 'Koko Island, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.codes', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.coffee', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.college', 'XYZ.COM LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cologne', 'NetCologne Gesellschaft für Telekommunikation mbH');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.com', 'VeriSign Global Registry Services');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.comcast', 'Comcast IP Holdings I, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.commbank', 'COMMONWEALTH BANK OF AUSTRALIA');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.community', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.company', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.compare', 'iSelect Ltd');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.computer', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.comsec', 'VeriSign, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.condos', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.construction', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.consulting', 'United TLD Holdco, LTD.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.contact', 'Top Level Spectrum, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.contractors', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cooking', 'Top Level Domain Holdings Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cookingchannel', 'Lifestyle Domain Holdings, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cool', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.coop', 'DotCooperation LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.corsica', 'Collectivité de Corse - Direction du Système Information');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.country', 'Top Level Domain Holdings Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.coupon', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.coupons', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.courses', 'Open Universities Australia Pty Ltd');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.credit', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.creditcard', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.creditunion', 'CUNA Performance Resources, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cricket', 'dot Cricket Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.crown', 'Crown Equipment Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.crs', 'Federated Co-operatives Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cruise', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cruises', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.csc', 'Alliance-One Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cuisinella', 'SALM S.A.S.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cx', 'Christmas Island Domain Administration Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cymru', 'Nominet UK');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cyou', 'Shortdot SA');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.cz', 'CZ.NIC, z.s.p.o.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dabur', 'Dabur India Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dad', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dance', 'United TLD Holdco Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.data', 'Dish DBS Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.date', 'dot Date Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dating', 'Dog Beach, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.datsun', 'NISSAN MOTOR CO., LTD.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.day', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dclk', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dds', 'Dog Beach, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.deal', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dealer', 'Dealer Dot Com, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.deals', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.degree', 'United TLD Holdco, Ltd');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.delivery', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dell', 'Dell Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.deloitte', 'Deloitte Touche Tohmatsu');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.delta', 'Delta Air Lines, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.democrat', 'United TLD Holdco, Ltd');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dental', 'United TLD Holdco, Ltd');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dentist', 'United TLD Holdco, Ltd');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.desi', 'Desi Networks LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.design', 'Top Level Design, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dev', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dhl', 'Deutsche Post AG');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.diamonds', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.diet', 'Uniregistry, Corp.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.digital', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.direct', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.directory', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.discount', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.discover', 'Discover Financial Services');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dish', 'Dish DBS Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.diy', 'Lifestyle Domain Holdings, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dj', 'Djibouti Telecom SA');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dk', 'Dansk Internet Forum');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dm', 'DotDM Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dnp', 'Dai Nippon Printing Co., Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.do', 'Pontificia Universidad Católica Madre y MaestraRecinto Santo Tomás de Aquino');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.docs', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.doctor', 'Brice Trail, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dodge', 'FCA US LLC.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dog', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.doha', 'Communications Regulatory Authority');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.domains', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.doosan', 'Doosan Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dot', 'Dish DBS Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.download', 'dot Support Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.drive', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dtv', 'Dish DBS Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dubai', 'Dubai Multi Commodities Centre Authority (DMCC)');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.duck', 'Johnson Shareholdings, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dunlop', 'The Goodyear Tire & Rubber Company');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.duns', 'The Dun & Bradstreet Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dupont', 'E. I. du Pont de Nemours and Company');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.durban', 'ZA Central Registry NPC trading as ZA Central Registry');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dvag', 'Deutsche Vermögensberatung Aktiengesellschaft DVAG');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dvr', 'Dish DBS Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.dz', 'CERIST');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.earth', 'Interlink Co., Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.eat', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.eco', 'Big Room Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.edeka', 'EDEKA Verband kaufmännischer Genossenschaften e.V.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.edu', 'Educause');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.education', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.email', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.emerck', 'Merck KGaA');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.energy', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.engineer', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.engineering', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.enterprises', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.epson', 'Seiko Epson Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.equipment', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.ericsson', 'Telefonaktiebolaget L M Ericsson');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.erni', 'Ernst & Young GmbH Wirtschaftsprüfungsgesellschaft');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.es', 'Red.es');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.esq', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.estate', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.esurance', 'Esurance Insurance Company');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.etisalat', 'Emirates Telecommunications Corporation ("Etisalat")');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.eu', 'EURid vzw/asbl');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.eurovision', 'European Broadcasting Union (EBU)');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.eus', 'PuntuEUS Fundazioa');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.events', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.exchange', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.expert', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.exposed', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.express', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.extraspace', 'Extra Space Storage LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fage', 'Fage International S.A.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fail', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fairwinds', 'FairWinds Partners, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.faith', 'dot Faith Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.family', 'Dog Beach, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fan', 'Dog Beach, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fans', 'Asiamix Digital Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.farm', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.farmers', 'Farmers Insurance Exchange');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fashion', 'Dog Beach, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fast', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fedex', 'Federal Express Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.feedback', 'Top Level Spectrum, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.ferrari', 'Fiat Chrysler Automobiles N.V.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.ferrero', 'Ferrero Trading Lux S.A.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fi', 'Finnish Transport and Communications Agency (Traficom)');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fiat', 'Fiat Chrysler Automobiles N.V.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fidelity', 'Fidelity Brokerage Services LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fido', 'Rogers Communications Canada Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.film', 'Motion Picture Domain Registry Pty Ltd');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.final', 'Núcleo de Informação e Coordenação do Ponto BR - NIC.br');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.finance', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.financial', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fire', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.firestone', 'Bridgestone Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.firmdale', 'Firmdale Holdings Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fish', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fishing', 'Top Level Domain Holdings Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fit', 'Minds + Machines Group Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fitness', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fj', 'University of the South Pacific');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fk', 'Falkland Islands Government');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.flickr', 'Yahoo Assets LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.flights', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.flir', 'FLIR Systems, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.florist', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.flowers', 'Uniregistry, Corp.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fly', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fm', 'FSM Telecommunications Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fo', 'Føroya Tele P/F');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.foo', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.food', 'Lifestyle Domain Holdings, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.foodnetwork', 'Lifestyle Domain Holdings, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.football', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.ford', 'Ford Motor Company');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.forex', 'Dotforex Registry Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.forsale', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.forum', 'Fegistry, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.foundation', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fox', 'FOX Registry, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fr', 'Association Française pour le Nommage Internet en Coopération (A.F.N.I.C.)');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.free', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fresenius', 'Fresenius Immobilien-Verwaltungs-GmbH');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.frl', 'FRLregistry B.V.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.frogans', 'OP3FT');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.frontdoor', 'Lifestyle Domain Holdings, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.frontier', 'Frontier Communications Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.ftr', 'Frontier Communications Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fujitsu', 'Fujitsu Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fujixerox', 'Xerox DNHC LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fun', 'DotSpace, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fund', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.furniture', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.futbol', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.fyi', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.ga', 'Agence des Technologies de l’Information et de la Communication (AGETIC)');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gal', 'Asociación puntoGAL');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gallery', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gallo', 'Gallo Vineyards, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gallup', 'Gallup, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.game', 'Uniregistry, Corp.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.games', 'United TLD Holdco Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gap', 'The Gap, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.garden', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gay', 'Top Level Design, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gb', 'Reserved Domain - IANA');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gbiz', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gd', 'The National Telecommunications Regulatory Commission (NTRC)');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gdn', 'Joint Stock Company "Navigation-information systems"');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.ge', 'Caucasus Online');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gea', 'Géant Association');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gent', 'Combell NV');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.genting', 'Resorts World Inc. Pte. Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.george', 'Wal-Mart Stores, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gf', 'Net Plus');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gg', 'Island Networks Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.ggee', 'GMO Internet, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gh', 'Network Computer Systems Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gi', 'Sapphire Networks');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gift', 'Uniregistry, Corp.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gifts', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gives', 'Dog Beach, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.giving', 'Giving Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gl', 'TELE Greenland A/S');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.glass', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gle', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.global', 'Dot Global Domain Registry Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.globo', 'Globo Comunicação e Participações S.A');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gmail', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gmbh', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gmo', 'GMO Internet, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gmx', '1&1 Mail & Media GmbH');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gn', 'Centre National des Sciences Halieutiques de Boussoura');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.godaddy', 'Go Daddy East, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gold', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.goldpoint', 'YODOBASHI CAMERA CO.,LTD.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.golf', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.goo', 'NTT Resonant Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.goodyear', 'The Goodyear Tire & Rubber Company');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.goog', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.google', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gop', 'Republican State Leadership Committee, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.got', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gov', 'Cybersecurity and Infrastructure Security Agency');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gp', 'Networking Technologies Group');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gq', 'GETESA');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gr', 'ICS-FORTH GR');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.grainger', 'Grainger Registry Services, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.graphics', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gratis', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.green', 'Afilias Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gripe', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.grocery', 'Wal-Mart Stores, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.group', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gs', 'Government of South Georgia and South Sandwich Islands (GSGSSI)');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gt', 'Universidad del Valle de Guatemala');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gucci', 'Guccio Gucci S.p.a.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.guge', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.guide', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.guitars', 'Uniregistry, Corp.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.guru', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gw', 'Autoridade Reguladora Nacional - Tecnologias de Informação e Comunicação da Guiné-Bissau');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.gy', 'University of Guyana');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hamburg', 'Hamburg Top-Level-Domain GmbH');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hangout', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.haus', 'United TLD Holdco Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hbo', 'HBO Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hdfc', 'HOUSING DEVELOPMENT FINANCE CORPORATION LIMITED');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hdfcbank', 'HDFC Bank Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.health', 'DotHealth, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.healthcare', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.help', 'Uniregistry, Corp.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.helsinki', 'City of Helsinki');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.here', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hermes', 'Hermes International');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hgtv', 'Lifestyle Domain Holdings, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hiphop', 'Uniregistry, Corp.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hisamitsu', 'Hisamitsu Pharmaceutical Co.,Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hitachi', 'Hitachi, Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hiv', 'Uniregistry, Corp.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hk', 'Hong Kong Internet Registration Corporation Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hkt', 'PCCW-HKT DataCom Services Limited');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hm', 'HM Domain Registry');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hn', 'Red de Desarrollo Sostenible Honduras');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hockey', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.holdings', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.holiday', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.homedepot', 'Home Depot Product Authority, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.homegoods', 'The TJX Companies, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.homes', 'DERHomes, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.homesense', 'The TJX Companies, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.honda', 'Honda Motor Co., Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.horse', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hospital', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.host', 'DotHost Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hosting', 'United TLD Holdco Ltd.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hot', 'Amazon Registry Services, Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hoteles', 'Travel Reservations SRL');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hotels', 'Booking.com B.V.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hotmail', 'Microsoft Corporation');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.house', 'Binky Moon, LLC');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.how', 'Charleston Road Registry Inc.');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hr', 'CARNet - Croatian Academic and Research Network');

INSERT INTO dominios (domain_type, tld, manager) VALUES  ('generic', '.hsbc', 'HSBC Global Services');


-- Sample data
INSERT INTO users (username, user_password, email) VALUES ('usuario', '12345678', 'usuario@gmail.com');
INSERT INTO users (username, user_password, email) VALUES ('prueba', '12345678', 'usuario2@gmail.com');
INSERT INTO customers (customer_name, age, gender, balance, user_profile) VALUES ('John', 32, 'M', 2030.0, 1);
INSERT INTO customers (customer_name, age, gender, balance, user_profile) VALUES ('Pepe', 32, 'M', 2030.0, 2);
INSERT INTO games (game_type, money_pool, user_profile) VALUES ('SlotMachine', 50000.0, 1);
INSERT INTO games (game_type, money_pool, user_profile) VALUES ('Blackjack', 50000.0, 1);
INSERT INTO games (game_type, money_pool, user_profile) VALUES ('SlotMachine', 50000.0, 2);
INSERT INTO games (game_type, money_pool, user_profile) VALUES ('Blackjack', 50000.0, 2);

-- UPDATE users SET email = "caca@gmail.com" WHERE id = 1;

-- Uncomment for testing
-- SELECT * FROM customers;
-- SELECT * FROM game_sessions;
-- SELECT * FROM games;
-- SELECT * FROM users;
-- SHOW TRIGGERS;

-- SET sql_safe_updates = 0;

-- DELETE FROM customers;
-- DELETE FROM games;