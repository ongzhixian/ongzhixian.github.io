import logging
from datetime import datetime
from google.cloud import datastore

from flask import escape

def tea_batch(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
        <http://flask.pocoo.org/docs/1.0/api/#flask.Request>
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
        <http://flask.pocoo.org/docs/1.0/api/#flask.Flask.make_response>.
    """
    request_json = request.get_json(silent=True)
    # request_args = request.args
    if request_json is None:
        return "is None"

    # if request_json and 'msg' in request_json:
        # msg = request_json['msg']
    # elif request_args and 'msg' in request_args:
        # msg = request_args['msg']
    # else:
        # msg = 'World'
    if len(request_json) > 1:
        # handle multiple here
        return "handle multiple {0} here".format(len(request_json))
    elif len(request_json) == 1:
        return request_json["msg"]
    else:
        return "no data"
        # is < 1 or == 1
    
    # if request_json is None:
        # return "is None"
    # else:
        # return str(len(request_json))