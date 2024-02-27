from flask import Flask,redirect,url_for,request

app=Flask(__name__)

#variable rule
# @app.route('/blog/<int:postID>')
# def show_blog(postID):
#     return f"Blog number {postID}!"

#redirecting url
# @app.route("/admin")
# def hello_admin():#view function
#     return f"Hello admin !"


# @app.route("/guest/<guest>")
# def hello_guest(guest):
#     return f"Hello {guest} !"


# @app.route('/user/<user>')
# def hello_user(user):
#     if user=='admin':
#         return redirect(url_for('hello_admin'))#view function name
#     else:
#         return redirect(url_for("hello_guest",guest=user))
    

##HTTP methods

@app.route('/success/<name>')
def success(name):
    return f"welcome {name}"


@app.route('/login',methods=['GET','POST']) #this means that this route can accept both get and post request 
def login():
    if request.method=='POST':
        user=request.form['nm']#object we get interms of dictioanry
        return redirect(url_for('success',name=user))
    else:
        print(request.args)
        user = request.args.get('nm')
        if user:
            return redirect(url_for('success',name = user))
        else:
            return f"Please enter valid username"

if __name__ == '__main__':
    app.run(debug=True)