import logging
from datetime import datetime
from google.cloud import storage

from flask import escape

def tea_file(request):
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
        storage_client = storage.Client()

        # The name for the new bucket
        bucket_name = "hci-zxshell"

        # Creates the new bucket
        #bucket = storage_client.create_bucket(bucket_name)
        bucket = storage_client.get_bucket(bucket_name)

        if bucket is None:
            logging.info("bucket is None")
        else:
            logging.info("OK we got bucket")
        # print("Bucket {} created.".format(bucket.name))

        # # Create a new blob and upload the file's content.
        logging.info("create blob")
        my_file = bucket.blob('test_file01.txt')

        # # # create in memory file
        # logging.info("Write to mem")
        # output = io.StringIO("This is a test \n")

        # # # upload from string
        logging.info("Upload from string")
        # my_file.upload_from_string(output.read(), content_type="text/plain")
        my_file.upload_from_string('V')

        # logging.info("Close")
        # output.close()

        # # list created files
        if bucket is None:
            logging.info("bucket is None")
        else:
            blobs = storage_client.list_blobs(bucket)
            if blobs is None:
                logging.info("blobs is None")
            else:
                logging.info("blobs is exists")
            for blob in blobs:
                # print(blob.name)
                logging.info(blob.name)

        # # Make the blob publicly viewable.
        # my_file.make_public()

        return "OK2"

    except Exception as e:
        logging.error(e)
        return e
