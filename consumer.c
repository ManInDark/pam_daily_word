#include <security/pam_misc.h>

static int pam_conversation(int num_msg, const struct pam_message **msg, struct pam_response **resp, void *appdata_ptr)
{
    struct pam_response *responses;

    if (num_msg <= 0)
        return PAM_CONV_ERR;

    responses = calloc(num_msg, sizeof(struct pam_response));
    if (responses == NULL)
        return PAM_BUF_ERR;

    for (int i = 0; i < num_msg; i++)
    {
        responses[i].resp = NULL;
        responses[i].resp_retcode = 0;

        switch (msg[i]->msg_style)
        {
        case PAM_PROMPT_ECHO_OFF:
            /* Silent input prompt (passwords, typically) */
            responses[i].resp = strdup(getpass(msg[i]->msg));
            break;

        case PAM_PROMPT_ECHO_ON:
            /* Visible input prompt */
            printf("%s", msg[i]->msg);
            responses[i].resp = malloc(256);
            fgets(responses[i].resp, 256, stdin);
            responses[i].resp[strcspn(responses[i].resp, "\n")] = 0;
            break;

        case PAM_ERROR_MSG:
            /* Error message */
            fprintf(stderr, "%s\n", msg[i]->msg);
            break;

        case PAM_TEXT_INFO:
            /* Informational message */
            printf("%s\n", msg[i]->msg);
            break;

        default:
            free(responses);
            return PAM_CONV_ERR;
        }
    }

    *resp = responses;
    return PAM_SUCCESS;
}

int main(int argc, char *argv[])
{
    pam_handle_t *pamh = NULL;
    struct pam_conv pam_conv = {pam_conversation, NULL};
    int pam_status;

    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s <username>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    const char *username = argv[1];

    pam_status = pam_start("test_app", username, &pam_conv, &pamh);

    if (pam_status != PAM_SUCCESS)
    {
        fprintf(stderr, "pam_start() failed: %s\n", pam_strerror(pamh, pam_status));
        exit(EXIT_FAILURE);
    }

    /* Authenticate user */
    pam_status = pam_authenticate(pamh, 0);
    if (pam_status == PAM_SUCCESS)
    {
        printf("Authentication successful\n");
    }
    else
    {
        printf("Authentication failed: %s\n", pam_strerror(pamh, pam_status));
    }

    /* Clean up PAM handle */
    pam_end(pamh, pam_status);

    return (pam_status == PAM_SUCCESS ? EXIT_SUCCESS : EXIT_FAILURE);
}
