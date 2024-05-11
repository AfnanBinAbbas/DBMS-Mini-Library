import psycopg2
from google.cloud import firestore
import os

# Set up Firestore client
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "serviceAccountkey.json"
db = firestore.Client()

# Function to retrieve authors from Firestore
def get_authors():
    authors_ref = db.collection('Authors')
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
collection_ref = db.collection('Authors')

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

# Function to fetch data from PostgreSQL and upload to Firestore
def migrate_data():
    try:
        # Connect to PostgreSQL
        conn = psycopg2.connect(**pg_connection_params)
        cursor = conn.cursor()

        # Fetch data from PostgreSQL table
        cursor.execute("SELECT * FROM book")
        records = cursor.fetchall()

        # Firestore collection reference
        collection_ref = db.collection('books')

        # Upload data to Firestore
        for record in records:
            data = {
                'bookid': record[0],
                'categoryid': record[1],
                'authorid': record[2],
                'rackid': record[3],
                'name': record[4],
                'picture': record[5],
                'publisherid': record[6],
                'isbn': record[7],
                'no_of_copy': record[8],
                'status': record[9],
                'added_on': record[10].isoformat(),  # Convert timestamp to ISO format
                'updated_on': record[11].isoformat()  # Convert timestamp to ISO format
            }
            # Add document to Firestore collection
            collection_ref.add(data)

        print("Data migration completed successfully.")

    except Exception as e:
        print("Error:", e)

    finally:
        # Close PostgreSQL connection
        cursor.close()
        conn.close()

# Execute data migration
migrate_data()

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
def migrate_issued_books():
    try:
        # Connect to PostgreSQL
        conn = psycopg2.connect(**pg_connection_params)
        cursor = conn.cursor()

        # Fetch data from PostgreSQL table
        cursor.execute("SELECT * FROM issued_book")
        records = cursor.fetchall()

        # Firestore collection reference for issued books
        collection_ref = db.collection('issued_books')

        # Upload data to Firestore
        for record in records:
            data = {
                'issuebookid': record[0],
                'bookid': record[1],
                'userid': record[2],
                'issue_date_time': record[3].isoformat(),  # Convert timestamp to ISO format
                'expected_return_date': record[4].isoformat(),  # Convert timestamp to ISO format
                'return_date_time': record[5].isoformat(),  # Convert timestamp to ISO format
                'status': record[6]
            }
            # Add document to Firestore collection
            collection_ref.add(data)

        print("Issued book migration completed successfully.")

    except Exception as e:
        print("Error:", e)

    finally:
        # Close PostgreSQL connection
        cursor.close()
        conn.close()

# Execute issued book migration
migrate_issued_books()
def migrate_publishers():
    try:
        # Connect to PostgreSQL
        conn = psycopg2.connect(**pg_connection_params)
        cursor = conn.cursor()

        # Fetch data from PostgreSQL table
        cursor.execute("SELECT * FROM publisher")
        records = cursor.fetchall()

        # Firestore collection reference for publishers
        collection_ref = db.collection('publishers')

        # Upload data to Firestore
        for record in records:
            data = {
                'publisherid': record[0],
                'name': record[1],
                'status': record[2]
            }
            # Add document to Firestore collection
            collection_ref.add(data)

        print("Publisher migration completed successfully.")

    except Exception as e:
        print("Error:", e)

    finally:
        # Close PostgreSQL connection
        cursor.close()
        conn.close()

# Execute publisher migration
migrate_publishers()
def get_racks():
    racks_ref = db.collection('racks')
    return racks_ref.get()

# PostgreSQL connection parameters for rack migration
pg_connection_params = {
    'dbname': 'LibraryManagementSystem',
    'user': 'postgres',
    'password': 'pgadmin4',
    'host': 'localhost',
    'port': '5432'
}

# Function to fetch data from PostgreSQL and upload to Firestore for rack migration
def migrate_racks():
    try:
        # Connect to PostgreSQL
        conn = psycopg2.connect(**pg_connection_params)
        cursor = conn.cursor()

        # Fetch data from PostgreSQL table
        cursor.execute("SELECT * FROM rack")
        records = cursor.fetchall()

        # Firestore collection reference for racks
        collection_ref = db.collection('racks')

        # Upload data to Firestore
        for record in records:
            data = {
                'rackid': record[0],
                'name': record[1],
                'status': record[2]
            }
            # Add document to Firestore collection
            collection_ref.add(data)

        print("Rack migration completed successfully.")

    except Exception as e:
        print("Error:", e)

    finally:
        # Close PostgreSQL connection
        cursor.close()
        conn.close()

# Execute rack migration
migrate_racks()

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
