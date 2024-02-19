from flask import Flask,redirect,url_for

app=Flask(__name__)

#variable rule
# @app.route('/blog/<int:postID>')
# def show_blog(postID):
#     return f"Blog number {postID}!"

#redirecting url
@app.route("/admin")
def hello_admin():#view function
    return f"Hello admin !"


@app.route("/guest/<guest>")
def hello_guest(guest):
    return f"Hello {guest} !"


@app.route('/user/<user>')
def hello_user(user):
    if user=='admin':
        return redirect(url_for('hello_admin'))#view function name
    else:
        return redirect(url_for("hello_guest",guest=user))
    

if __name__ == '__main__':
    app.run(debug=True)