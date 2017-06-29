
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

int get_onesql_status(char *result);

#define STATS_TEST_SIZE (sizeof(struct stats_onesql))

#define CMD_STRING	"/usr/local/tsar/modules/onesql.sh"

#define RESULT_SIZE	((int)2048)
#define BUFFER_SIZE ((int)512)

static const char *onesql_usage = "    --onesql               onesql information";

/*
 * temp structure for collection infomation.
 */
struct stats_onesql {
	unsigned long long qps;
	unsigned long long tps;
	unsigned long long rdrio;
	unsigned long long bfrd;
	unsigned long long ird;
	unsigned long long iwr;
	unsigned long long qc;
	unsigned long long tc;
	unsigned long long rlwa;
};

/* Structure for tsar */
static struct mod_info onesql_info[] = {
	{"   qps", SUMMARY_BIT, 0, STATS_NULL},
	{"   tps", SUMMARY_BIT, 0, STATS_NULL},
	{" rdrio", SUMMARY_BIT, 0, STATS_NULL},
	{"  bfrd", DETAIL_BIT, 0, STATS_NULL},
	{"   ird", DETAIL_BIT, 0, STATS_NULL},
    {"   iwr", DETAIL_BIT,  0,  STATS_NULL},
    {"    qc", DETAIL_BIT,  0,  STATS_NULL},
    {"    tc", DETAIL_BIT,  0,  STATS_NULL},
    {"  rlwa", DETAIL_BIT,  0,  STATS_NULL},
};

static void
read_onesql_stats(struct module *mod, const char *parameter)
{
    /* parameter actually equals to mod->parameter */
    char               buf[RESULT_SIZE];
    struct stats_onesql  st_onesql;
	//char *p;

    memset(buf, 0, sizeof(buf));
    memset(&st_onesql, 0, sizeof(struct stats_onesql));

	get_onesql_status(buf);

    /* send data to tsar you can get it by pre_array&cur_array at set_onesql_record */
    set_mod_record(mod, buf);
    return;
}

static void
set_onesql_record(struct module *mod, double st_array[],
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
    register_mod_fields(mod, "--onesql", onesql_usage, onesql_info, 9, read_onesql_stats, set_onesql_record);
}


int
get_onesql_status(char *result)
{
	int ret = 0;
	FILE *ptr;
	char buffer[BUFFER_SIZE];

	memset(buffer, 0, sizeof(buffer));

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
