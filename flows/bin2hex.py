import sys

def main():
    word_remaining = 16 * 1024

    with open('fw.bin', mode='rb') as binfile:
        with open('fw.hex', mode='w') as hexfile:
            while word := binfile.read(4):
                hex_data = ''.join(f'{byte:02X}' for byte in word[::-1])
                hexfile.write(hex_data + '\n')
                word_remaining -= 1

            for i in range(word_remaining):
                hexfile.write('00000000\n')
            

if __name__ == '__main__':
    main()
