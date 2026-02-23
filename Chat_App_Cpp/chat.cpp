#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include <cstring>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/select.h>

// Hằng số
const int MAX_CLIENTS = 10;
const int BUFF_SIZE = 1024;

// Cấu trúc Peer giữ nguyên nhưng dùng std::string cho tiện
struct Peer {
    int fd = 0;
    std::string ip;
    int port = 0;
    int id = -1;
};

class ChatApplication {
private:
    int listening_port;
    int listener_fd;
    std::vector<Peer> peers; // Dùng vector thay vì mảng tĩnh
    fd_set master_set;
    int max_fd;

public:
    ChatApplication(int port) : listening_port(port) {
        peers.resize(MAX_CLIENTS); // Cấp phát chỗ trước
        FD_ZERO(&master_set);
    }

    // Khởi tạo Server Socket
    bool init() {
        listener_fd = socket(AF_INET, SOCK_STREAM, 0);
        if (listener_fd == -1) {
            std::cerr << "Error creating socket." << std::endl;
            return false;
        }

        int opt = 1;
        setsockopt(listener_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

        sockaddr_in my_addr{};
        my_addr.sin_family = AF_INET;
        my_addr.sin_addr.s_addr = INADDR_ANY;
        my_addr.sin_port = htons(listening_port);

        if (bind(listener_fd, (struct sockaddr*)&my_addr, sizeof(my_addr)) < 0) {
            std::cerr << "Bind failed." << std::endl;
            return false;
        }

        if (listen(listener_fd, 10) < 0) {
            std::cerr << "Listen failed." << std::endl;
            return false;
        }

        FD_SET(STDIN_FILENO, &master_set);
        FD_SET(listener_fd, &master_set);
        max_fd = listener_fd;

        show_menu();
        std::cout << "Application is listening on port: " << listening_port << std::endl;
        return true;
    }

    // Vòng lặp chính
    void run() {
        while (true) {
            std::cout << "\nEnter your command: ";
            std::cout.flush();

            fd_set read_fds = master_set;
            if (select(max_fd + 1, &read_fds, NULL, NULL, NULL) == -1) break;

            for (int i = 0; i <= max_fd; i++) {
                if (FD_ISSET(i, &read_fds)) {
                    if (i == STDIN_FILENO) {
                        handle_user_input();
                    } else if (i == listener_fd) {
                        handle_new_connection();
                    } else {
                        handle_peer_message(i);
                    }
                }
            }
        }
    }

private:
    // Lấy IP local (Giữ nguyên logic UDP trick)
    std::string get_local_ip() {
        int sock = socket(AF_INET, SOCK_DGRAM, 0);
        if (sock == -1) return "127.0.0.1";

        sockaddr_in loopback{};
        loopback.sin_family = AF_INET;
        loopback.sin_addr.s_addr = inet_addr("8.8.8.8");
        loopback.sin_port = htons(53);

        std::string ip = "127.0.0.1";
        if (connect(sock, (struct sockaddr*)&loopback, sizeof(loopback)) != -1) {
            socklen_t len = sizeof(loopback);
            if (getsockname(sock, (struct sockaddr*)&loopback, &len) != -1) {
                ip = inet_ntoa(loopback.sin_addr);
            }
        }
        close(sock);
        return ip;
    }

    void show_menu() {
        std::cout << "\n************************************************************\n"
                  << "********** Chat Application **********\n"
                  << "Use the commands below:\n"
                  << "1. help \t: display user interface options\n"
                  << "2. myip \t: display IP address of this app\n"
                  << "3. myport \t: display listening port of this app\n"
                  << "4. connect <ip> <port> \t: connect to the app of another computer\n"
                  << "5. list \t: list all the connections of this app\n"
                  << "6. terminate <id> \t: terminate a connection\n"
                  << "7. send <id> <msg> \t: send a message to a connection\n"
                  << "8. exit \t: close all connections & terminate this app\n"
                  << "************************************************************\n";
    }

    void add_peer(int fd, std::string ip, int port) {
        for (int i = 0; i < MAX_CLIENTS; i++) {
            if (peers[i].fd == 0) {
                peers[i].fd = fd;
                peers[i].ip = ip;
                peers[i].port = port;
                peers[i].id = i;
                return;
            }
        }
    }

    void remove_peer(int fd) {
        for (auto& peer : peers) {
            if (peer.fd == fd) {
                peer.fd = 0;
                close(fd);
                FD_CLR(fd, &master_set); // Xóa khỏi master set ngay tại đây cho tiện
                return;
            }
        }
    }

    // Xử lý Input người dùng
    void handle_user_input() {
        std::string line;
        std::getline(std::cin, line);
        if (line.empty()) return;

        std::stringstream ss(line);
        std::string cmd;
        ss >> cmd; // Lấy từ đầu tiên

        if (cmd == "help") {
            show_menu();
        } else if (cmd == "myip") {
            std::cout << "My IP: " << get_local_ip() << std::endl;
        } else if (cmd == "myport") {
            std::cout << "Application is listening on port: " << listening_port << std::endl;
        } else if (cmd == "connect") {
            std::string dest_ip;
            int dest_port;
            if (ss >> dest_ip >> dest_port) { // Tự động tách và ép kiểu
                int new_sock = socket(AF_INET, SOCK_STREAM, 0);
                sockaddr_in serv_addr{};
                serv_addr.sin_family = AF_INET;
                serv_addr.sin_port = htons(dest_port);
                inet_pton(AF_INET, dest_ip.c_str(), &serv_addr.sin_addr);

                if (connect(new_sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) < 0) {
                    std::cout << "Connection failed.\n";
                } else {
                    std::cout << "Connected successfully. Ready for data transmission\n";
                    FD_SET(new_sock, &master_set);
                    if (new_sock > max_fd) max_fd = new_sock;
                    add_peer(new_sock, dest_ip, dest_port);
                }
            }
        } else if (cmd == "list") {
            std::cout << "************************************************************\n";
            printf("%-5s | %-15s | %-10s\n", "ID", "IP Address", "Port No.");
            for (const auto& peer : peers) {
                if (peer.fd != 0) {
                    printf("%-5d | %-15s | %-10d\n", peer.id, peer.ip.c_str(), peer.port);
                }
            }
            std::cout << "************************************************************\n";
        } else if (cmd == "terminate") {
            int id;
            if (ss >> id) {
                for (const auto& peer : peers) {
                    if (peer.id == id && peer.fd != 0) {
                        std::cout << "Terminate peer with ID " << id << " successfully.\n";
                        remove_peer(peer.fd); // Hàm này tự đóng socket và xóa khỏi FD_SET
                        break;
                    }
                }
            }
        } else if (cmd == "send") {
            int id;
            if (ss >> id) {
                std::string msg, temp;
                std::getline(ss, msg); // Lấy phần còn lại làm tin nhắn

                // Xóa khoảng trắng đầu dòng do getline để lại
                if (!msg.empty() && msg[0] == ' ') msg.erase(0, 1);

                for (const auto& peer : peers) {
                    if (peer.id == id && peer.fd != 0) {
                        send(peer.fd, msg.c_str(), msg.length(), 0);
                        std::cout << "Sent message successfully.\n";
                        break;
                    }
                }
            }
        } else if (cmd == "exit") {
            exit(0);
        }
    }

    void handle_new_connection() {
        sockaddr_in client_addr;
        socklen_t len = sizeof(client_addr);
        int new_fd = accept(listener_fd, (struct sockaddr*)&client_addr, &len);
        if (new_fd != -1) {
            FD_SET(new_fd, &master_set);
            if (new_fd > max_fd) max_fd = new_fd;
            std::string client_ip = inet_ntoa(client_addr.sin_addr);
            int client_port = ntohs(client_addr.sin_port);

            std::cout << "\nAccepted a new connection from address: " << client_ip 
                      << ", setup at port: " << client_port << std::endl;
            add_peer(new_fd, client_ip, client_port);
        }
    }

    void handle_peer_message(int fd) {
        char buffer[BUFF_SIZE];
        int nbytes = recv(fd, buffer, BUFF_SIZE - 1, 0);

        if (nbytes <= 0) {
            // Tìm peer để in thông báo trước khi xóa
            for (const auto& peer : peers) {
                if (peer.fd == fd) {
                    std::cout << "\nThe peer at port " << peer.port << " has disconnected.\n";
                    break;
                }
            }
            remove_peer(fd);
        } else {
            buffer[nbytes] = '\0';
            std::string msg(buffer);

            for (const auto& peer : peers) {
                if (peer.fd == fd) {
                    std::cout << "\n**************************************\n"
                              << "* Message received from: " << peer.ip << "\n"
                              << "* Sender's port: " << peer.port << "\n"
                              << "* Message: " << msg << "\n"
                              << "**************************************\n";
                    break;
                }
            }
        }
    }
};

int main(int argc, char *argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: ./chat <port>" << std::endl;
        return 1;
    }

    int port = std::stoi(argv[1]);
    ChatApplication app(port);

    if (app.init()) {
        app.run();
    }

    return 0;
}