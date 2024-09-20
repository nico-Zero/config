import threading
import time
import itertools
import sys


def count(t):
    for i in range(1, t + 1):
        sys.stdout.write(f" - {i}")
        time.sleep(1)
    return None


def loading_animation():
    spinner = itertools.cycle(["⢿", "⣻", "⣽", "⣾", "⣷", "⣯", "⣟", "⡿"])
    while True:
        sys.stdout.write("\r" + next(spinner) + " Loading")
        sys.stdout.flush()
        time.sleep(0.1)


therad = threading.Thread(target=loading_animation, daemon=True)
therad.start()
count(3)
therad.join()
