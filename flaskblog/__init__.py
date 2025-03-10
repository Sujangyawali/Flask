from flask import Flask
from flask_sqlalchemy import SQLAlchemy #connecting to DB
from flask_bcrypt import Bcrypt #pw hashing
from flask_login import LoginManager #provides user session management
from flask_mail import Mail #sending mail to user 
from flaskblog.config import Config


db=SQLAlchemy() # SQLAlchemy database instance
bcrypt=Bcrypt()
login_manager=LoginManager()
login_manager.login_view='users.login' # Redirect to 'login' view if not authenticated
login_manager.login_message_category='info'

mail = Mail()

def create_app(config_class=Config):
    app=Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)
    bcrypt.init_app(app)
    login_manager.init_app(app)
    mail.init_app(app)

    app.app_context().push()

    from flaskblog.users.routes import users
    from flaskblog.posts.routes import posts
    from flaskblog.main.routes import main
    from flaskblog.errors.handlers import errors
    app.register_blueprint(users)
    app.register_blueprint(posts)
    app.register_blueprint(main)
    app.register_blueprint(errors)

    return app
