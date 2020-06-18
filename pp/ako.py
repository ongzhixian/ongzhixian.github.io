# Imports
import logging

################################################################################
# Setup logging

formatter = logging.Formatter('%(asctime)s %(levelname)s - %(message)s')

ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)
ch.setFormatter(formatter)

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
logger.addHandler(ch)

################################################################################
# functions

# ['Cipher', 'Hash', 'Protocol', 'PublicKey', 'Util', 'Signature', 'IO', 'Math']

def x():
    logging.info("xxx")


################################################################################
# main script

if __name__ == "__main__":
    logging.info("[START]")
    x()
    logging.info("[END]")