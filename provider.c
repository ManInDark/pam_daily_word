#include <stdio.h>
#include <string.h>
#include <security/pam_ext.h>
#include <time.h>

#define LIST_PATH "/etc/daily-word/list"
#define LIST_LENGTH 20
#define LINE_LENGTH 5

int pam_sm_acct_mgmt(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
    return PAM_PERM_DENIED;
}

int pam_sm_authenticate(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
    // first get user input
    char **user_response;
    pam_prompt(pamh, PAM_PROMPT_ECHO_ON, user_response, "Guess wordle: ");

    // then get the line of the day
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

    printf("line: %s\n", wordle);

    if (strcmp(*user_response, wordle) != 0)
    {
        return PAM_AUTH_ERR;
    }

    return PAM_SUCCESS;
}

int pam_sm_setcred(pam_handle_t *pamh, int flags, int argc, const char **argv)
{
    return PAM_PERM_DENIED;
}