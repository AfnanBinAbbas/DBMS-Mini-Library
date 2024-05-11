import psycopg2
from google.cloud import firestore #import libraries
import os

# Set up Firestore client
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = r"C:\Local Disk E\Github\serviceAccountkey.json"
db = firestore.Client()

# Function to retrieve authors from Firestore
def get_authors():
    authors_ref = db.collection('Authors')
    return authors_ref.get()

# PostgreSQL connection parameters
pg_connection_params = {
    'dbname': 'lms',
    'user': 'postgres',
    'password': 'pgadmin4',
    'host': 'localhost',
    'port': '5432'
}

# Function to fetch data from PostgreSQL and upload to Firestore
def sync_data():
    try:
        # Connect to PostgreSQL
        conn = psycopg2.connect(**pg_connection_params)
        cursor = conn.cursor()

        # Fetch data from PostgreSQL table
        cursor.execute("SELECT * FROM author")
        records = cursor.fetchall()

        # Upload data to Firestore
        for record in records:
            data = {
                'authorid': record[0],
                'name': record[1],
                'status': record[2]
            }
            # Add document to Firestore collection
            db.collection('authors').document(str(record[0])).set(data)

        print("Data synchronization completed successfully.")

    except Exception as e:
        print("Error:", e)

    finally:
        # Close PostgreSQL connection and cursor
        if 'cursor' in locals():
            cursor.close()
        if 'conn' in locals():
            conn.close()

# Execute data synchronization
sync_data()

# Retrieve authors from Firestore and print their details
authors = get_authors()
for author in authors:
    print(f"Author ID: {author.id}, Name: {author.get('name')}, Status: {author.get('status')}")

# Similar functions for other data migrations...

def migrate_categories():
    try:
        # Connect to PostgreSQL
        conn = psycopg2.connect(**pg_connection_params)
        cursor = conn.cursor()

        # Fetch data from PostgreSQL table
        cursor.execute("SELECT * FROM category")
        records = cursor.fetchall()

        # Firestore collection reference for categories
        collection_ref = db.collection('categories')

        # Upload data to Firestore
        for record in records:
            data = {
                'categoryid': record[0],
                'name': record[1],
                'status': record[2]
            }
            # Add document to Firestore collection
            collection_ref.add(data)

        print("Category migration completed successfully.")

    except Exception as e:
        print("Error:", e)

    finally:
        # Close PostgreSQL connection
        cursor.close()
        conn.close()

# Execute category migration
migrate_categories()

# Similar functions for other data migrations...

def migrate_users():
    try:
        # Connect to PostgreSQL
        conn = psycopg2.connect(**pg_connection_params)
        cursor = conn.cursor()

        # Fetch data from PostgreSQL table
        cursor.execute("SELECT * FROM \"user\"")
        records = cursor.fetchall()

        # Firestore collection reference for users
        collection_ref = db.collection('users')

        # Upload data to Firestore
        for record in records:
            data = {
                'id': record[0],
                'first_name': record[1],
                'last_name': record[2],
                'email': record[3],
                'password': record[4],
                'role': record[5]
            }
            # Add document to Firestore collection
            collection_ref.add(data)

        print("User migration completed successfully.")

    except Exception as e:
        print("Error:", e)

    finally:
        # Close PostgreSQL connection
        cursor.close()
        conn.close()

# Execute user migration
migrate_users()
