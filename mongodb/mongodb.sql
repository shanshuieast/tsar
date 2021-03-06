-- mongodb_1 info
CREATE TABLE IF NOT EXISTS `mongodb_1` (
    `host_name` VARCHAR(64) NOT NULL DEFAULT '',
    `time` INT(11) NOT NULL DEFAULT '0',
    `insert` DECIMAL(8 , 2 ) DEFAULT '0',
    `query` DECIMAL(8 , 2 ) DEFAULT '0',
    `update` DECIMAL(8 , 2 ) DEFAULT '0',
    `delete` DECIMAL(8 , 2 ) DEFAULT '0',
    `getmore` DECIMAL(8 , 2 ) DEFAULT '0',
    `command` DECIMAL(8 , 2 ) DEFAULT '0',
    `bgflush` DECIMAL(8 , 2 ) DEFAULT '0',
    `mapped` DECIMAL(8 , 2 ) DEFAULT '0',
    `virtual` DECIMAL(8 , 2 ) DEFAULT '0',
    `resident` DECIMAL(8 , 2 ) DEFAULT '0',
    `pf` DECIMAL(8 , 2 ) DEFAULT '0',
    `lockrio` DECIMAL(8 , 2 ) DEFAULT '0',
    `btreerio` DECIMAL(8 , 2 ) DEFAULT '0',
    `wait4lock` DECIMAL(8 , 2 ) DEFAULT '0',
    `r4lock` DECIMAL(8 , 2 ) DEFAULT '0',
    `w4lock` DECIMAL(8 , 2 ) DEFAULT '0',
    `ac` DECIMAL(8 , 2 ) DEFAULT '0',
    `ar` DECIMAL(8 , 2 ) DEFAULT '0',
    `aw` DECIMAL(8 , 2 ) DEFAULT '0',
    `oc` DECIMAL(8 , 2 ) DEFAULT '0',
    `ocrio` DECIMAL(8 , 2 ) DEFAULT '0',
    `sd` DECIMAL(8 , 2 ) DEFAULT '0',
    `assert` DECIMAL(8 , 2 ) DEFAULT '0',
    `view_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`view_time` , `host_name`)
)  ENGINE=MYISAM DEFAULT CHARSET=LATIN1 COMMENT='mongodb mod info';

-- mongodb_2 info
CREATE TABLE IF NOT EXISTS `mongodb_2` (
    `host_name` VARCHAR(64) NOT NULL DEFAULT '',
    `time` INT(11) NOT NULL DEFAULT '0',
    `insert` DECIMAL(8 , 2 ) DEFAULT '0',
    `query` DECIMAL(8 , 2 ) DEFAULT '0',
    `update` DECIMAL(8 , 2 ) DEFAULT '0',
    `delete` DECIMAL(8 , 2 ) DEFAULT '0',
    `getmore` DECIMAL(8 , 2 ) DEFAULT '0',
    `command` DECIMAL(8 , 2 ) DEFAULT '0',
    `bgflush` DECIMAL(8 , 2 ) DEFAULT '0',
    `mapped` DECIMAL(8 , 2 ) DEFAULT '0',
    `virtual` DECIMAL(8 , 2 ) DEFAULT '0',
    `resident` DECIMAL(8 , 2 ) DEFAULT '0',
    `pf` DECIMAL(8 , 2 ) DEFAULT '0',
    `lockrio` DECIMAL(8 , 2 ) DEFAULT '0',
    `btreerio` DECIMAL(8 , 2 ) DEFAULT '0',
    `wait4lock` DECIMAL(8 , 2 ) DEFAULT '0',
    `r4lock` DECIMAL(8 , 2 ) DEFAULT '0',
    `w4lock` DECIMAL(8 , 2 ) DEFAULT '0',
    `ac` DECIMAL(8 , 2 ) DEFAULT '0',
    `ar` DECIMAL(8 , 2 ) DEFAULT '0',
    `aw` DECIMAL(8 , 2 ) DEFAULT '0',
    `oc` DECIMAL(8 , 2 ) DEFAULT '0',
    `ocrio` DECIMAL(8 , 2 ) DEFAULT '0',
    `sd` DECIMAL(8 , 2 ) DEFAULT '0',
    `assert` DECIMAL(8 , 2 ) DEFAULT '0',
    `view_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`view_time` , `host_name`)
)  ENGINE=MYISAM DEFAULT CHARSET=LATIN1 COMMENT='mongodb mod info';

-- mongodb info
CREATE TABLE IF NOT EXISTS `mongodb` (
    `host_name` VARCHAR(64) NOT NULL DEFAULT '',
    `time` INT(11) NOT NULL DEFAULT '0',
    `insert` DECIMAL(8 , 2 ) DEFAULT '0',
    `query` DECIMAL(8 , 2 ) DEFAULT '0',
    `update` DECIMAL(8 , 2 ) DEFAULT '0',
    `delete` DECIMAL(8 , 2 ) DEFAULT '0',
    `getmore` DECIMAL(8 , 2 ) DEFAULT '0',
    `command` DECIMAL(8 , 2 ) DEFAULT '0',
    `bgflush` DECIMAL(8 , 2 ) DEFAULT '0',
    `mapped` DECIMAL(8 , 2 ) DEFAULT '0',
    `virtual` DECIMAL(8 , 2 ) DEFAULT '0',
    `resident` DECIMAL(8 , 2 ) DEFAULT '0',
    `pf` DECIMAL(8 , 2 ) DEFAULT '0',
    `lockrio` DECIMAL(8 , 2 ) DEFAULT '0',
    `btreerio` DECIMAL(8 , 2 ) DEFAULT '0',
    `wait4lock` DECIMAL(8 , 2 ) DEFAULT '0',
    `r4lock` DECIMAL(8 , 2 ) DEFAULT '0',
    `w4lock` DECIMAL(8 , 2 ) DEFAULT '0',
    `ac` DECIMAL(8 , 2 ) DEFAULT '0',
    `ar` DECIMAL(8 , 2 ) DEFAULT '0',
    `aw` DECIMAL(8 , 2 ) DEFAULT '0',
    `oc` DECIMAL(8 , 2 ) DEFAULT '0',
    `ocrio` DECIMAL(8 , 2 ) DEFAULT '0',
    `sd` DECIMAL(8 , 2 ) DEFAULT '0',
    `assert` DECIMAL(8 , 2 ) DEFAULT '0',
    `view_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`view_time` , `host_name`)
)  ENGINE=MRG_MYISAM DEFAULT CHARSET=LATIN1 INSERT_METHOD=LAST UNION=( `mongodb_1` , `mongodb_2` );
