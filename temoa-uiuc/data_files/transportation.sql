BEGIN TRANSACTION;
CREATE TABLE "time_season" (
	"t_season"	text,
	PRIMARY KEY("t_season")
);
INSERT INTO "time_season" VALUES('annual');

CREATE TABLE "time_periods" (
	"t_periods"	integer,
	"flag"	text,
	PRIMARY KEY("t_periods"),
	FOREIGN KEY("flag") REFERENCES "time_period_labels"("t_period_labels")
);
INSERT INTO "time_periods" VALUES(2020, 'e');
INSERT INTO "time_periods" VALUES(2030, 'f');
INSERT INTO "time_periods" VALUES(2040, 'f');
INSERT INTO "time_periods" VALUES(2050, 'f');
INSERT INTO "time_periods" VALUES(2060, 'f');

CREATE TABLE "time_period_labels" (
	"t_period_labels"	text,
	"t_period_labels_desc"	text,
	PRIMARY KEY("t_period_labels")
);
INSERT INTO "time_period_labels" VALUES ('e','existing vintages');
INSERT INTO "time_period_labels" VALUES ('f','future');

CREATE TABLE "time_of_day" (
	"t_day"	text,
	PRIMARY KEY("t_day")
);
INSERT INTO "time_of_day" VALUES('all');

CREATE TABLE "technology_labels" (
	"tech_labels"	text,
	"tech_labels_desc"	text,
	PRIMARY KEY("tech_labels")
);
INSERT INTO "technology_labels" VALUES ('r','resource technology');
INSERT INTO "technology_labels" VALUES ('p','production technology');

CREATE TABLE "technologies" (
	"tech"	text,
	"flag"	text,
	"sector"	text,
	"tech_desc"	text,
	"tech_category"	text,
	PRIMARY KEY("tech"),
	FOREIGN KEY("flag") REFERENCES "technology_labels"("tech_labels"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector")
);
INSERT INTO "technologies" VALUES('IMPELC','r','electric', 'imported electricity','MISO');
INSERT INTO "technologies" VALUES('ELECTROL', 'r', 'electric', 'electrolysis converts elc to h2', 'hydrogen');
INSERT INTO "technologies" VALUES('ELCVCL','p','transport', 'electric vehicle','electricity');
INSERT INTO "technologies" VALUES('H2VCL','p','transport', 'hydrogen vehicle','hydrogen');


-- CREATE TABLE "tech_reserve" (
-- 	"tech"	text,
-- 	"notes"	text,
-- 	PRIMARY KEY("tech")
-- );
-- CREATE TABLE "tech_exchange" (
-- 	"tech"	text,
-- 	"notes"	TEXT,
-- 	PRIMARY KEY("tech"),
-- 	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
-- );
-- CREATE TABLE "tech_curtailment" (
-- 	"tech"	text,
-- 	"notes"	TEXT,
-- 	PRIMARY KEY("tech"),
-- 	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
-- );
-- CREATE TABLE "tech_annual" (
-- 	"tech"	text,
-- 	"notes"	TEXT,
-- 	PRIMARY KEY("tech"),
-- 	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
-- );

CREATE TABLE "sector_labels" (
	"sector"	text,
	PRIMARY KEY("sector")
);
INSERT INTO "sector_labels" VALUES ('supply');
INSERT INTO "sector_labels" VALUES ('transport');


CREATE TABLE "regions" (
	"regions"	TEXT,
	"region_note"	TEXT,
	PRIMARY KEY("regions")
);
INSERT INTO "regions" VALUES ('us', 'United States');

-- CREATE TABLE "groups" (
-- 	"group_name"	text,
-- 	"notes"	text,
-- 	PRIMARY KEY("group_name")
-- );

CREATE TABLE "commodity_labels" (
	"comm_labels"	text,
	"comm_labels_desc"	text,
	PRIMARY KEY("comm_labels")
);
INSERT INTO "commodity_labels" VALUES ('p','physical commodity');
INSERT INTO "commodity_labels" VALUES ('e','emissions commodity');
INSERT INTO "commodity_labels" VALUES ('d','demand commodity');

CREATE TABLE "commodities" (
	"comm_name"	text,
	"flag"	text,
	"comm_desc"	text,
	PRIMARY KEY("comm_name"),
	FOREIGN KEY("flag") REFERENCES "commodity_labels"("comm_labels")
);
INSERT INTO "commodities" VALUES('ewaste','e','waste from batteries');
INSERT INTO "commodities" VALUES('ethos','p','# dummy commodity');
INSERT INTO "commodities" VALUES('H2', 'p', 'hydrogen');
INSERT INTO "commodities" VALUES('ELC', 'p', 'electricity');
INSERT INTO "commodities" VALUES('TRANSPORT', 'd', 'miles driven');



-- CREATE TABLE "TechOutputSplit" (
-- 	"regions"	TEXT,
-- 	"periods"	integer,
-- 	"tech"	TEXT,
-- 	"output_comm"	text,
-- 	"to_split"	real,
-- 	"to_split_notes"	text,
-- 	PRIMARY KEY("regions","periods","tech","output_comm"),
-- 	FOREIGN KEY("output_comm") REFERENCES "commodities"("comm_name"),
-- 	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
-- 	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
-- );
-- CREATE TABLE "TechInputSplit" (
-- 	"regions"	TEXT,
-- 	"periods"	integer,
-- 	"input_comm"	text,
-- 	"tech"	text,
-- 	"ti_split"	real,
-- 	"ti_split_notes"	text,
-- 	PRIMARY KEY("regions","periods","input_comm","tech"),
-- 	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
-- 	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name"),
-- 	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods")
-- );
-- CREATE TABLE "StorageDuration" (
-- 	"regions"	text,
-- 	"tech"	text,
-- 	"duration"	real,
-- 	"duration_notes"	text,
-- 	PRIMARY KEY("regions","tech")
-- );
CREATE TABLE "SegFrac" (
	"season_name"	text,
	"time_of_day_name"	text,
	"segfrac"	real CHECK("segfrac" >= 0 AND "segfrac" <= 1),
	"segfrac_notes"	text,
	PRIMARY KEY("season_name","time_of_day_name"),
	FOREIGN KEY("season_name") REFERENCES "time_season"("t_season"),
	FOREIGN KEY("time_of_day_name") REFERENCES "time_of_day"("t_day")
);
INSERT INTO "SegFrac" VALUES('annual', 'all', 1, '');
-- CREATE TABLE "PlanningReserveMargin" (
-- 	`regions`	text,
-- 	`reserve_margin`	REAL,
-- 	PRIMARY KEY(regions),
-- 	FOREIGN KEY(`regions`) REFERENCES regions
-- );

CREATE TABLE "Output_V_Capacity" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"tech"	text,
	"vintage"	integer,
	"capacity"	real,
	PRIMARY KEY("regions","scenario","tech","vintage"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE "Output_VFlow_Out" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"t_periods"	integer,
	"t_season"	text,
	"t_day"	text,
	"input_comm"	text,
	"tech"	text,
	"vintage"	integer,
	"output_comm"	text,
	"vflow_out"	real,
	PRIMARY KEY("regions","scenario","t_periods","t_season","t_day","input_comm","tech","vintage","output_comm"),
	FOREIGN KEY("output_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("t_season") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	FOREIGN KEY("t_day") REFERENCES "time_of_day"("t_day"),
	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name")
);
CREATE TABLE "Output_VFlow_In" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"t_periods"	integer,
	"t_season"	text,
	"t_day"	text,
	"input_comm"	text,
	"tech"	text,
	"vintage"	integer,
	"output_comm"	text,
	"vflow_in"	real,
	PRIMARY KEY("regions","scenario","t_periods","t_season","t_day","input_comm","tech","vintage","output_comm"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("output_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	FOREIGN KEY("t_season") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("t_day") REFERENCES "time_of_day"("t_day"),
	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE "Output_Objective" (
	"scenario"	text,
	"objective_name"	text,
	"total_system_cost"	real
);
CREATE TABLE "Output_Emissions" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"t_periods"	integer,
	"emissions_comm"	text,
	"tech"	text,
	"vintage"	integer,
	"emissions"	real,
	PRIMARY KEY("regions","scenario","t_periods","emissions_comm","tech","vintage"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("emissions_comm") REFERENCES "EmissionActivity"("emis_comm"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE "Output_Curtailment" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"t_periods"	integer,
	"t_season"	text,
	"t_day"	text,
	"input_comm"	text,
	"tech"	text,
	"vintage"	integer,
	"output_comm"	text,
	"curtailment"	real,
	PRIMARY KEY("regions","scenario","t_periods","t_season","t_day","input_comm","tech","vintage","output_comm"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("output_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("t_season") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("t_day") REFERENCES "time_of_day"("t_day")
);
CREATE TABLE "Output_Costs" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"output_name"	text,
	"tech"	text,
	"vintage"	integer,
	"output_cost"	real,
	PRIMARY KEY("regions","scenario","output_name","tech","vintage"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE "Output_CapacityByPeriodAndTech" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"t_periods"	integer,
	"tech"	text,
	"capacity"	real,
	PRIMARY KEY("regions","scenario","t_periods","tech"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);

-- CREATE TABLE "MyopicBaseyear" (
-- 	"year"	real
-- 	"notes"	text
-- );
-- CREATE TABLE "MinGenGroupWeight" (
-- 	"regions"	text,
-- 	"tech"	text,
-- 	"group_name"	text,
-- 	"act_fraction"	REAL,
-- 	"tech_desc"	text,
-- 	PRIMARY KEY("tech","group_name","regions")
-- );
-- CREATE TABLE "MinGenGroupTarget" (
-- 	"regions"	text,
-- 	"periods"	integer,
-- 	"group_name"	text,
-- 	"min_act_g"	real,
-- 	"notes"	text,
-- 	PRIMARY KEY("periods","group_name","regions")
-- );
--
-- CREATE TABLE "MinCapacity" (
-- 	"regions"	text,
-- 	"periods"	integer,
-- 	"tech"	text,
-- 	"mincap"	real,
-- 	"mincap_units"	text,
-- 	"mincap_notes"	text,
-- 	PRIMARY KEY("regions","periods","tech"),
-- 	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
-- 	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods")
-- );
--
-- CREATE TABLE "MinActivity" (
-- 	"regions"	text,
-- 	"periods"	integer,
-- 	"tech"	text,
-- 	"minact"	real,
-- 	"minact_units"	text,
-- 	"minact_notes"	text,
-- 	PRIMARY KEY("regions","periods","tech"),
-- 	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
-- 	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods")
-- );
--
-- CREATE TABLE "MaxCapacity" (
-- 	"regions"	text,
-- 	"periods"	integer,
-- 	"tech"	text,
-- 	"maxcap"	real,
-- 	"maxcap_units"	text,
-- 	"maxcap_notes"	text,
-- 	PRIMARY KEY("regions","periods","tech"),
-- 	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
-- 	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
-- );
--
-- CREATE TABLE "MaxActivity" (
-- 	"regions"	text,
-- 	"periods"	integer,
-- 	"tech"	text,
-- 	"maxact"	real,
-- 	"maxact_units"	text,
-- 	"maxact_notes"	text,
-- 	PRIMARY KEY("regions","periods","tech"),
-- 	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
-- 	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
-- );

CREATE TABLE "LifetimeTech" (
	"regions"	text,
	"tech"	text,
	"life"	real,
	"life_notes"	text,
	PRIMARY KEY("regions","tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
INSERT INTO "LifetimeTech" VALUES("us", "ELCVCL", 12, 'vehicle lifetime is 12 years');
INSERT INTO "LifetimeTech" VALUES("us", "H2VCL", 12, 'vehicle lifetime is 12 years');
INSERT INTO "LifetimeTech" VALUES("us", "IMPELC", 1000, '');
INSERT INTO "LifetimeTech" VALUES("us", "ELECTROL", 1000, '');


-- CREATE TABLE "LifetimeProcess" (
-- 	"regions"	text,
-- 	"tech"	text,
-- 	"vintage"	integer,
-- 	"life_process"	real,
-- 	"life_process_notes"	text,
-- 	PRIMARY KEY("regions","tech","vintage"),
-- 	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
-- 	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
-- );
--

CREATE TABLE "LifetimeLoanTech" (
	"regions"	text,
	"tech"	text,
	"loan"	real,
	"loan_notes"	text,
	PRIMARY KEY("regions","tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
INSERT INTO "LifetimeLoanTech" VALUES("us", "ELCVCL", 6, 'loan lasts 6 years');
INSERT INTO "LifetimeLoanTech" VALUES("us", "H2VCL", 6, 'loan lasts 6 years');

-- CREATE TABLE "GrowthRateSeed" (
-- 	"regions"	text,
-- 	"tech"	text,
-- 	"growthrate_seed"	real,
-- 	"growthrate_seed_units"	text,
-- 	"growthrate_seed_notes"	text,
-- 	PRIMARY KEY("regions","tech"),
-- 	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
-- );
-- CREATE TABLE "GrowthRateMax" (
-- 	"regions"	text,
-- 	"tech"	text,
-- 	"growthrate_max"	real,
-- 	"growthrate_max_notes"	text,
-- 	PRIMARY KEY("regions","tech"),
-- 	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
-- );
CREATE TABLE "GlobalDiscountRate" (
	"rate"	real
);
INSERT INTO "GlobalDiscountRate" VALUES (0.05);


CREATE TABLE "ExistingCapacity" (
	"regions"	text,
	"tech"	text,
	"vintage"	integer,
	"exist_cap"	real,
	"exist_cap_units"	text,
	"exist_cap_notes"	text,
	PRIMARY KEY("regions","tech","vintage"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods")
);
INSERT INTO "ExistingCapacity" VALUES('us', 'IMPELC', 2020, 60000, 'units: MWe', 'if 100% to electricity');
INSERT INTO "ExistingCapacity" VALUES('us', 'ELECTROL', 2020, 60000, 'units: MWe', 'H2');
INSERT INTO "ExistingCapacity" VALUES('us', 'H2VCL', 2020, 6500, 'one car', '');
INSERT INTO "ExistingCapacity" VALUES('us', 'ELCVCL', 2020, 543610, 'one car', '');

CREATE TABLE "EmissionLimit" (
	"regions"	text,
	"periods"	integer,
	"emis_comm"	text,
	"emis_limit"	real,
	"emis_limit_units"	text,
	"emis_limit_notes"	text,
	PRIMARY KEY("periods","emis_comm"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("emis_comm") REFERENCES "commodities"("comm_name")
);
CREATE TABLE "EmissionActivity" (
	"regions"	text,
	"emis_comm"	text,
	"input_comm"	text,
	"tech"	text,
	"vintage"	integer,
	"output_comm"	text,
	"emis_act"	real,
	"emis_act_units"	text,
	"emis_act_notes"	text,
	PRIMARY KEY("regions","emis_comm","input_comm","tech","vintage","output_comm"),
	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("output_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("emis_comm") REFERENCES "commodities"("comm_name")
);
CREATE TABLE "Efficiency" (
	"regions"	text,
	"input_comm"	text,
	"tech"	text,
	"vintage"	integer,
	"output_comm"	text,
	"efficiency"	real CHECK("efficiency" > 0),
	"eff_notes"	text,
	PRIMARY KEY("regions","input_comm","tech","vintage","output_comm"),
	FOREIGN KEY("output_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name")
);

INSERT INTO "Efficiency" VALUES('us', 'ethos', 'IMPELC', 2020, 'ELC', 1.00,'pure electricity import');
INSERT INTO "Efficiency" VALUES('us', 'ELC', 'ELECTROL', 2020, 'H2', 0.67, 'converts ELC to H2 efficiency kWh/kg-H2');
INSERT INTO "Efficiency" VALUES('us', 'ELC', 'ELECTROL', 2030, 'H2', 0.67, 'converts ELC to H2 efficiency kWh/kg-H2');
INSERT INTO "Efficiency" VALUES('us', 'ELC', 'ELECTROL', 2040, 'H2', 0.67, 'converts ELC to H2 efficiency kWh/kg-H2');
INSERT INTO "Efficiency" VALUES('us', 'ELC', 'ELECTROL', 2050, 'H2', 0.67, 'converts ELC to H2 efficiency kWh/kg-H2');
INSERT INTO "Efficiency" VALUES('us', 'H2', 'H2VCL', 2020, 'TRANSPORT', 71.78, 'miles per kg H2, Mirai');
INSERT INTO "Efficiency" VALUES('us', 'H2', 'H2VCL', 2030, 'TRANSPORT', 71.78, 'miles per kg H2, Mirai');
INSERT INTO "Efficiency" VALUES('us', 'H2', 'H2VCL', 2040, 'TRANSPORT', 71.78, 'miles per kg H2, Mirai');
INSERT INTO "Efficiency" VALUES('us', 'H2', 'H2VCL', 2050, 'TRANSPORT', 71.78, 'miles per kg H2, Mirai');
INSERT INTO "Efficiency" VALUES('us', 'ELC', 'ELCVCL', 2020, 'TRANSPORT', 4.44, 'miles per kWh, Ioniq');
INSERT INTO "Efficiency" VALUES('us', 'ELC', 'ELCVCL', 2030, 'TRANSPORT', 4.44, 'miles per kWh, Ioniq');
INSERT INTO "Efficiency" VALUES('us', 'ELC', 'ELCVCL', 2040, 'TRANSPORT', 4.44, 'miles per kWh, Ioniq');
INSERT INTO "Efficiency" VALUES('us', 'ELC', 'ELCVCL', 2050, 'TRANSPORT', 4.44, 'miles per kWh, Ioniq');

CREATE TABLE "DiscountRate" (
	"regions"	text,
	"tech"	text,
	"vintage"	integer,
	"tech_rate"	real,
	"tech_rate_notes"	text,
	PRIMARY KEY("regions","tech","vintage"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods")
);
-- CREATE TABLE "DemandSpecificDistribution" (
-- 	"regions"	text,
-- 	"season_name"	text,
-- 	"time_of_day_name"	text,
-- 	"demand_name"	text,
-- 	"dds"	real CHECK("dds" >= 0 AND "dds" <= 1),
-- 	"dds_notes"	text,
-- 	PRIMARY KEY("regions","season_name","time_of_day_name","demand_name"),
-- 	FOREIGN KEY("season_name") REFERENCES "time_season"("t_season"),
-- 	FOREIGN KEY("time_of_day_name") REFERENCES "time_of_day"("t_day"),
-- 	FOREIGN KEY("demand_name") REFERENCES "commodities"("comm_name")
-- );
CREATE TABLE "Demand" (
	"regions"	text,
	"periods"	integer,
	"demand_comm"	text,
	"demand"	real,
	"demand_units"	text,
	"demand_notes"	text,
	PRIMARY KEY("regions","periods","demand_comm"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("demand_comm") REFERENCES "commodities"("comm_name")
);
-- INSERT INTO "Demand" VALUES('us', 2020, 'TRANSPORT', 3000000000, 'miles', 'annual demand in miles');
INSERT INTO "Demand" VALUES('us', 2030, 'TRANSPORT', 3000000000, 'miles', 'annual demand in miles');
INSERT INTO "Demand" VALUES('us', 2040, 'TRANSPORT', 3000000000, 'miles', 'annual demand in miles');
INSERT INTO "Demand" VALUES('us', 2050, 'TRANSPORT', 3000000000, 'miles', 'annual demand in miles');

CREATE TABLE "CostVariable" (
	"regions"	text NOT NULL,
	"periods"	integer NOT NULL,
	"tech"	text NOT NULL,
	"vintage"	integer NOT NULL,
	"cost_variable"	real,
	"cost_variable_units"	text,
	"cost_variable_notes"	text,
	PRIMARY KEY("regions","periods","tech","vintage"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods")
);
-- INSERT INTO "CostVariable" VALUES("us", 2020, 'ELCVCL', 2020, 0.11, 'dollars per kWh', '');
INSERT INTO "CostVariable" VALUES("us", 2030, 'ELCVCL', 2030, 0.11, 'dollars per kWh', '');
INSERT INTO "CostVariable" VALUES("us", 2040, 'ELCVCL', 2040, 0.11, 'dollars per kWh', '');
INSERT INTO "CostVariable" VALUES("us", 2050, 'ELCVCL', 2050, 0.11, 'dollars per kWh', '');
-- INSERT INTO "CostVariable" VALUES("us", 2020, 'H2VCL', 2020, 13.11, 'dollars per kg H2', '');
INSERT INTO "CostVariable" VALUES("us", 2030, 'H2VCL', 2030, 6.00, 'dollars per kg H2', '');
INSERT INTO "CostVariable" VALUES("us", 2040, 'H2VCL', 2040, 4.00, 'dollars per kg H2', '');
INSERT INTO "CostVariable" VALUES("us", 2050, 'H2VCL', 2050, 4.00, 'dollars per kg H2', '');



CREATE TABLE "CostInvest" (
	"regions"	text,
	"tech"	text,
	"vintage"	integer,
	"cost_invest"	real,
	"cost_invest_units"	text,
	"cost_invest_notes"	text,
	PRIMARY KEY("regions","tech","vintage"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods")
);

-- INSERT INTO "CostInvest" VALUES("us", 'ELCVCL', 2020, 6702.5, 'dollars per car', '');
INSERT INTO "CostInvest" VALUES("us", 'ELCVCL', 2030, 2795.9, 'dollars per car', '');
INSERT INTO "CostInvest" VALUES("us", 'ELCVCL', 2040, 2795.9, 'dollars per car', '');
INSERT INTO "CostInvest" VALUES("us", 'ELCVCL', 2050, 2795.9, 'dollars per car', '');
-- INSERT INTO "CostInvest" VALUES("us", 'H2VCL', 2020, 8537.0, 'dollars per car', '');
INSERT INTO "CostInvest" VALUES("us", 'H2VCL', 2030, 5850.5, 'dollars per car', '');
INSERT INTO "CostInvest" VALUES("us", 'H2VCL', 2040, 4890.5, 'dollars per car', '');
INSERT INTO "CostInvest" VALUES("us", 'H2VCL', 2050, 3930.5, 'dollars per car', '');

CREATE TABLE "CostFixed" (
	"regions"	text NOT NULL,
	"periods"	integer NOT NULL,
	"tech"	text NOT NULL,
	"vintage"	integer NOT NULL,
	"cost_fixed"	real,
	"cost_fixed_units"	text,
	"cost_fixed_notes"	text,
	PRIMARY KEY("regions","periods","tech","vintage"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE "CapacityToActivity" (
	"regions"	text,
	"tech"	text,
	"c2a"	real,
	"c2a_notes"	TEXT,
	PRIMARY KEY("regions","tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
INSERT INTO "CapacityToActivity" VALUES('us', 'ELCVCL', 394200, 'Assumes 45 mph average speed');
INSERT INTO "CapacityToActivity" VALUES('us', 'H2VCL', 394200, 'Assumes 45 mph average speed');
INSERT INTO "CapacityToActivity" VALUES('us', 'IMPELC', 8760000, 'produces a kWh');
INSERT INTO "CapacityToActivity" VALUES('us', 'ELECTROL', 8760000, 'produces kgH2');


CREATE TABLE "CapacityFactorTech" (
	"regions"	text,
	"season_name"	text,
	"time_of_day_name"	text,
	"tech"	text,
	"cf_tech"	real CHECK("cf_tech" >= 0 AND "cf_tech" <= 1),
	"cf_tech_notes"	text,
	PRIMARY KEY("regions","season_name","time_of_day_name","tech"),
	FOREIGN KEY("season_name") REFERENCES "time_season"("t_season"),
	FOREIGN KEY("time_of_day_name") REFERENCES "time_of_day"("t_day"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
INSERT INTO "CapacityFactorTech" VALUES('us', 'annual', 'all', 'ELCVCL', 0.03, 'average car usage');
INSERT INTO "CapacityFactorTech" VALUES('us', 'annual', 'all', 'H2VCL', 0.03, 'average car usage');


CREATE TABLE "CapacityFactorProcess" (
	"regions"	text,
	"season_name"	text,
	"time_of_day_name"	text,
	"tech"	text,
	"vintage"	integer,
	"cf_process"	real CHECK("cf_process" >= 0 AND "cf_process" <= 1),
	"cf_process_notes"	text,
	PRIMARY KEY("regions","season_name","time_of_day_name","tech","vintage"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("season_name") REFERENCES "time_season"("t_season"),
	FOREIGN KEY("time_of_day_name") REFERENCES "time_of_day"("t_day")
);
CREATE TABLE "CapacityCredit" (
	"regions"	text,
	"periods"	integer,
	"tech"	text,
	"cf_tech"	real CHECK("cf_tech" >= 0 AND "cf_tech" <= 1),
	"cf_tech_notes"	text,
	PRIMARY KEY("regions","periods","tech")
);
COMMIT;
