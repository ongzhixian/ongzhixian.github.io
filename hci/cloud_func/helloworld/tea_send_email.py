import logging
import os
from datetime import datetime

from flask import escape

from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail

def tea_send_email(request):
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

    try:
        # This is from Google documentation
        # Think this is obsolete because we get the following error:
        # module 'sendgrid' has no attribute 'SendGridClient'; think its call SendGridAPIClient now
        #
        # sg = sendgrid.SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))
        # message = sendgrid.Mail()
        # message.add_to("zhixian@hotmail.com")
        #
        # In addition, got this error: 'Mail' object has no attribute 'set_from'
        #
        # message.set_from("you@youremail.com")
        # message.set_subject("Sending with SendGrid is Fun")
        # message.set_html("and easy to do anywhere, even with Python")
        # sg.send(message)
        
        
        # Sample from SendGrid website
        # https://app.sendgrid.com/guide/integrate/langs/python
        message = Mail(
            from_email='from_email@example.com',
            to_emails='zhixian@hotmail.com',
            subject='Sending with Twilio SendGrid is Fun',
            html_content='<strong>and easy to do anywhere, even with Python</strong>')
            
        sg = SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))
        response = sg.send(message)
        print(response.status_code)
        print(response.body)
        print(response.headers)

    except Exception as e:
        logging.error(e)
