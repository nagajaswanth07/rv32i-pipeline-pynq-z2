import struct
import sys

def bin_to_hex(bin_file, hex_file, num_words=256):
    try:
        with open(bin_file, 'rb') as f:
            data = f.read()
    except FileNotFoundError:
        print(f"ERROR: {bin_file} not found!")
        sys.exit(1)

    # Pad to word boundary
    while len(data) % 4 != 0:
        data += b'\x00'

    words = []
    for i in range(0, len(data), 4):
        word = struct.unpack('<I', data[i:i+4])[0]
        words.append(word)

    # Pad remaining with NOP (ADDI x0,x0,0)
    while len(words) < num_words:
        words.append(0x00000013)

    with open(hex_file, 'w') as f:
        for word in words[:num_words]:
            f.write(f'{word:08X}\n')

    print(f"SUCCESS: {hex_file} generated with {num_words} words")
    print(f"First 8 instructions:")
    for i, w in enumerate(words[:8]):
        print(f"  [{i}] {w:08X}")

bin_to_hex('program.bin', 'program.hex', num_words=256)