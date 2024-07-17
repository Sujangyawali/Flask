from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app=Flask(__name__)

app.config['SECRET_KEY']='d651d430e68f8e9002a8d2f94dfbca80'
app.config['SQLALCHEMY_DATABASE_URI']='sqlite:///site.db'
db=SQLAlchemy(app) # SQLAlchemy database instance

app.app_context().push()

from flaskblog import routes