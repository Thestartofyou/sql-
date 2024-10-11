import sqlite3
import mysql.connector

# Database configuration for MySQL
MYSQL_CONFIG = {
    'host': 'localhost',
    'user': 'yourusername',
    'password': 'yourpassword',
    'database': 'yourdatabase'
}

def connect_to_sqlite(db_name):
    """Connect to an SQLite database."""
    return sqlite3.connect(db_name)

def connect_to_mysql():
    """Connect to a MySQL database."""
    return mysql.connector.connect(**MYSQL_CONFIG)

def create_table(cursor, db_type):
    """Create a users table."""
    if db_type == 'sqlite':
        cursor.execute('''CREATE TABLE IF NOT EXISTS users (
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            name TEXT NOT NULL,
                            age INTEGER,
                            email TEXT)''')
    elif db_type == 'mysql':
        cursor.execute('''CREATE TABLE IF NOT EXISTS users (
                            id INT AUTO_INCREMENT PRIMARY KEY,
                            name VARCHAR(255) NOT NULL,
                            age INT,
                            email VARCHAR(255))''')

def insert_data(cursor, conn, db_type):
    """Insert some test data into the table."""
    users = [('John Doe', 25, 'john@example.com'),
             ('Jane Smith', 30, 'jane@example.com'),
             ('Sam Brown', 22, 'sam@example.com')]

    if db_type == 'sqlite':
        cursor.executemany('INSERT INTO users (name, age, email) VALUES (?, ?, ?)', users)
    elif db_type == 'mysql':
        cursor.executemany('INSERT INTO users (name, age, email) VALUES (%s, %s, %s)', users)
    
    conn.commit()

def query_data(cursor):
    """Query and print all rows from the users table."""
    cursor.execute('SELECT * FROM users')
    rows = cursor.fetchall()
    for row in rows:
        print(row)

def update_data(cursor, conn, db_type):
    """Update a user's age."""
    if db_type == 'sqlite':
        cursor.execute('UPDATE users SET age = 26 WHERE name = "John Doe"')
    elif db_type == 'mysql':
        cursor.execute('UPDATE users SET age = 26 WHERE name = %s', ('John Doe',))
    
    conn.commit()

def delete_data(cursor, conn, db_type):
    """Delete a user."""
    if db_type == 'sqlite':
        cursor.execute('DELETE FROM users WHERE name = "Sam Brown"')
    elif db_type == 'mysql':
        cursor.execute('DELETE FROM users WHERE name = %s', ('Sam Brown',))
    
    conn.commit()

def close_connection(conn):
    """Close the database connection."""
    conn.close()

def main():
    # Choose your database type: 'sqlite' or 'mysql'
    db_type = 'sqlite'  # Change to 'mysql' for MySQL usage
    
    # Connect to the appropriate database
    if db_type == 'sqlite':
        conn = connect_to_sqlite('example.db')
    elif db_type == 'mysql':
        conn = connect_to_mysql()
    
    cursor = conn.cursor()

    # Perform SQL operations
    create_table(cursor, db_type)
    insert_data(cursor, conn, db_type)
    query_data(cursor)
    update_data(cursor, conn, db_type)
    delete_data(cursor, conn, db_type)
    query_data(cursor)

    # Close the connection
    close_connection(conn)

if __name__ == '__main__':
    main()
