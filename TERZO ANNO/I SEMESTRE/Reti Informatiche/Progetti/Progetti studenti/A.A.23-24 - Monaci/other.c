#include <sys/types.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <netinet/in.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "strutture.h"
#include "funzioni.h"

int main(int argc, char** argv){
    int listener, ret, len, serverfd, fdmax, i;
    struct sockaddr_in my_addr, cl_addr;
    fd_set master, work;
    pid_t pid;

    // init socket
    listener = socket(AF_INET, SOCK_STREAM, 0);
    memset(&my_addr, 0, sizeof(my_addr));
    my_addr.sin_family = AF_INET;
    my_addr.sin_port = htons(DEFAULT_SM_PORT);
    inet_pton(AF_INET, LOCALHOST, &my_addr.sin_addr);

    // bind socket
    ret = bind(listener, (struct sockaddr*) &my_addr, sizeof(my_addr));
    if(ret < 0){
        perror("Bind fallita");
        exit(1);
    }

    // init listen queue
    ret = listen(listener, 10);
    if(ret < 0){
        perror("Listen fallita");
        exit(1);
    }

    printf("Shadowman running on port %d\n", DEFAULT_SM_PORT);
    
    FD_ZERO(&master);
    FD_ZERO(&work);

    FD_SET(listener, &master);
    FD_SET(STDIN_FILENO, &master);

    fdmax = listener;

    for(;;){
        work = master;
        select(fdmax + 1, &work, NULL, NULL, NULL);

        for(i = 0; i <= fdmax; i++){
            if(FD_ISSET(i, &work)){ 
                if(i == listener){
                    // listening for requests
                    len = sizeof(cl_addr);
                    serverfd = accept(listener, (struct sockaddr*) &cl_addr, (socklen_t *)&len);
                    
                    printf("Connessione accettata!\n");

                    pid = fork();

                    if(pid == 0){
                        close(listener);
                        srand(time(NULL));

                        uint8_t r = rand() % 6 + 1;
                        printf("\033[1;33mLOG:\033[0m estratto %d\n", r);

                        ret = send(serverfd, (void*)&r, DIM_UINT8, 0);
                        if(ret < DIM_UINT8){
                            perror("Problemi con l'invio del dado");
                            exit(1);
                        }
                        close(serverfd);
                        exit(1);
                    } else {
                        close(serverfd);
                    }
                } else {
                    // stdin per comando di stop
                    char cmd[8] = "";
                    while(1){
                        scanf("%s", cmd);
                        if(strcmp(cmd, "stop") == 0)
                            break;
                    }
                    printf("\033[1;31mShadowman shutdown. . .\033[0m\n");
                    close(listener);
                    close(serverfd);
                    exit(0);
                }
            }
        }
    }

    return 0;
}