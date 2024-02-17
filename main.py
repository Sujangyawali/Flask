from flask import Flask

app=Flask(__name__)

@app.route('/blog/<int:postID>')
def show_blog(postID):
    return f"Blog number {postID}!"
    
if __name__ == '__main__':
    app.run(debug=True)