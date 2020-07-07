import logging
from datetime import datetime
from google.cloud import datastore

from flask import escape

def tea_message(request):
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
    request_args = request.args

    if request_json and 'msg' in request_json:
        msg = request_json['msg']
    elif request_args and 'msg' in request_args:
        msg = request_args['msg']
    else:
        msg = 'World'

    try:
        op_datetime = datetime.utcnow()

        # Instantiates a client
        db = datastore.Client(namespace="hci")

        # The kind for the new entity
        kind = 'tea_message'
        entity_key = db.key(kind)

        # Prepares the new entity
        new_entity = datastore.Entity(key=entity_key)
        new_entity['description'] = 'Buy milk'
        new_entity['message'] = msg
        new_entity['cre_dt'] = datetime.utcnow()

        # Saves the entity
        db.put(new_entity)

    except Exception as e:
        logging.error(e)
