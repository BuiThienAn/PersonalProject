Yêu cầu:
- 1 board S32K144
- 1 Debugger: JLINKv9
- Download S32DS làm IDE
- Download Hercules làm terminal cho máy tính
- Kết nối máy tính và board thông qua JLINKv9

Hướng dẫn sử dụng:
- Mở Bootapp_Final/src/main.c
- Debug main.c xuống FLASH. (Bấm unpause để chạy chương trình bootloader sau khi đã flash xuống)
- Terminate chương trình bên S32DS
- Mở Hercules, mở tab UART và chỉnh baudrate sang 115200. Sau đó nhấn Open để kết nối máy tính xuống board
- Ấn cùng lúc BUTTON0 và RST (reset) để xóa vùng Userapp.
- Gửi file SREC từ hercules qua (File S32K144_BlinkLED_Exercise2.srec được đính kèm trong thư mục ngoài cùng)
- Ấn RST -> Hoàn thành
