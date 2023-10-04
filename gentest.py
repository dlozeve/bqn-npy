import numpy as np

def main():
    for endianness in "<>":
        for typ in "fiu":
            for size in "48":
                dtype=endianness + typ + size
                arr = np.zeros((2,3,4), dtype=dtype)
                np.save(f"test{dtype}.npy", arr)

if __name__ == '__main__':
    main()
