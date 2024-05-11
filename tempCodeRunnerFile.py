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
                cursor.execute('UPDATE "user" SET first_name= %s, last_name= %s, email= %s, role= %s WHERE id = %s', (first_name, last_name, email, role, (userId, ), ))
                conn.commit()        
            else:
                password = request.form['password'] 
                cursor.execute('INSERT INTO user (`first_name`, `last_name`, `email`, `password`, `role`) VALUES (%s, %s, %s, %s, %s)', (first_name, last_name, email, password, role))
                conn.commit()          

            return redirect(url_for('users'))        
        elif request.method == 'POST':
            msg = 'Please fill out the form !'        
        return redirect(url_for('users'))      
    return redirect(url_for('login'))