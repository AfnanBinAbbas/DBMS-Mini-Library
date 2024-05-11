import psycopg2
from google.cloud import firestore
import os

# Set up Firestore client
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "serviceAccountkey.json"
db = firestore.Client()

# Function to retrieve authors from Firestore
def get_authors():
    authors_ref = db.collection('postgress_data')
    return authors_ref.get()

# PostgreSQL connection parameters
pg_connection_params = {
    'dbname': 'LibraryManagementSystem',
    'user': 'postgres',
    'password': 'pgadmin4',
    'host': 'localhost',
    'port': '5432'
}

# Firestore collection reference
collection_ref = db.collection('postgress_data')

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
            collection_ref.add(data)

        print("Data synchronization completed successfully.")

    except Exception as e:
        print("Error:", e)

    finally:
        # Close PostgreSQL connection
        cursor.close()
        conn.close()

# Execute data synchronization
sync_data()

# Retrieve authors from Firestore and print their details
authors = get_authors()
for author in authors:
    print(f"Author ID: {author.id}, Name: {author.get('name')}, Status: {author.get('status')}")
