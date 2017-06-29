-- onesql_1 info
CREATE TABLE IF NOT EXISTS `onesql_1` (
    `host_name` VARCHAR(64) NOT NULL DEFAULT '',
    `time` INT(11) NOT NULL DEFAULT '0',
    `qps` DECIMAL(8 , 2 ) DEFAULT '0',
    `tps` DECIMAL(8 , 2 ) DEFAULT '0',
    `rdrio` DECIMAL(8 , 2 ) DEFAULT '0',
    `bfrd` DECIMAL(8 , 2 ) DEFAULT '0',
    `ird` DECIMAL(8 , 2 ) DEFAULT '0',
    `iwr` DECIMAL(8 , 2 ) DEFAULT '0',
    `qc` DECIMAL(8 , 2 ) DEFAULT '0',
    `tc` DECIMAL(8 , 2 ) DEFAULT '0',
    `rlwa` DECIMAL(8 , 2 ) DEFAULT '0',
    `view_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`view_time` , `host_name`)
)  ENGINE=MYISAM DEFAULT CHARSET=LATIN1 COMMENT='onesql mod info';

-- onesql_2 info
CREATE TABLE IF NOT EXISTS `onesql_2` (
    `host_name` VARCHAR(64) NOT NULL DEFAULT '',
    `time` INT(11) NOT NULL DEFAULT '0',
    `qps` DECIMAL(8 , 2 ) DEFAULT '0',
    `tps` DECIMAL(8 , 2 ) DEFAULT '0',
    `rdrio` DECIMAL(8 , 2 ) DEFAULT '0',
    `bfrd` DECIMAL(8 , 2 ) DEFAULT '0',
    `ird` DECIMAL(8 , 2 ) DEFAULT '0',
    `iwr` DECIMAL(8 , 2 ) DEFAULT '0',
    `qc` DECIMAL(8 , 2 ) DEFAULT '0',
    `tc` DECIMAL(8 , 2 ) DEFAULT '0',
    `rlwa` DECIMAL(8 , 2 ) DEFAULT '0',
    `view_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`view_time` , `host_name`)
)  ENGINE=MYISAM DEFAULT CHARSET=LATIN1 COMMENT='onesql mod info';

-- onesql info
CREATE TABLE IF NOT EXISTS `onesql` (
    `host_name` VARCHAR(64) NOT NULL DEFAULT '',
    `time` INT(11) NOT NULL DEFAULT '0',
    `qps` DECIMAL(8 , 2 ) DEFAULT '0',
    `tps` DECIMAL(8 , 2 ) DEFAULT '0',
    `rdrio` DECIMAL(8 , 2 ) DEFAULT '0',
    `bfrd` DECIMAL(8 , 2 ) DEFAULT '0',
    `ird` DECIMAL(8 , 2 ) DEFAULT '0',
    `iwr` DECIMAL(8 , 2 ) DEFAULT '0',
    `qc` DECIMAL(8 , 2 ) DEFAULT '0',
    `tc` DECIMAL(8 , 2 ) DEFAULT '0',
    `rlwa` DECIMAL(8 , 2 ) DEFAULT '0',
    `view_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`view_time` , `host_name`)
)  ENGINE=MRG_MYISAM DEFAULT CHARSET=LATIN1 INSERT_METHOD=LAST UNION=( `onesql_1` , `onesql_2` );
