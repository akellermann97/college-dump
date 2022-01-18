#!/usr/local/bin/python3.6

__author__ = "Alexander Kellermann"
__email__ = "akn1736@g.rit.edu"


def main():
    num1 = int(input("Insert hex 1: "), 16)
    num2 = int(input("Insert hex 2: "), 16)
    print("You put", num1, num2)
    our_number = russian_peas(num1, num2)
    print(int(our_number))
    print(bin(mod_by_AES(our_number)))
    print(hex(our_number))


def russian_peas(num1, num2):
    """ We're trying to implement AES polynomial using bit strings. There are two
    params, and one return value.

    The AES Irreducible is: P(x) = x8 + x4 + x3 + x + 1
    Which should be 0x11A in Hex
    So if the number multiplied together is larger than 0xFF we need to mod by
    0x11A
    """

    # If the num1 == 1, then we're at the point where we need to add
    # up all the remaining numbers, return up the stack.

    if num1 == 0x1:
        return num2

    newNum1 = num1 // 0x2
    newNum2 = num2 * 0x2

    if num1 % 0x2 == 0x0:
        return russian_peas(newNum1, newNum2) ^ 0x0
    else:
        return russian_peas(newNum1, newNum2) ^ num2


def mod_by_AES(hex_num):
    """ Here we take a hex_num and we mod it by the AES irreducible.
    This is a helper method to the russian_peas method
    """
    AES_IRREDUCIBLE = 0x11A

    if hex_num > 0xFF:
        hex_num = hex_num % AES_IRREDUCIBLE

    return hex_num


if __name__ == "__main__":
    main()
