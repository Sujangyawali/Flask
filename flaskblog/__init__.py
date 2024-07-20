from flask import Flask
from flask_sqlalchemy import SQLAlchemy #connecting to DB
from flask_bcrypt import Bcrypt #pw hashing
from flask_login import LoginManager #provides user session management

app=Flask(__name__)

app.config['SECRET_KEY']='d651d430e68f8e9002a8d2f94dfbca80'
app.config['SQLALCHEMY_DATABASE_URI']='sqlite:///site.db'
db=SQLAlchemy(app) # SQLAlchemy database instance
bcrypt=Bcrypt(app)
login_manager=LoginManager(app)
login_manager.login_view='login' # Redirect to 'login' view if not authenticated
login_manager.login_message_category='info'


app.app_context().push()
 
from flaskblog import routes