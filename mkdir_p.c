#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <time.h>
#include <unistd.h>


/* source code from freebsd
 */
int mkdir_p(const char * path, mode_t omode)
{
    mode_t oumask;
    int first, last, retval;
    
    int buf_len = strlen(path);
    char * buf = (char *)malloc(sizeof(char) * (buf_len + 1));
    char * p = (char *)buf;

    strncpy(p, path, buf_len + 1);

    oumask = umask(0);
    retval = 0;
    if (p[0] == '/')        /* Skip leading '/'. */
        ++p;
    for (first = 1, last = 0; !last ; ++p) {
        if (p[0] == '\0')
            last = 1;
        else if (p[0] != '/')
            continue;
        *p = '\0';
        if (!last && p[1] == '\0')
            last = 1;

        if (mkdir(buf, omode) != 0) {
            if (errno == EEXIST) {
                if (last) {
                    retval = 1;
                    break;
                } 
            } else {
                retval = -1;
                break;
            }
        } 
        if (!last)
            *p = '/';
    }

    free(buf);
    umask(oumask);
    return (retval);
}


int main ( int argc, char *argv[] )
{
    int ret = mkdir_p("./tset/t/t/kkk", 0644);



    return 0;
}			/* ----------  end of function main  ---------- */
