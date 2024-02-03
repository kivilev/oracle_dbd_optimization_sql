prompt PL/SQL Developer Export Tables for user D_KIVILEV@ORACLE21XE
prompt Created by d.kivilev on 23 Июнь 2023 г.
set feedback off
set define off

prompt Disabling triggers for CLIENT_DATA_FIELD...
alter table CLIENT_DATA_FIELD disable all triggers;
prompt Disabling triggers for COUNTRY...
alter table COUNTRY disable all triggers;
prompt Disabling triggers for CURRENCY...
alter table CURRENCY disable all triggers;
prompt Disabling triggers for COUNTRY_CURRENCY...
alter table COUNTRY_CURRENCY disable all triggers;
prompt Disabling triggers for COUNTRY_PHONE...
alter table COUNTRY_PHONE disable all triggers;
prompt Disabling triggers for PAYMENT_DETAIL_FIELD...
alter table PAYMENT_DETAIL_FIELD disable all triggers;
prompt Deleting PAYMENT_DETAIL_FIELD...
delete from PAYMENT_DETAIL_FIELD;
commit;
prompt Deleting COUNTRY_PHONE...
delete from COUNTRY_PHONE;
commit;
prompt Deleting COUNTRY_CURRENCY...
delete from COUNTRY_CURRENCY;
commit;
prompt Deleting CURRENCY...
delete from CURRENCY;
commit;
prompt Deleting COUNTRY...
delete from COUNTRY;
commit;
prompt Deleting CLIENT_DATA_FIELD...
delete from CLIENT_DATA_FIELD;
commit;
prompt Loading CLIENT_DATA_FIELD...
insert into CLIENT_DATA_FIELD (field_id, name, description)
values (1, 'FIRST_NAME', 'First name');
insert into CLIENT_DATA_FIELD (field_id, name, description)
values (2, 'LAST_NAME', 'Last name');
insert into CLIENT_DATA_FIELD (field_id, name, description)
values (3, 'BIRTHDAY', 'Birthday');
insert into CLIENT_DATA_FIELD (field_id, name, description)
values (4, 'PASSPORT_SERIES', 'Passport series');
insert into CLIENT_DATA_FIELD (field_id, name, description)
values (5, 'PASSPORT_NUMBER', 'Passport number');
insert into CLIENT_DATA_FIELD (field_id, name, description)
values (6, 'EMAIL', 'User E-mail');
insert into CLIENT_DATA_FIELD (field_id, name, description)
values (7, 'MOBILE_PHONE', 'Mobile phone number');
insert into CLIENT_DATA_FIELD (field_id, name, description)
values (8, 'MIDDLE_NAME', 'Middle name');
commit;
prompt 8 records loaded
prompt Loading COUNTRY...
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (270, 'ГАМБИЯ', 'GM', 'GMB');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (275, 'ПАЛЕСТИНСКАЯ ТЕРРИТОРИЯ, ОККУПИРОВАННАЯ', 'PS', 'PSE');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (276, 'ГЕРМАНИЯ', 'DE', 'DEU');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (288, 'ГАНА', 'GH', 'GHA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (292, 'ГИБРАЛТАР', 'GI', 'GIB');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (296, 'КИРИБАТИ', 'KI', 'KIR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (300, 'ГРЕЦИЯ', 'GR', 'GRC');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (304, 'ГРЕНЛАНДИЯ', 'GL', 'GRL');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (308, 'ГРЕНАДА', 'GD', 'GRD');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (312, 'ГВАДЕЛУПА', 'GP', 'GLP');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (316, 'ГУАМ', 'GU', 'GUM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (320, 'ГВАТЕМАЛА', 'GT', 'GTM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (324, 'ГВИНЕЯ', 'GN', 'GIN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (328, 'ГАЙАНА', 'GY', 'GUY');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (332, 'ГАИТИ', 'HT', 'HTI');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (334, 'ОСТРОВ ХЕРД И ОСТРОВА МАКДОНАЛЬД', 'HM', 'HMD');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (336, 'ПАПСКИЙ ПРЕСТОЛ (ГОСУДАРСТВО - ГОРОД ВАТИКАН)', 'VA', 'VAT');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (340, 'ГОНДУРАС', 'HN', 'HND');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (344, 'ГОНКОНГ', 'HK', 'HKG');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (348, 'ВЕНГРИЯ', 'HU', 'HUN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (352, 'ИСЛАНДИЯ', 'IS', 'ISL');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (356, 'ИНДИЯ', 'IN', 'IND');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (360, 'ИНДОНЕЗИЯ', 'ID', 'IDN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (364, 'ИРАН, ИСЛАМСКАЯ РЕСПУБЛИКА', 'IR', 'IRN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (368, 'ИРАК', 'IQ', 'IRQ');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (372, 'ИРЛАНДИЯ', 'IE', 'IRL');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (376, 'ИЗРАИЛЬ', 'IL', 'ISR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (380, 'ИТАЛИЯ', 'IT', 'ITA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (384, 'КОТ Д''ИВУАР', 'CI', 'CIV');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (388, 'ЯМАЙКА', 'JM', 'JAM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (392, 'ЯПОНИЯ', 'JP', 'JPN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (398, 'КАЗАХСТАН', 'KZ', 'KAZ');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (400, 'ИОРДАНИЯ', 'JO', 'JOR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (404, 'КЕНИЯ', 'KE', 'KEN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (408, 'КОРЕЯ, НАРОДНО-ДЕМОКРАТИЧЕСКАЯ РЕСПУБЛИКА', 'KP', 'PRK');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (410, 'КОРЕЯ, РЕСПУБЛИКА', 'KR', 'KOR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (414, 'КУВЕЙТ', 'KW', 'KWT');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (417, 'КИРГИЗИЯ', 'KG', 'KGZ');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (418, 'ЛАОССКАЯ НАРОДНО-ДЕМОКРАТИЧЕСКАЯ РЕСПУБЛИКА', 'LA', 'LAO');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (422, 'ЛИВАН', 'LB', 'LBN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (426, 'ЛЕСОТО', 'LS', 'LSO');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (428, 'ЛАТВИЯ', 'LV', 'LVA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (430, 'ЛИБЕРИЯ', 'LR', 'LBR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (434, 'ЛИВИЙСКАЯ АРАБСКАЯ ДЖАМАХИРИЯ', 'LY', 'LBY');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (438, 'ЛИХТЕНШТЕЙН', 'LI', 'LIE');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (440, 'ЛИТВА', 'LT', 'LTU');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (442, 'ЛЮКСЕМБУРГ', 'LU', 'LUX');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (446, 'МАКАО', 'MO', 'MAC');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (450, 'МАДАГАСКАР', 'MG', 'MDG');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (454, 'МАЛАВИ', 'MW', 'MWI');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (458, 'МАЛАЙЗИЯ', 'MY', 'MYS');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (462, 'МАЛЬДИВЫ', 'MV', 'MDV');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (466, 'МАЛИ', 'ML', 'MLI');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (470, 'МАЛЬТА', 'MT', 'MLT');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (474, 'МАРТИНИКА', 'MQ', 'MTQ');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (478, 'МАВРИТАНИЯ', 'MR', 'MRT');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (480, 'МАВРИКИЙ', 'MU', 'MUS');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (484, 'МЕКСИКА', 'MX', 'MEX');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (492, 'МОНАКО', 'MC', 'MCO');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (496, 'МОНГОЛИЯ', 'MN', 'MNG');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (498, 'МОЛДОВА, РЕСПУБЛИКА', 'MD', 'MDA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (499, 'ЧЕРНОГОРИЯ', 'ME', 'MNE');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (500, 'МОНТСЕРРАТ', 'MS', 'MSR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (504, 'МАРОККО', 'MA', 'MAR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (508, 'МОЗАМБИК', 'MZ', 'MOZ');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (512, 'ОМАН', 'OM', 'OMN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (516, 'НАМИБИЯ', 'NA', 'NAM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (520, 'НАУРУ', 'NR', 'NRU');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (524, 'НЕПАЛ', 'NP', 'NPL');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (528, 'НИДЕРЛАНДЫ', 'NL', 'NLD');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (531, 'КЮРАСАО', 'CW', 'CUW');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (533, 'АРУБА', 'AW', 'ABW');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (534, 'СЕН-МАРТЕН (нидерландская часть)', 'SX', 'SXM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (535, 'БОНЭЙР, СИНТ-ЭСТАТИУС И САБА', 'BQ', 'BES');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (540, 'НОВАЯ КАЛЕДОНИЯ', 'NC', 'NCL');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (548, 'ВАНУАТУ', 'VU', 'VUT');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (554, 'НОВАЯ ЗЕЛАНДИЯ', 'NZ', 'NZL');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (558, 'НИКАРАГУА', 'NI', 'NIC');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (562, 'НИГЕР', 'NE', 'NER');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (566, 'НИГЕРИЯ', 'NG', 'NGA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (570, 'НИУЭ', 'NU', 'NIU');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (574, 'ОСТРОВ НОРФОЛК', 'NF', 'NFK');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (578, 'НОРВЕГИЯ', 'NO', 'NOR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (580, 'СЕВЕРНЫЕ МАРИАНСКИЕ ОСТРОВА', 'MP', 'MNP');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (581, 'МАЛЫЕ ТИХООКЕАНСКИЕ ОТДАЛЕННЫЕ ОСТРОВА СОЕДИНЕННЫХ ШТАТОВ', 'UM', 'UMI');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (583, 'МИКРОНЕЗИЯ, ФЕДЕРАТИВНЫЕ ШТАТЫ', 'FM', 'FSM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (584, 'МАРШАЛЛОВЫ ОСТРОВА', 'MH', 'MHL');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (585, 'ПАЛАУ', 'PW', 'PLW');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (586, 'ПАКИСТАН', 'PK', 'PAK');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (591, 'ПАНАМА', 'PA', 'PAN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (598, 'ПАПУА-НОВАЯ ГВИНЕЯ', 'PG', 'PNG');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (600, 'ПАРАГВАЙ', 'PY', 'PRY');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (604, 'ПЕРУ', 'PE', 'PER');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (608, 'ФИЛИППИНЫ', 'PH', 'PHL');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (612, 'ПИТКЕРН', 'PN', 'PCN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (616, 'ПОЛЬША', 'PL', 'POL');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (620, 'ПОРТУГАЛИЯ', 'PT', 'PRT');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (624, 'ГВИНЕЯ-БИСАУ', 'GW', 'GNB');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (626, 'ТИМОР-ЛЕСТЕ', 'TL', 'TLS');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (630, 'ПУЭРТО-РИКО', 'PR', 'PRI');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (634, 'КАТАР', 'QA', 'QAT');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (638, 'РЕЮНЬОН', 'RE', 'REU');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (642, 'РУМЫНИЯ', 'RO', 'ROU');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (643, 'РОССИЯ', 'RU', 'RUS');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (646, 'РУАНДА', 'RW', 'RWA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (652, 'СЕН-БАРТЕЛЕМИ', 'BL', 'BLM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (654, 'СВЯТАЯ ЕЛЕНА, ОСТРОВ ВОЗНЕСЕНИЯ, ТРИСТАН-ДА-КУНЬЯ', 'SH', 'SHN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (659, 'СЕНТ-КИТС И НЕВИС', 'KN', 'KNA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (660, 'АНГИЛЬЯ', 'AI', 'AIA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (662, 'СЕНТ-ЛЮСИЯ', 'LC', 'LCA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (663, 'СЕН-МАРТЕН', 'MF', 'MAF');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (666, 'СЕН-ПЬЕР И МИКЕЛОН', 'PM', 'SPM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (191, 'ХОРВАТИЯ', 'HR', 'HRV');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (192, 'КУБА', 'CU', 'CUB');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (196, 'КИПР', 'CY', 'CYP');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (203, 'ЧЕШСКАЯ РЕСПУБЛИКА', 'CZ', 'CZE');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (204, 'БЕНИН', 'BJ', 'BEN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (208, 'ДАНИЯ', 'DK', 'DNK');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (212, 'ДОМИНИКА', 'DM', 'DMA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (214, 'ДОМИНИКАНСКАЯ РЕСПУБЛИКА', 'DO', 'DOM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (218, 'ЭКВАДОР', 'EC', 'ECU');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (222, 'ЭЛЬ-САЛЬВАДОР', 'SV', 'SLV');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (226, 'ЭКВАТОРИАЛЬНАЯ ГВИНЕЯ', 'GQ', 'GNQ');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (231, 'ЭФИОПИЯ', 'ET', 'ETH');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (232, 'ЭРИТРЕЯ', 'ER', 'ERI');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (233, 'ЭСТОНИЯ', 'EE', 'EST');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (234, 'ФАРЕРСКИЕ ОСТРОВА', 'FO', 'FRO');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (238, 'ФОЛКЛЕНДСКИЕ ОСТРОВА (МАЛЬВИНСКИЕ)', 'FK', 'FLK');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (239, 'ЮЖНАЯ ДЖОРДЖИЯ И ЮЖНЫЕ САНДВИЧЕВЫ ОСТРОВА', 'GS', 'SGS');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (242, 'ФИДЖИ', 'FJ', 'FJI');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (246, 'ФИНЛЯНДИЯ', 'FI', 'FIN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (248, 'ЭЛАНДСКИЕ ОСТРОВА', 'АХ', 'ALA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (250, 'ФРАНЦИЯ', 'FR', 'FRA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (254, 'ФРАНЦУЗСКАЯ ГВИАНА', 'GF', 'GUF');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (258, 'ФРАНЦУЗСКАЯ ПОЛИНЕЗИЯ', 'PF', 'PYF');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (260, 'ФРАНЦУЗСКИЕ ЮЖНЫЕ ТЕРРИТОРИИ', 'TF', 'ATF');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (262, 'ДЖИБУТИ', 'DJ', 'DJI');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (266, 'ГАБОН', 'GA', 'GAB');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (268, 'ГРУЗИЯ', 'GE', 'GEO');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (670, 'СЕНТ-ВИНСЕНТ И ГРЕНАДИНЫ', 'VC', 'VCT');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (674, 'САН-МАРИНО', 'SM', 'SMR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (678, 'САН-ТОМЕ И ПРИНСИПИ', 'ST', 'STP');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (682, 'САУДОВСКАЯ АРАВИЯ', 'SA', 'SAU');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (686, 'СЕНЕГАЛ', 'SN', 'SEN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (688, 'СЕРБИЯ', 'RS', 'SRB');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (690, 'СЕЙШЕЛЫ', 'SC', 'SYC');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (694, 'СЬЕРРА-ЛЕОНЕ', 'SL', 'SLE');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (702, 'СИНГАПУР', 'SG', 'SGP');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (703, 'СЛОВАКИЯ', 'SK', 'SVK');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (704, 'ВЬЕТНАМ', 'VN', 'VNM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (705, 'СЛОВЕНИЯ', 'SI', 'SVN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (706, 'СОМАЛИ', 'SO', 'SOM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (710, 'ЮЖНАЯ АФРИКА', 'ZA', 'ZAF');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (716, 'ЗИМБАБВЕ', 'ZW', 'ZWE');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (724, 'ИСПАНИЯ', 'ES', 'ESP');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (732, 'ЗАПАДНАЯ САХАРА', 'EH', 'ESH');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (736, 'СУДАН', 'SD', 'SDN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (740, 'СУРИНАМ', 'SR', 'SUR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (744, 'ШПИЦБЕРГЕН И ЯН МАЙЕН', 'SJ', 'SJM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (748, 'СВАЗИЛЕНД', 'SZ', 'SWZ');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (752, 'ШВЕЦИЯ', 'SE', 'SWE');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (756, 'ШВЕЙЦАРИЯ', 'CH', 'CHE');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (760, 'СИРИЙСКАЯ АРАБСКАЯ РЕСПУБЛИКА', 'SY', 'SYR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (762, 'ТАДЖИКИСТАН', 'TJ', 'TJK');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (764, 'ТАИЛАНД', 'TH', 'THA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (768, 'ТОГО', 'TG', 'TGO');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (772, 'ТОКЕЛАУ', 'TK', 'TKL');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (776, 'ТОНГА', 'TO', 'TON');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (780, 'ТРИНИДАД И ТОБАГО', 'TT', 'TTO');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (784, 'ОБЪЕДИНЕННЫЕ АРАБСКИЕ ЭМИРАТЫ', 'AE', 'ARE');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (788, 'ТУНИС', 'TN', 'TUN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (792, 'ТУРЦИЯ', 'TR', 'TUR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (795, 'ТУРКМЕНИЯ', 'TM', 'TKM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (796, 'ОСТРОВА ТЕРКС И КАЙКОС', 'TC', 'TCA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (798, 'ТУВАЛУ', 'TV', 'TUV');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (800, 'УГАНДА', 'UG', 'UGA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (804, 'УКРАИНА', 'UA', 'UKR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (807, 'РЕСПУБЛИКА МАКЕДОНИЯ', 'MK', 'MKD');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (818, 'ЕГИПЕТ', 'EG', 'EGY');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (826, 'СОЕДИНЕННОЕ КОРОЛЕВСТВО', 'GB', 'GBR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (831, 'ГЕРНСИ', 'GG', 'GGY');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (832, 'ДЖЕРСИ', 'JE', 'JEY');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (833, 'ОСТРОВ МЭН', 'IM', 'IMN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (834, 'ТАНЗАНИЯ, ОБЪЕДИНЕННАЯ РЕСПУБЛИКА', 'TZ', 'TZA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (840, 'СОЕДИНЕННЫЕ ШТАТЫ', 'US', 'USA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (850, 'ВИРГИНСКИЕ ОСТРОВА, США', 'VI', 'VIR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (854, 'БУРКИНА-ФАСО', 'BF', 'BFA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (858, 'УРУГВАЙ', 'UY', 'URY');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (860, 'УЗБЕКИСТАН', 'UZ', 'UZB');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (862, 'ВЕНЕСУЭЛА БОЛИВАРИАНСКАЯ РЕСПУБЛИКА', 'VE', 'VEN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (876, 'УОЛЛИС И ФУТУНА', 'WF', 'WLF');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (882, 'САМОА', 'WS', 'WSM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (887, 'ЙЕМЕН', 'YE', 'YEM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (894, 'ЗАМБИЯ', 'ZM', 'ZMB');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (895, 'АБХАЗИЯ', 'AB', 'ABH');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (896, 'ЮЖНАЯ ОСЕТИЯ', 'OS', 'OST');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (0, 'ЛИЦО БЕЗ ГРАЖДАНСТВА', 'ZZ', 'ZZZ');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (4, 'АФГАНИСТАН', 'AF', 'AFG');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (8, 'АЛБАНИЯ', 'AL', 'ALB');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (10, 'АНТАРКТИДА', 'AQ', 'ATA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (12, 'АЛЖИР', 'DZ', 'DZA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (16, 'АМЕРИКАНСКОЕ САМОА', 'AS', 'ASM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (20, 'АНДОРРА', 'AD', 'AND');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (24, 'АНГОЛА', 'AO', 'AGO');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (28, 'АНТИГУА И БАРБУДА', 'AG', 'ATG');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (31, 'АЗЕРБАЙДЖАН', 'AZ', 'AZE');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (32, 'АРГЕНТИНА', 'AR', 'ARG');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (36, 'АВСТРАЛИЯ', 'AU', 'AUS');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (40, 'АВСТРИЯ', 'AT', 'AUT');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (44, 'БАГАМЫ', 'BS', 'BHS');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (48, 'БАХРЕЙН', 'BH', 'BHR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (50, 'БАНГЛАДЕШ', 'BD', 'BGD');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (51, 'АРМЕНИЯ', 'AM', 'ARM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (52, 'БАРБАДОС', 'BB', 'BRB');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (56, 'БЕЛЬГИЯ', 'BE', 'BEL');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (60, 'БЕРМУДЫ', 'BM', 'BMU');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (64, 'БУТАН', 'BT', 'BTN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (68, 'БОЛИВИЯ, МНОГОНАЦИОНАЛЬНОЕ ГОСУДАРСТВО', 'BO', 'BOL');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (70, 'БОСНИЯ И ГЕРЦЕГОВИНА', 'BA', 'BIH');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (72, 'БОТСВАНА', 'BW', 'BWA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (74, 'ОСТРОВ БУВЕ', 'BV', 'BVT');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (76, 'БРАЗИЛИЯ', 'BR', 'BRA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (84, 'БЕЛИЗ', 'BZ', 'BLZ');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (86, 'БРИТАНСКАЯ ТЕРРИТОРИЯ В ИНДИЙСКОМ ОКЕАНЕ', 'IO', 'IOT');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (90, 'СОЛОМОНОВЫ ОСТРОВА', 'SB', 'SLB');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (92, 'ВИРГИНСКИЕ ОСТРОВА, БРИТАНСКИЕ', 'VG', 'VGB');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (96, 'БРУНЕЙ-ДАРУССАЛАМ', 'BN', 'BRN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (100, 'БОЛГАРИЯ', 'BG', 'BGR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (104, 'МЬЯНМА', 'MM', 'MMR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (108, 'БУРУНДИ', 'BI', 'BDI');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (112, 'БЕЛАРУСЬ', 'BY', 'BLR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (116, 'КАМБОДЖА', 'KH', 'KHM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (120, 'КАМЕРУН', 'CM', 'CMR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (124, 'КАНАДА', 'CA', 'CAN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (132, 'КАБО-ВЕРДЕ', 'CV', 'CPV');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (136, 'ОСТРОВА КАЙМАН', 'KY', 'CYM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (140, 'ЦЕНТРАЛЬНО-АФРИКАНСКАЯ РЕСПУБЛИКА', 'CF', 'CAF');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (144, 'ШРИ-ЛАНКА', 'LK', 'LKA');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (148, 'ЧАД', 'TD', 'TCD');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (152, 'ЧИЛИ', 'CL', 'CHL');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (156, 'КИТАЙ', 'CN', 'CHN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (158, 'ТАЙВАНЬ (КИТАЙ)', 'TW', 'TWN');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (162, 'ОСТРОВ РОЖДЕСТВА', 'CX', 'CXR');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (166, 'КОКОСОВЫЕ (КИЛИНГ) ОСТРОВА', 'CC', 'CCK');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (170, 'КОЛУМБИЯ', 'CO', 'COL');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (174, 'КОМОРЫ', 'KM', 'COM');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (175, 'МАЙОТТА', 'YT', 'MYT');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (178, 'КОНГО', 'CG', 'COG');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (180, 'КОНГО, ДЕМОКРАТИЧЕСКАЯ РЕСПУБЛИКА', 'CD', 'COD');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (184, 'ОСТРОВА КУКА', 'CK', 'COK');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (188, 'КОСТА-РИКА', 'CR', 'CRI');
insert into COUNTRY (id, name, iso_alpha_2, iso_alpha_3)
values (728, 'ЮЖНЫЙ СУДАН', 'SS', 'SSD');
commit;
prompt 252 records loaded
prompt Loading CURRENCY...
insert into CURRENCY (currency_id, alfa3, description)
values (643, 'RUB', 'Russian Ruble');
insert into CURRENCY (currency_id, alfa3, description)
values (840, 'USD', 'US Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (978, 'EUR', 'Euro');
insert into CURRENCY (currency_id, alfa3, description)
values (971, 'AFN', 'Afghani');
insert into CURRENCY (currency_id, alfa3, description)
values (8, 'ALL', 'Lek');
insert into CURRENCY (currency_id, alfa3, description)
values (12, 'DZD', 'Algerian Dinar');
insert into CURRENCY (currency_id, alfa3, description)
values (973, 'AOA', 'Kwanza');
insert into CURRENCY (currency_id, alfa3, description)
values (951, 'XCD', 'East Caribbean Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (32, 'ARS', 'Argentine Peso');
insert into CURRENCY (currency_id, alfa3, description)
values (51, 'AMD', 'Armenian Dram');
insert into CURRENCY (currency_id, alfa3, description)
values (533, 'AWG', 'Aruban Florin');
insert into CURRENCY (currency_id, alfa3, description)
values (36, 'AUD', 'Australian Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (944, 'AZN', 'Azerbaijan Manat');
insert into CURRENCY (currency_id, alfa3, description)
values (44, 'BSD', 'Bahamian Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (48, 'BHD', 'Bahraini Dinar');
insert into CURRENCY (currency_id, alfa3, description)
values (50, 'BDT', 'Taka');
insert into CURRENCY (currency_id, alfa3, description)
values (52, 'BBD', 'Barbados Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (933, 'BYN', 'Belarusian Ruble');
insert into CURRENCY (currency_id, alfa3, description)
values (84, 'BZD', 'Belize Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (952, 'XOF', 'CFA Franc BCEAO');
insert into CURRENCY (currency_id, alfa3, description)
values (60, 'BMD', 'Bermudian Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (356, 'INR', 'Indian Rupee');
insert into CURRENCY (currency_id, alfa3, description)
values (64, 'BTN', 'Ngultrum');
insert into CURRENCY (currency_id, alfa3, description)
values (68, 'BOB', 'Boliviano');
insert into CURRENCY (currency_id, alfa3, description)
values (984, 'BOV', 'Mvdol');
insert into CURRENCY (currency_id, alfa3, description)
values (977, 'BAM', 'Convertible Mark');
insert into CURRENCY (currency_id, alfa3, description)
values (72, 'BWP', 'Pula');
insert into CURRENCY (currency_id, alfa3, description)
values (578, 'NOK', 'Norwegian Krone');
insert into CURRENCY (currency_id, alfa3, description)
values (986, 'BRL', 'Brazilian Real');
insert into CURRENCY (currency_id, alfa3, description)
values (96, 'BND', 'Brunei Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (975, 'BGN', 'Bulgarian Lev');
insert into CURRENCY (currency_id, alfa3, description)
values (108, 'BIF', 'Burundi Franc');
insert into CURRENCY (currency_id, alfa3, description)
values (132, 'CVE', 'Cabo Verde Escudo');
insert into CURRENCY (currency_id, alfa3, description)
values (116, 'KHR', 'Riel');
insert into CURRENCY (currency_id, alfa3, description)
values (950, 'XAF', 'CFA Franc BEAC');
insert into CURRENCY (currency_id, alfa3, description)
values (124, 'CAD', 'Canadian Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (136, 'KYD', 'Cayman Islands Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (152, 'CLP', 'Chilean Peso');
insert into CURRENCY (currency_id, alfa3, description)
values (990, 'CLF', 'Unidad de Fomento');
insert into CURRENCY (currency_id, alfa3, description)
values (156, 'CNY', 'Yuan Renminbi');
insert into CURRENCY (currency_id, alfa3, description)
values (170, 'COP', 'Colombian Peso');
insert into CURRENCY (currency_id, alfa3, description)
values (970, 'COU', 'Unidad de Valor Real');
insert into CURRENCY (currency_id, alfa3, description)
values (174, 'KMF', 'Comorian Franc');
insert into CURRENCY (currency_id, alfa3, description)
values (976, 'CDF', 'Congolese Franc');
insert into CURRENCY (currency_id, alfa3, description)
values (554, 'NZD', 'New Zealand Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (188, 'CRC', 'Costa Rican Colon');
insert into CURRENCY (currency_id, alfa3, description)
values (191, 'HRK', 'Kuna');
insert into CURRENCY (currency_id, alfa3, description)
values (192, 'CUP', 'Cuban Peso');
insert into CURRENCY (currency_id, alfa3, description)
values (931, 'CUC', 'Peso Convertible');
insert into CURRENCY (currency_id, alfa3, description)
values (532, 'ANG', 'Netherlands Antillean Guilder');
insert into CURRENCY (currency_id, alfa3, description)
values (203, 'CZK', 'Czech Koruna');
insert into CURRENCY (currency_id, alfa3, description)
values (208, 'DKK', 'Danish Krone');
insert into CURRENCY (currency_id, alfa3, description)
values (262, 'DJF', 'Djibouti Franc');
insert into CURRENCY (currency_id, alfa3, description)
values (214, 'DOP', 'Dominican Peso');
insert into CURRENCY (currency_id, alfa3, description)
values (818, 'EGP', 'Egyptian Pound');
insert into CURRENCY (currency_id, alfa3, description)
values (222, 'SVC', 'El Salvador Colon');
insert into CURRENCY (currency_id, alfa3, description)
values (232, 'ERN', 'Nakfa');
insert into CURRENCY (currency_id, alfa3, description)
values (230, 'ETB', 'Ethiopian Birr');
insert into CURRENCY (currency_id, alfa3, description)
values (238, 'FKP', 'Falkland Islands Pound');
insert into CURRENCY (currency_id, alfa3, description)
values (242, 'FJD', 'Fiji Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (953, 'XPF', 'CFP Franc');
insert into CURRENCY (currency_id, alfa3, description)
values (270, 'GMD', 'Dalasi');
insert into CURRENCY (currency_id, alfa3, description)
values (981, 'GEL', 'Lari');
insert into CURRENCY (currency_id, alfa3, description)
values (936, 'GHS', 'Ghana Cedi');
insert into CURRENCY (currency_id, alfa3, description)
values (292, 'GIP', 'Gibraltar Pound');
insert into CURRENCY (currency_id, alfa3, description)
values (320, 'GTQ', 'Quetzal');
insert into CURRENCY (currency_id, alfa3, description)
values (826, 'GBP', 'Pound Sterling');
insert into CURRENCY (currency_id, alfa3, description)
values (324, 'GNF', 'Guinean Franc');
insert into CURRENCY (currency_id, alfa3, description)
values (328, 'GYD', 'Guyana Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (332, 'HTG', 'Gourde');
insert into CURRENCY (currency_id, alfa3, description)
values (340, 'HNL', 'Lempira');
insert into CURRENCY (currency_id, alfa3, description)
values (344, 'HKD', 'Hong Kong Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (348, 'HUF', 'Forint');
insert into CURRENCY (currency_id, alfa3, description)
values (352, 'ISK', 'Iceland Krona');
insert into CURRENCY (currency_id, alfa3, description)
values (360, 'IDR', 'Rupiah');
insert into CURRENCY (currency_id, alfa3, description)
values (960, 'XDR', 'SDR (Special Drawing Right)');
insert into CURRENCY (currency_id, alfa3, description)
values (364, 'IRR', 'Iranian Rial');
insert into CURRENCY (currency_id, alfa3, description)
values (368, 'IQD', 'Iraqi Dinar');
insert into CURRENCY (currency_id, alfa3, description)
values (376, 'ILS', 'New Israeli Sheqel');
insert into CURRENCY (currency_id, alfa3, description)
values (388, 'JMD', 'Jamaican Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (392, 'JPY', 'Yen');
insert into CURRENCY (currency_id, alfa3, description)
values (400, 'JOD', 'Jordanian Dinar');
insert into CURRENCY (currency_id, alfa3, description)
values (398, 'KZT', 'Tenge');
insert into CURRENCY (currency_id, alfa3, description)
values (404, 'KES', 'Kenyan Shilling');
insert into CURRENCY (currency_id, alfa3, description)
values (408, 'KPW', 'North Korean Won');
insert into CURRENCY (currency_id, alfa3, description)
values (410, 'KRW', 'Won');
insert into CURRENCY (currency_id, alfa3, description)
values (414, 'KWD', 'Kuwaiti Dinar');
insert into CURRENCY (currency_id, alfa3, description)
values (417, 'KGS', 'Som');
insert into CURRENCY (currency_id, alfa3, description)
values (418, 'LAK', 'Lao Kip');
insert into CURRENCY (currency_id, alfa3, description)
values (422, 'LBP', 'Lebanese Pound');
insert into CURRENCY (currency_id, alfa3, description)
values (426, 'LSL', 'Loti');
insert into CURRENCY (currency_id, alfa3, description)
values (710, 'ZAR', 'Rand');
insert into CURRENCY (currency_id, alfa3, description)
values (430, 'LRD', 'Liberian Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (434, 'LYD', 'Libyan Dinar');
insert into CURRENCY (currency_id, alfa3, description)
values (756, 'CHF', 'Swiss Franc');
insert into CURRENCY (currency_id, alfa3, description)
values (446, 'MOP', 'Pataca');
insert into CURRENCY (currency_id, alfa3, description)
values (807, 'MKD', 'Denar');
insert into CURRENCY (currency_id, alfa3, description)
values (969, 'MGA', 'Malagasy Ariary');
insert into CURRENCY (currency_id, alfa3, description)
values (454, 'MWK', 'Malawi Kwacha');
insert into CURRENCY (currency_id, alfa3, description)
values (458, 'MYR', 'Malaysian Ringgit');
insert into CURRENCY (currency_id, alfa3, description)
values (462, 'MVR', 'Rufiyaa');
insert into CURRENCY (currency_id, alfa3, description)
values (929, 'MRU', 'Ouguiya');
insert into CURRENCY (currency_id, alfa3, description)
values (480, 'MUR', 'Mauritius Rupee');
insert into CURRENCY (currency_id, alfa3, description)
values (965, 'XUA', 'ADB Unit of Account');
insert into CURRENCY (currency_id, alfa3, description)
values (484, 'MXN', 'Mexican Peso');
insert into CURRENCY (currency_id, alfa3, description)
values (979, 'MXV', 'Mexican Unidad de Inversion (UDI)');
insert into CURRENCY (currency_id, alfa3, description)
values (498, 'MDL', 'Moldovan Leu');
insert into CURRENCY (currency_id, alfa3, description)
values (496, 'MNT', 'Tugrik');
insert into CURRENCY (currency_id, alfa3, description)
values (504, 'MAD', 'Moroccan Dirham');
insert into CURRENCY (currency_id, alfa3, description)
values (943, 'MZN', 'Mozambique Metical');
insert into CURRENCY (currency_id, alfa3, description)
values (104, 'MMK', 'Kyat');
insert into CURRENCY (currency_id, alfa3, description)
values (516, 'NAD', 'Namibia Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (524, 'NPR', 'Nepalese Rupee');
insert into CURRENCY (currency_id, alfa3, description)
values (558, 'NIO', 'Cordoba Oro');
insert into CURRENCY (currency_id, alfa3, description)
values (566, 'NGN', 'Naira');
insert into CURRENCY (currency_id, alfa3, description)
values (512, 'OMR', 'Rial Omani');
insert into CURRENCY (currency_id, alfa3, description)
values (586, 'PKR', 'Pakistan Rupee');
insert into CURRENCY (currency_id, alfa3, description)
values (590, 'PAB', 'Balboa');
insert into CURRENCY (currency_id, alfa3, description)
values (598, 'PGK', 'Kina');
insert into CURRENCY (currency_id, alfa3, description)
values (600, 'PYG', 'Guarani');
insert into CURRENCY (currency_id, alfa3, description)
values (604, 'PEN', 'Sol');
insert into CURRENCY (currency_id, alfa3, description)
values (608, 'PHP', 'Philippine Peso');
insert into CURRENCY (currency_id, alfa3, description)
values (985, 'PLN', 'Zloty');
insert into CURRENCY (currency_id, alfa3, description)
values (634, 'QAR', 'Qatari Rial');
insert into CURRENCY (currency_id, alfa3, description)
values (946, 'RON', 'Romanian Leu');
insert into CURRENCY (currency_id, alfa3, description)
values (646, 'RWF', 'Rwanda Franc');
insert into CURRENCY (currency_id, alfa3, description)
values (654, 'SHP', 'Saint Helena Pound');
insert into CURRENCY (currency_id, alfa3, description)
values (882, 'WST', 'Tala');
insert into CURRENCY (currency_id, alfa3, description)
values (930, 'STN', 'Dobra');
insert into CURRENCY (currency_id, alfa3, description)
values (682, 'SAR', 'Saudi Riyal');
insert into CURRENCY (currency_id, alfa3, description)
values (941, 'RSD', 'Serbian Dinar');
insert into CURRENCY (currency_id, alfa3, description)
values (690, 'SCR', 'Seychelles Rupee');
insert into CURRENCY (currency_id, alfa3, description)
values (694, 'SLL', 'Leone');
insert into CURRENCY (currency_id, alfa3, description)
values (702, 'SGD', 'Singapore Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (994, 'XSU', 'Sucre');
insert into CURRENCY (currency_id, alfa3, description)
values (90, 'SBD', 'Solomon Islands Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (706, 'SOS', 'Somali Shilling');
insert into CURRENCY (currency_id, alfa3, description)
values (728, 'SSP', 'South Sudanese Pound');
insert into CURRENCY (currency_id, alfa3, description)
values (144, 'LKR', 'Sri Lanka Rupee');
insert into CURRENCY (currency_id, alfa3, description)
values (938, 'SDG', 'Sudanese Pound');
insert into CURRENCY (currency_id, alfa3, description)
values (968, 'SRD', 'Surinam Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (748, 'SZL', 'Lilangeni');
insert into CURRENCY (currency_id, alfa3, description)
values (752, 'SEK', 'Swedish Krona');
insert into CURRENCY (currency_id, alfa3, description)
values (947, 'CHE', 'WIR Euro');
insert into CURRENCY (currency_id, alfa3, description)
values (948, 'CHW', 'WIR Franc');
insert into CURRENCY (currency_id, alfa3, description)
values (760, 'SYP', 'Syrian Pound');
insert into CURRENCY (currency_id, alfa3, description)
values (901, 'TWD', 'New Taiwan Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (972, 'TJS', 'Somoni');
insert into CURRENCY (currency_id, alfa3, description)
values (834, 'TZS', 'Tanzanian Shilling');
insert into CURRENCY (currency_id, alfa3, description)
values (764, 'THB', 'Baht');
insert into CURRENCY (currency_id, alfa3, description)
values (776, 'TOP', 'Pa’anga');
insert into CURRENCY (currency_id, alfa3, description)
values (780, 'TTD', 'Trinidad and Tobago Dollar');
insert into CURRENCY (currency_id, alfa3, description)
values (788, 'TND', 'Tunisian Dinar');
insert into CURRENCY (currency_id, alfa3, description)
values (949, 'TRY', 'Turkish Lira');
insert into CURRENCY (currency_id, alfa3, description)
values (934, 'TMT', 'Turkmenistan New Manat');
insert into CURRENCY (currency_id, alfa3, description)
values (800, 'UGX', 'Uganda Shilling');
insert into CURRENCY (currency_id, alfa3, description)
values (980, 'UAH', 'Hryvnia');
insert into CURRENCY (currency_id, alfa3, description)
values (784, 'AED', 'UAE Dirham');
insert into CURRENCY (currency_id, alfa3, description)
values (997, 'USN', 'US Dollar (Next day)');
insert into CURRENCY (currency_id, alfa3, description)
values (858, 'UYU', 'Peso Uruguayo');
insert into CURRENCY (currency_id, alfa3, description)
values (940, 'UYI', 'Uruguay Peso en Unidades Indexadas (UI)');
insert into CURRENCY (currency_id, alfa3, description)
values (927, 'UYW', 'Unidad Previsional');
insert into CURRENCY (currency_id, alfa3, description)
values (860, 'UZS', 'Uzbekistan Sum');
insert into CURRENCY (currency_id, alfa3, description)
values (548, 'VUV', 'Vatu');
insert into CURRENCY (currency_id, alfa3, description)
values (928, 'VES', 'Bolívar Soberano');
insert into CURRENCY (currency_id, alfa3, description)
values (704, 'VND', 'Dong');
insert into CURRENCY (currency_id, alfa3, description)
values (886, 'YER', 'Yemeni Rial');
insert into CURRENCY (currency_id, alfa3, description)
values (967, 'ZMW', 'Zambian Kwacha');
insert into CURRENCY (currency_id, alfa3, description)
values (932, 'ZWL', 'Zimbabwe Dollar');
commit;
prompt 169 records loaded
prompt Loading COUNTRY_CURRENCY...
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (8, 8);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (12, 12);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (32, 32);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (36, 36);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (40, 40);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (44, 44);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (48, 48);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (50, 50);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (51, 51);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (52, 52);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (56, 56);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (60, 60);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (64, 64);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (68, 68);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (70, 70);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (72, 72);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (74, 74);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (76, 76);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (84, 84);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (86, 86);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (90, 90);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (92, 92);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (96, 96);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (100, 100);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (104, 104);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (108, 108);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (112, 112);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (116, 116);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (120, 120);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (124, 124);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (132, 132);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (136, 136);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (140, 140);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (144, 144);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (148, 148);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (152, 152);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (156, 156);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (158, 158);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (162, 162);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (166, 166);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (170, 170);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (174, 174);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (175, 175);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (178, 178);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (180, 180);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (184, 184);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (188, 188);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (191, 191);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (192, 192);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (196, 196);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (203, 203);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (204, 204);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (208, 208);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (212, 212);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (214, 214);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (218, 218);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (222, 222);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (226, 226);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (231, 231);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (232, 232);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (233, 233);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (234, 234);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (238, 238);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (239, 239);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (242, 242);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (246, 246);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (248, 248);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (250, 250);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (254, 254);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (258, 258);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (260, 260);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (262, 262);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (266, 266);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (268, 268);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (270, 270);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (275, 275);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (276, 276);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (288, 288);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (292, 292);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (296, 296);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (300, 300);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (304, 304);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (308, 308);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (312, 312);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (316, 316);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (320, 320);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (324, 324);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (328, 328);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (332, 332);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (334, 334);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (336, 336);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (340, 340);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (344, 344);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (348, 348);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (352, 352);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (356, 356);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (360, 360);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (364, 364);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (368, 368);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (372, 372);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (376, 376);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (380, 380);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (384, 384);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (388, 388);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (392, 392);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (398, 398);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (400, 400);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (404, 404);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (408, 408);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (410, 410);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (414, 414);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (417, 417);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (418, 418);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (422, 422);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (426, 426);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (428, 428);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (430, 430);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (434, 434);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (438, 438);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (440, 440);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (442, 442);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (446, 446);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (450, 450);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (454, 454);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (458, 458);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (462, 462);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (466, 466);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (470, 470);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (474, 474);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (478, 478);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (480, 480);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (484, 484);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (492, 492);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (496, 496);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (498, 498);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (499, 499);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (500, 500);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (504, 504);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (508, 508);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (512, 512);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (516, 516);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (520, 520);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (524, 524);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (528, 528);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (531, 531);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (533, 533);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (534, 534);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (535, 535);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (540, 540);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (548, 548);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (554, 554);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (558, 558);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (562, 562);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (566, 566);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (570, 570);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (574, 574);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (578, 578);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (580, 580);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (581, 581);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (583, 583);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (584, 584);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (585, 585);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (586, 586);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (591, 591);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (598, 598);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (600, 600);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (604, 604);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (608, 608);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (612, 612);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (616, 616);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (620, 620);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (624, 624);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (626, 626);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (630, 630);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (634, 634);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (638, 638);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (642, 642);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (643, 643);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (646, 646);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (652, 652);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (654, 654);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (659, 659);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (660, 660);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (662, 662);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (663, 663);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (666, 666);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (670, 670);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (674, 674);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (678, 678);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (682, 682);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (686, 686);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (688, 688);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (690, 690);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (694, 694);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (702, 702);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (703, 703);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (704, 704);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (705, 705);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (706, 706);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (710, 710);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (716, 716);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (724, 724);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (728, 728);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (732, 732);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (736, 736);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (740, 740);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (744, 744);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (748, 748);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (752, 752);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (756, 756);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (760, 760);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (762, 762);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (764, 764);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (768, 768);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (772, 772);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (776, 776);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (780, 780);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (784, 784);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (788, 788);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (792, 792);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (795, 795);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (796, 796);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (798, 798);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (800, 800);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (804, 804);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (807, 807);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (818, 818);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (826, 826);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (831, 831);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (832, 832);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (833, 833);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (834, 834);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (840, 840);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (850, 850);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (854, 854);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (858, 858);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (860, 860);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (862, 862);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (876, 876);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (882, 882);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (887, 887);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (894, 894);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (895, 895);
insert into COUNTRY_CURRENCY (country_id, currency_id)
values (896, 896);
commit;
prompt 244 records loaded
prompt Loading COUNTRY_PHONE...
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (643, '+7');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (398, '+77');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (980, '+380');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (498, '+373');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (51, '+374');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (840, '+1');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (978, '+372');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (944, '+994');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (410, '+82');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (946, '+40');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (643, '+8790');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (840, '+507');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (428, '+371');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (440, '+370');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (417, '+996');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (981, '+9955');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (972, '+992');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (826, '+44');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (860, '+998');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (376, '+972');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (978, '+30');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (901, '+66');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (949, '+90');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (392, '+81');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (704, '+84');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (986, '+55');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (356, '+91');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (643, '+8791');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (974, '+375');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (400, '+962');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (32, '+54');
insert into COUNTRY_PHONE (country_id, phone_prefix)
values (978, '+49');
commit;
prompt 32 records loaded
prompt Loading PAYMENT_DETAIL_FIELD...
insert into PAYMENT_DETAIL_FIELD (field_id, name, description)
values (1, 'CLIENT_SOFTWARE', 'Софт, через который совершался платеж');
insert into PAYMENT_DETAIL_FIELD (field_id, name, description)
values (2, 'IP', 'IP адрес плательщика');
insert into PAYMENT_DETAIL_FIELD (field_id, name, description)
values (3, 'NOTE', 'Примечание к переводу');
insert into PAYMENT_DETAIL_FIELD (field_id, name, description)
values (4, 'IS_CHECKED_FRAUD', 'Проверен ли платеж в системе "АнтиФрод"');
commit;
prompt 4 records loaded
prompt Enabling triggers for CLIENT_DATA_FIELD...
alter table CLIENT_DATA_FIELD enable all triggers;
prompt Enabling triggers for COUNTRY...
alter table COUNTRY enable all triggers;
prompt Enabling triggers for CURRENCY...
alter table CURRENCY enable all triggers;
prompt Enabling triggers for COUNTRY_CURRENCY...
alter table COUNTRY_CURRENCY enable all triggers;
prompt Enabling triggers for COUNTRY_PHONE...
alter table COUNTRY_PHONE enable all triggers;
prompt Enabling triggers for PAYMENT_DETAIL_FIELD...
alter table PAYMENT_DETAIL_FIELD enable all triggers;

set feedback on
set define on
prompt Done
