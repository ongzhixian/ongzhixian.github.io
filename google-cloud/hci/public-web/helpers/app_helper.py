################################################################################
# Modules and functions import statements
################################################################################

import logging
import sys

from flask import url_for, get_flashed_messages
from helpers.app_runtime import jinja2_env, app_settings

################################################################################
# Functions
################################################################################

def get_model(cookie_json=None):
    caller = sys._getframe(1)                       # '_getframe(1)' gets previous stack; 
                                                    # '_getframe()' gets current stack
    caller_name = caller.f_code.co_name             # returns 'view_home'
    module_name = caller.f_globals['__name__']      # returns 'modules.default_routes'
    package_name = caller.f_globals['__package__']  # returns 'modules'

    context = cookie_json if cookie_json is not None else {}
    context['url_for'] = url_for                            # function for Flask
    context['get_flashed_messages'] = get_flashed_messages  # function for Flask
    context['app_settings'] = app_settings                  # make application settings available
    context['view_name'] = caller_name
    context['view_module'] = module_name
    context['view_package'] = package_name
    context['view_id'] = "{0}.{1}".format(module_name, caller_name)

    # context['auth_cookie'] = request.cookies.get(appconfig["application"]["auth_cookie_name"])
    # context['current_datetime'] = datetime.now()
    # context = {
    #     'auth_cookie'       : request.cookies.get(appconfig["application"]["auth_cookie_name"]),
    #     'current_datetime'  : datetime.now()
    # }
    return context

def view(model=None, view_path=None):
    if view_path is None:
        caller = sys._getframe(1)                       # '_getframe(1)' gets previous stack; 
                                                        # '_getframe()' gets current stack
        caller_name = caller.f_code.co_name             # returns 'view_home'
        module_name = caller.f_globals['__name__']      # returns 'modules.default_routes'
        package_name = caller.f_globals['__package__']  # returns 'modules'

        view_path = module_name.split('.')
        view_path.remove(package_name)
        view_path.append("{0}.html".format(caller_name))
        view_path = '/'.join(view_path)                 # returns 'default_routes/view_home.html

    logging.info("fetching view [{0}]".format(view_path))

    if model is None:
        model = get_model()

    return jinja2_env.get_template(view_path).render(model)

################################################################################
# Export module variables
################################################################################
 
 # N/A

################################################################################
# Main function
################################################################################

if __name__ == '__main__':
    pass
