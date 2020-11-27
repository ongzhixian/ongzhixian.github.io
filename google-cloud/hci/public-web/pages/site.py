################################################################################
# Modules and functions import statements
################################################################################

import logging
from helpers.app_runtime import app
from helpers.app_helper import view, get_model


################################################################################
# Routes
################################################################################

@app.route('/')
def webroot_get():
    logging.info("In webroot_get()")
    view_model = get_model()
    return view(view_model)
