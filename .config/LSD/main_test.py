from itertools import cycle
from PIL import Image


def decode(img_path, delimiter: str = "11111110"):
    image = Image.open(img_path)
    image = image.convert("RGB")
    pixels = list(image.getdata())  # type: ignore
    binary_message = ""

    iter = cycle(range(len(pixels[0])))
    for pixel in pixels:
        cp = next(iter)
        channel = pixel[cp]
        binary_message += str(channel & 1)

    binary_chars = [binary_message[i : i + 8] for i in range(0, len(binary_message), 8)]
    message = ""
    for binary_char in binary_chars:
        if binary_char == delimiter:
            break
        message += chr(int(binary_char, 2))
        print(chr(int(binary_char, 2)))
    return message


d = decode("./encode.png")
# print(d)
