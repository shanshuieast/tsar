
/*
 * (C) 2010-2011 Alibaba Group Holding Limited
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */


#include "tsar.h"
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

int get_mongodb_status(char *result);

#define STATS_TEST_SIZE (sizeof(struct stats_mongodb))

#define CMD_STRING	"/usr/local/tsar/modules/mongodb.py"

#define RESULT_SIZE	((int)2048)
#define BUFFER_SIZE ((int)512)

static const char *mongodb_usage = "    --mongodb               mongodb information";

/*
 * temp structure for collection infomation.
 */
struct stats_mongodb {
	unsigned long long insert;
	unsigned long long query;
	unsigned long long update;
	unsigned long long delete;
	unsigned long long getmore;
	unsigned long long command;
	unsigned long long bgflush;
	unsigned long long mapped;
	unsigned long long virtual;
	unsigned long long resident;
	unsigned long long pf;
	unsigned long long lockrio;
	unsigned long long btreerio;
	unsigned long long wait4lock;
	unsigned long long r4lock;
	unsigned long long w4lock;
	unsigned long long ac;
	unsigned long long ar;
	unsigned long long aw;
	unsigned long long oc;
	unsigned long long ocrio;
	unsigned long long sd;
	unsigned long long assert;
};

/* Structure for tsar */
static struct mod_info mongodb_info[] = {
	{"insert", SUMMARY_BIT, 0, STATS_NULL},
	{"query", SUMMARY_BIT, 0, STATS_NULL},
	{"update", SUMMARY_BIT, 0, STATS_NULL},
	{"delete", SUMMARY_BIT, 0, STATS_NULL},
	{"getmore", SUMMARY_BIT, 0, STATS_NULL},
    {"command", SUMMARY_BIT,  0,  STATS_NULL},
    {"bgflush", DETAIL_BIT,  0,  STATS_NULL},
    {"mapped", DETAIL_BIT,  0,  STATS_NULL},
    {"virtual", DETAIL_BIT,  0,  STATS_NULL},
    {"resident", DETAIL_BIT,  0,  STATS_NULL},
    {"pf", DETAIL_BIT,  0,  STATS_NULL},
    {"lockrio", DETAIL_BIT,  0,  STATS_NULL},
    {"btreerio", DETAIL_BIT,  0,  STATS_NULL},
    {"wait4lock", DETAIL_BIT,  0,  STATS_NULL},
    {"r4lock", DETAIL_BIT,  0,  STATS_NULL},
    {"w4lock", DETAIL_BIT,  0,  STATS_NULL},
    {"ac", DETAIL_BIT,  0,  STATS_NULL},
    {"ar", DETAIL_BIT,  0,  STATS_NULL},
    {"aw", DETAIL_BIT,  0,  STATS_NULL},
    {"oc", DETAIL_BIT,  0,  STATS_NULL},
    {"ocrio", DETAIL_BIT,  0,  STATS_NULL},
    {"sd", DETAIL_BIT,  0,  STATS_NULL},
    {"assert", DETAIL_BIT,  0,  STATS_NULL}
};

static void
read_mongodb_stats(struct module *mod, const char *parameter)
{
    /* parameter actually equals to mod->parameter */
    char               buf[RESULT_SIZE];
    struct stats_mongodb  st_mongodb;
	//char *p;

    memset(buf, 0, sizeof(buf));

    memset(&st_mongodb, 0, sizeof(struct stats_mongodb));

	get_mongodb_status(buf);

    /* send data to tsar you can get it by pre_array&cur_array at set_mongodb_record */
    set_mod_record(mod, buf);
    return;
}

static void
set_mongodb_record(struct module *mod, double st_array[],
    U_64 pre_array[], U_64 cur_array[], int inter)
{
    int i;
    /* set st record */
    for (i = 0; i < mod->n_col; i++) {
        st_array[i] = cur_array[i];
    }
}

/* register mod to tsar */
void
mod_register(struct module *mod)
{
    register_mod_fields(mod, "--mongodb", mongodb_usage, mongodb_info, 23, read_mongodb_stats, set_mongodb_record);
}


int
get_mongodb_status(char *result)
{
	int ret = 0;
	FILE *ptr;
	char buffer[BUFFER_SIZE];

	ptr = popen(CMD_STRING, "r");
	if (ptr == (FILE *)NULL) {
		perror("popen");
		ret = errno;
	} else {

		while (!feof(ptr)) {
			char *count;
			count = fgets(buffer, BUFFER_SIZE, ptr);
			if (count!=(char *)NULL && (strlen(result)+strlen(buffer))<RESULT_SIZE)
					strcat(result, buffer);
		}
		pclose(ptr);
	}

	// Remove 'Enter'
	result[strlen(result)-1] = '\0';

	return ret;
}
