from flask import Flask, render_template, request, redirect, url_for, session
import psycopg2
import re
import psycopg2.extras
import firebase_admin
from firebase_admin import credentials

cred = credentials.Certificate(r"C:\Local Disk E\Github\serviceAccountKey.json")
firebase_admin.initialize_app(cred)

# Connect to PostgreSQL database
conn = psycopg2.connect(
    host="localhost",
    dbname="lms",
    user="postgres",
    password="pgadmin4",
    port=5432
)

cur = conn.cursor()

# Create Flask app
app = Flask(__name__,template_folder='pages')
app.secret_key = 'abcd2123445'

#Landing_Page
@app.route('/')
def home():
    return render_template('home.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    message = ''
    if request.method == 'POST' and 'email' in request.form and 'password' in request.form:
        email = request.form['email']
        password = request.form['password']
        # role = request.form['role']
        cur.execute('SELECT * FROM "user" WHERE email = %s AND password = %s', (email, password,))
        user = cur.fetchone()
        if user:
            session['loggedin'] = True
            session['userid'] = user[0]  # Assuming user id is the first column
            session['name'] = user[1]  # Assuming name is the second column
            session['email'] = user[2]  # Assuming email is the third column
            session['role'] = user[4]  # Assuming role is the sixth column
            message = 'Logged in successfully!'
            return redirect(url_for('dashboard'))
        else:
            message = 'Please enter correct email/password!'
    return render_template('login.html', message=message)

@app.route("/dashboard")
def dashboard():
    if 'loggedin' in session:
        return render_template("dashboard.html")
    return redirect(url_for('login'))

def get_db_connection():
    return psycopg2.connect(
        host="localhost",
        dbname="lms",
        user="postgres",
        password="pgadmin4",
        port=5432
    )

@app.route("/users")
def users():
    if 'loggedin' in session:
        try:
            conn = get_db_connection()
            cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
            cursor.execute('SELECT * FROM "user"')
            users = cursor.fetchall()
            cursor.close()
            conn.close()
            return render_template("users.html", users=users)
        except psycopg2.Error as e:
            # Handle database errors
            error_message = f"Database error: {e}"
            return render_template("error.html", error_message=error_message)
    return redirect(url_for('login'))

def users():
    if 'loggedin' in session:
        cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor.execute('SELECT * FROM user')
        users = cursor.fetchall()    
        return render_template("users.html", users=users)
    return redirect(url_for('login'))

@app.route("/save_user", methods =['GET', 'POST'])
def save_user():
    msg = ''    
    if 'loggedin' in session:        
        cursor = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        if request.method == 'POST' and 'role' in request.form and 'first_name' in request.form and 'last_name' in request.form and 'email' in request.form :
            
            first_name = request.form['first_name']  
            last_name = request.form['last_name'] 
            email = request.form['email']            
            role = request.form['role']             
            action = request.form['action']
            
            if action == 'updateUser':
                userId = request.form['userid']                 
                cursor.execute('UPDATE user SET first_name= %s, last_name= %s, email= %s, role= %s WHERE id = %s', (first_name, last_name, email, role, (userId, ), ))
                psycopg2.connection.commit()   
            else:
                password = request.form['password'] 
                cursor.execute('INSERT INTO user (`first_name`, `last_name`, `email`, `password`, `role`) VALUES (%s, %s, %s, %s, %s)', (first_name, last_name, email, password, role))
                psycopg2.connection.commit()   

            return redirect(url_for('users'))        
        elif request.method == 'POST':
            msg = 'Please fill out the form !'        
        return redirect(url_for('users'))      
    return redirect(url_for('login'))
