import psycopg2
from google.cloud import firestore
import os

# Set up Firestore client
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "serviceAccountkey.json"
db = firestore.Client()

# PostgreSQL connection parameters
pg_connection_params = {
    'dbname': 'LibraryManagementSystem',
    'user': 'postgres',
    'password': 'pgadmin4',
    'host': 'localhost:5432'  # Or your PostgreSQL host address
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
                'column1': record[0],  # Assuming column 1 is represented by the first value in the record
                'column2': record[1],  # Assuming column 2 is represented by the second value in the record
                # Add more columns as needed
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
authors = get_authors()
for author in authors:
    print(f"Author ID: {author.id}, Name: {author.get('name')}, Status: {author.get('status')}")