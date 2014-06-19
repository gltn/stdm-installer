CREATE TABLE check_type (
	id serial,
	value character varying( 50),
	CONSTRAINT pk_check_type PRIMARY KEY (id));
CREATE TABLE check_document_type (
	id serial,
	value character varying( 50),
	CONSTRAINT pk_check_document_type PRIMARY KEY (id));
CREATE TABLE check_social_tenure_type (
	id serial,
	value character varying( 50),
	CONSTRAINT pk_check_social_tenure_type PRIMARY KEY (id));
CREATE TABLE party (
	id serial,
	family_name character varying( 25),
	other_names character varying( 25),
	address character varying( 25),
	unique_id integer,
	contact_telephone character varying( 25),
	CONSTRAINT pk_party PRIMARY KEY (id));
CREATE TABLE spatial_unit (
	id serial,
	spatial_unit_id integer,
	name character varying( 25),
	type character varying( 25),
	CONSTRAINT pk_spatial_unit PRIMARY KEY (id));
CREATE TABLE supporting_document (
	id serial,
	document_type character varying( 25),
	party integer,
	spatial_unit integer,
	date_of_recording date,
	validity date,
	CONSTRAINT pk_supporting_document PRIMARY KEY (id));
CREATE TABLE social_tenure_relationship (
	id serial,
	social_tenure_type character varying( 25),
	share double precision,
	party integer,
	spatial_unit integer,
	CONSTRAINT pk_social_tenure_relationship PRIMARY KEY (id));
SELECT AddGeometryColumn('spatial_unit', 'geom_line', '4326','LINESTRING',2);
SELECT AddGeometryColumn('spatial_unit', 'geom_point', '4326','POINT',2);
SELECT AddGeometryColumn('spatial_unit', 'geom_polygon', '4326','POLYGON',2);
ALTER TABLE supporting_document ADD CONSTRAINT spid FOREIGN KEY (id) REFERENCES spatial_unit(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE supporting_document ADD CONSTRAINT pid FOREIGN KEY (id) REFERENCES party(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE social_tenure_relationship ADD CONSTRAINT partyid FOREIGN KEY (id) REFERENCES party(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE social_tenure_relationship ADD CONSTRAINT spid FOREIGN KEY (id) REFERENCES spatial_unit(id) ON DELETE CASCADE ON UPDATE CASCADE;
INSERT INTO check_type ("value") VALUES ('Point');
INSERT INTO check_type ("value") VALUES ('Line');
INSERT INTO check_type ("value") VALUES ('Polygon');
INSERT INTO check_document_type ("value") VALUES ('Audio Files');
INSERT INTO check_document_type ("value") VALUES ('Video Files');
INSERT INTO check_document_type ("value") VALUES ('Rent certificate');
INSERT INTO check_document_type ("value") VALUES ('Lease agreement');
INSERT INTO check_document_type ("value") VALUES ('Title');
INSERT INTO check_social_tenure_type ("value") VALUES ('Tenant');
INSERT INTO check_social_tenure_type ("value") VALUES ('Individual owner');
INSERT INTO check_social_tenure_type ("value") VALUES ('Part owner/shared ownership');
INSERT INTO check_social_tenure_type ("value") VALUES ('Lease');
INSERT INTO check_social_tenure_type ("value") VALUES ('Occupant');
INSERT INTO check_social_tenure_type ("value") VALUES ('Others');
