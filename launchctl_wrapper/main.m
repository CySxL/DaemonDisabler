#include <stdio.h>
#include <spawn.h>
#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <roothide.h>

extern char **environ;

static int run_launchctl(char *args[]) {
    pid_t pid;
    int status;
    if (posix_spawn(&pid, jbroot("/usr/bin/launchctl"), NULL, NULL, args, environ) != 0) return -1;
    waitpid(pid, &status, 0);
    if (WIFEXITED(status)) return WEXITSTATUS(status);
    return -1;
}

int main(int argc, char *argv[], char *envp[]) {
    (void)envp;
    setuid(0);
    setuid(0);
    setgid(0);

    if (argc < 3 || (strcmp(argv[1], "disable") != 0 && strcmp(argv[1], "enable") != 0)) {
        pid_t pid;
        int status;
        argv[0] = "launchctl";
        posix_spawn(&pid, jbroot("/usr/bin/launchctl"), NULL, NULL, argv, environ);
        waitpid(pid, &status, 0);
        return 0;
    }

    char *action = argv[1];
    char *ident  = argv[2];
    char *plist_path = (argc >= 4) ? argv[3] : NULL;

    const char *domains[] = {"system", "user/foreground", "gui/501", "user/501"};
    int ndomains = 4;

    for (int i = 0; i < ndomains; i++) {
        char target[512];
        snprintf(target, sizeof(target), "%s/%s", domains[i], ident);
        char *args[] = {"launchctl", action, target, NULL};
        int result = run_launchctl(args);
        if (result == 0) {
            if (strcmp(action, "enable") == 0 && plist_path != NULL) {
                char *boot_args[] = {"launchctl", "bootstrap", (char *)domains[i], (char *)rootfs(plist_path), NULL};
                run_launchctl(boot_args);
            } else if (strcmp(action, "disable") == 0) {
                char *boot_args[] = {"launchctl", "bootout", target, NULL};
                run_launchctl(boot_args);
            }
            return 0;
        }
    }
    return 1;
}
