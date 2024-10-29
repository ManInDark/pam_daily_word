#include <stdio.h>
#include <string.h>
#include <security/pam_ext.h>
#include <time.h>
#include <stdlib.h>

#define LIST_PATH "/etc/daily-word/list"
#define LIST_LENGTH 119
#define LINE_LENGTH 5
#define TRIES_MIN 1
#define TRIES_STD 6
#define TRIES_MAX 30

int pam_sm_acct_mgmt(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
    return PAM_PERM_DENIED;
}

int pam_sm_authenticate(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
    int tries = TRIES_STD;
    for (int i = 0; i < argc; i++)
    {
        if (strncmp(argv[i], "tries=", 6) == 0)
        {
            const char *s = &argv[i][6];
            long val = atoi(s);
            if (val >= TRIES_MIN && val <= TRIES_MAX)
            {
                tries = (int)val;
            }
        }
    }
    printf("tries: %d\n", tries);

    // get the line of the day
    time_t t = time(NULL);
    struct tm *lt = localtime(&t);
    int chosen_line = (lt->tm_yday % LIST_LENGTH);

    // read line from list
    FILE *list_file = fopen(LIST_PATH, "r");
    char line[256];
    for (int i = 0; i < chosen_line + 1; i++)
    {
        fgets(line, 256, list_file);
    }
    fclose(list_file);

    char wordle[LINE_LENGTH + 1] = {"\0"};
    strncpy(wordle, line, LINE_LENGTH);

    for (int i = 0; i < tries; i++)
    {
        // first get user input
        char **user_response;
        pam_prompt(pamh, PAM_PROMPT_ECHO_ON, user_response, "Guess wordle: ");

        printf("Response: ");
        for (size_t i = 0; i < strlen(*user_response); i++)
        {
            if (wordle[i] == (*user_response)[i])
            {
                printf("\033[0;32m%c\033[0m", (*user_response)[i]);
            }
            else if (strchr(wordle, (*user_response)[i]) != NULL)
            {
                printf("\033[0;33m%c\033[0m", (*user_response)[i]);
            }
            else
            {
                printf("%c", (*user_response)[i]);
            }
        }
        printf("\n");

        if (strcmp(*user_response, wordle) == 0)
        {
            return PAM_SUCCESS;
        }
    }
    return PAM_AUTH_ERR;
}

int pam_sm_setcred(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
    return PAM_PERM_DENIED;
}