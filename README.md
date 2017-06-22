Tsar自定义模块开发
------------

基于[Taobao System Activity Reporter](https://github.com/alibaba/tsar)，在其上进行扩展模块的开发，以满足项目所需。

生成自定义模块开发目录
------------

在tsar源代码目录下，运行命令`tsardevel <yourmodname>`

    $ tsardevel mytest
    build: make
    install: make install
    uninstall: make uninstall
	test:tsar --list or tsar --mytest --live -i 1
    
    $ ls mytest
    Makefile mod_mytest.c mod_mytest.conf


模块介绍信息
------------

    static const char *mytest_usage = "    --mytest               mytest information";

模块信息采集数据结构
------------

    /*
     * temp structure for collection infomation.
     */
    struct stats_mytest {
        unsigned long long    value_1;
        unsigned long long    value_2;
        unsigned long long    value_3;
    };

采集数据只支持整形类型。

框架处理模块的方式
------------

    /* Structure for tsar */
    static struct mod_info mytest_info[] = {
        {"value1", SUMMARY_BIT,  0,  STATS_NULL},
        {"value2", DETAIL_BIT,  0,  STATS_NULL},
        {"value3", DETAIL_BIT,  0,  STATS_NULL}
    };

1. 第一列：信息名称，与`数据库字段`对应，最大6个字符，前面空格填充；
2. 第二列：显示方式
    - SUMMARY_BIT：概要输出时显示该列
    - DETAIL_BIT：具体制定模块时显示该列
    - HIDE_BIT：暂不显示
3. 第三列：数据合并方式
    - MERGE_NULL：没有多item，不需要汇总
    - MERGE_SUM：将多个item数据做加和处理
    - MERGE_AVG：将多个item数据做平均处理
4. 第四列：数据展示时的计算关系
    - STATS_NULL：只显示本周期数据
    - STATS_SUB：将本周期数据和上周期数据做差的结果输出
    - STATS_SUB_INTER：将前后两周期的数据差并除时间间隔作为输出

采集函数 read_mytest_stats
------------

申请一个刚才声明的struct，通过读文件，或者其它采集方式，取得数值，存到struct结构中。

保存函数 set_mytest_record
------------

将数据传到Tsar的框架中，如果这个模块每次只有一条记录，则只需要将数据间用逗号隔开即可，如果一次采集可能有多个记录（称为多item情况），则需要将item之间用分号隔开。

模块注册 mod_register
------------

    register_mod_fields(mod, "--mytest", mytest_usage, mytest_info, 3, read_mytest_stats, set_mytest_record);

- 参数1：模块实例句柄
- 参数2：模块快捷方式
- 参数3：模块介绍
- 参数4：模块注册信息
- 参数5：列数目
- 参数6：采集函数
- 参数7：结果计算函数。


默认模板配置文件 mod_mytest.conf
------------

- **`mod_mytest on`**：打开模块功能
- **`output_db_mod mod_mytest`**：保存采集信息至数据库

数据库预制脚本
------------

同时创建mytest_1、mytest_2和mytest三个相同结构的数据库表，示例如下：

	-- mytest_1 info
	CREATE TABLE IF NOT EXISTS `mytest_1` (
		`host_name` VARCHAR(64) NOT NULL DEFAULT '',
		`time` INT(11) NOT NULL DEFAULT '0',
		`value1` DECIMAL(8 , 2 ) DEFAULT NULL,
		`value2` DECIMAL(8 , 2 ) DEFAULT NULL,
		`value3` DECIMAL(8 , 2 ) DEFAULT NULL,
		`view_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		PRIMARY KEY (`view_time` , `host_name`)
	)  ENGINE=MYISAM DEFAULT CHARSET=LATIN1 COMMENT='mytest mod info';

	-- mytest_2 info
	CREATE TABLE IF NOT EXISTS `mytest_2` (
		`host_name` VARCHAR(64) NOT NULL DEFAULT '',
		`time` INT(11) NOT NULL DEFAULT '0',
		`value1` DECIMAL(8 , 2 ) DEFAULT NULL,
		`value2` DECIMAL(8 , 2 ) DEFAULT NULL,
		`value3` DECIMAL(8 , 2 ) DEFAULT NULL,
		`view_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		PRIMARY KEY (`view_time` , `host_name`)
	)  ENGINE=MYISAM DEFAULT CHARSET=LATIN1 COMMENT='mytest mod info';

	-- mytest info
	CREATE TABLE IF NOT EXISTS `mytest` (
		`host_name` VARCHAR(64) NOT NULL DEFAULT '',
		`time` INT(11) NOT NULL DEFAULT '0',
		`value1` DECIMAL(8 , 2 ) DEFAULT NULL,
		`value2` DECIMAL(8 , 2 ) DEFAULT NULL,
		`value3` DECIMAL(8 , 2 ) DEFAULT NULL,
		`view_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		PRIMARY KEY (`view_time` , `host_name`)
	)  ENGINE=MRG_MYISAM DEFAULT CHARSET=LATIN1 INSERT_METHOD=LAST UNION=( `mytest_1` , `mytest_2` );


其它
------------

如有问题，请联系 shanshuieast@gmail.com 。

------------

以下为Tsar原始README.md信息：

------------

Introduction
------------
Tsar (Taobao System Activity Reporter) is a monitoring tool, which can be used to gather and summarize system information, e.g. CPU, load, IO, and application information, e.g. nginx, HAProxy, Squid, etc. The results can be stored at local disk or sent to Nagios.

Tsar can be easily extended by writing modules, which makes it a powerful and versatile reporting tool.

Module introduction: [info](https://github.com/alibaba/tsar/blob/master/info.md)

Installation
-------------
Tsar is available on GitHub, you can clone and install it as follows:

    $ git clone git://github.com/kongjian/tsar.git
    $ cd tsar
    $ make
    # make install

Or you can download the zip file and install it:

    $ wget -O tsar.zip https://github.com/alibaba/tsar/archive/master.zip --no-check-certificate
    $ unzip tsar.zip
    $ cd tsar
    $ make
    # make install

After installation, you may see these files:

* `/etc/tsar/tsar.conf`, which is tsar's main configuration file;
* `/etc/cron.d/tsar`, is used to run tsar to collect information every minute;
* `/etc/logrotate.d/tsar` will rotate tsar's log files every month;
* `/usr/local/tsar/modules` is the directory where all module libraries (*.so) are located;

Configuration
-------------
There is no output displayed after installation by default. Just run `tsar -l` to see if the real-time monitoring works, for instance:

    [kongjian@tsar]$ tsar -l -i 1
    Time              ---cpu-- ---mem-- ---tcp-- -----traffic---- --xvda-- -xvda1-- -xvda2-- -xvda3-- -xvda4-- -xvda5--  ---load-
    Time                util     util   retran    pktin  pktout     util     util     util     util     util     util     load1
    11/04/13-14:09:10   0.20    11.57     0.00     9.00    2.00     0.00     0.00     0.00     0.00     0.00     0.00      0.00
    11/04/13-14:09:11   0.20    11.57     0.00     4.00    2.00     0.00     0.00     0.00     0.00     0.00     0.00      0.00

Usually, we configure Tsar by simply editing `/etc/tsar/tsar.conf`:

* To add a module, add a line like `mod_<yourmodname> on`
* To enable or disable a module, use `mod_<yourmodname> on/off`
* To specify parameters for a module, use `mod_<yourmodname> on parameter`
* `output_stdio_mod` is to set modules output to standard I/O
* `output_file_path` is to set history data file, (you should modify the logrotate script `/etc/logrotate.d/tsar` too)
* `output_interface` specifies tsar data output destination, which by default is a local file. See the Advanced section for more information.

Usage
------
* null          :see default mods history data, `tsar`
* --modname     :specify module to show, `tsar --cpu`
* -L/--list     :list available moudule, `tsar -L`
* -l/--live     :show real-time info, `tsar -l --cpu`
* -i/--interval :set interval for report, `tsar -i 1 --cpu`
* -s/--spec     :specify module detail field, `tsar --cpu -s sys,util`
* -D/--detail   :do not conver data to K/M/G, `tsar --mem -D`
* -m/--merge    :merge multiply item to one, `tsar --io -m`
* -I/--item     :show spec item data, `tsar --io -I sda`
* -d/--date     :specify data, YYYYMMDD, or n means n days ago
* -C/--check    :show the last collect data
* -h/--help     :show help, `tsar -h`

Advanced
--------
* Output to Nagios

To turn it on, just set output type `output_interface file,nagios` in the main configuration file.

You should also specify Nagios' IP address, port, and sending interval, e.g.:

    ####The IP address or the hostname running the NSCA daemon
    server_addr nagios.server.com
    ####The port on which the daemon is listening - by default it is 5667
    server_port 8086
    ####The cycle (interval) of sending alerts to Nagios
    cycle_time 300

As tsar uses Nagios' passive mode, so you should specify the nsca binary and its configuration file, e.g.:

    ####nsca client program
    send_nsca_cmd /usr/bin/send_nsca
    send_nsca_conf /home/a/conf/amon/send_nsca.conf

Then specify the module and fields to be checked. There are 4 threshold levels.

    ####tsar mod alert config file
    ####threshold servicename.key;w-min;w-max;c-min;cmax;
    threshold cpu.util;50;60;70;80;

* Output to MySQL

To use this feature, just add output type `output_interface file,db` in tsar's configuration file.

Then specify which module(s) will be enabled:

    output_db_mod mod_cpu,mod_mem,mod_traffic,mod_load,mod_tcp,mod_udpmod_io

Note that you should set the IP address (or hostname) and port where tsar2db listens, e.g.:

    output_db_addr console2:56677

Tsar2db receives sql data and flush it to MySQL. You can find more information about tsar2db at https://github.com/alibaba/tsar2db.


Module development
------------------
Tsar is easily extended. Whenever you want information that is not collected by tsar yet, you can write a module.

First, install the tsardevel tool (`make tsardevel` will do this for you):

Then run `tsardevel <yourmodname>`, and you will get a directory named yourmodname, e.g.:

    [kongjian@tsar]$ tsardevel test
    build:make
    install:make install
    uninstall:make uninstall

    [kongjian@tsar]$ ls test
    Makefile  mod_test.c  mod_test.conf

You can modify the read_test_stats() and set_test_record() functions in test.c as you need.
Then run `make;make install` to install your module and run `tsar --yourmodname` to see the output.

More
----
Homepage http://tsar.taobao.org

Any question, please feel free to contact me by kongjian@taobao.com
